using Microsoft.AspNetCore.Mvc;
using MissedLoadsApi.Models;
using MissedLoadsApi.Helpers;
using System.Net;
using System.Net.Sockets;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace MissedLoadsApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportsController : ControllerBase
    {
        // 1. Create a field to store the configuration
        private readonly IConfiguration _config;

        // 2. Update the constructor to inject IConfiguration
        public ReportsController(IConfiguration config)
        {
            _config = config;
        }

        [Authorize]
        [HttpPost("submit")]
        public IActionResult SubmitReports([FromBody] DailyReport dailyReport)
        {
            try
            {
                // Get identity from JWT token
                var username = User.Identity?.Name;
                var driverId = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
                var companyClaim = User.Claims.FirstOrDefault(c => c.Type == "Company")?.Value;
                
                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(driverId) || string.IsNullOrEmpty(companyClaim))
                {
                    return Unauthorized("Driver identity or company claim is missing from the token.");
                }

                if (!int.TryParse(companyClaim, out int companyId))
                {
                    return Unauthorized("Invalid company ID in token.");
                }

                // Override company with the one from the token
                dailyReport.Company = companyId;
                
                // Get IP address
                string ip = GetLocalIPAddress();

                // Generate DailyReport XML
                string dailyXml = XmlHelper.GenerateDailyReportXml(dailyReport, username, ip);

                // Convert to MissedLoadReport model for the second file
                var missedLoadReport = new MissedLoadReport
                {
                    Company = dailyReport.Company,
                    Date = dailyReport.Date,
                    MissedLoads = dailyReport.MissedLoads.Select(ml => new MissedLoadItem
                    {
                        ReasonType = ml.ReasonType,
                        Reason = ml.Reason,
                        Missed = ml.Missed,
                        Notes = ml.Notes
                    }).ToList()
                };

                // Generate MissedLoad XML
                string missedXml = XmlHelper.GenerateMissedLoadReportXml(missedLoadReport);

                // Create timestamped filenames
                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string dailyFilename = $"TCDR_{User.Identity?.Name}_{timestamp}.xml";
                string missedFilename = $"TCML_{User.Identity?.Name}_{timestamp}.xml";

                // 3. Update these calls to pass the _config object as the 3rd argument
                SftpUploader.Upload(dailyXml, dailyFilename, _config);
                SftpUploader.Upload(missedXml, missedFilename, _config);

                return Ok("Daily and missed load reports submitted.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Submission failed: {ex.Message}");
            }
        }

        private string GetLocalIPAddress()
        {
            try
            {
                using var socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, 0);
                socket.Connect("8.8.8.8", 65530);
                var endPoint = socket.LocalEndPoint as IPEndPoint;
                return endPoint?.Address.ToString() ?? "Unknown";
            }
            catch
            {
                return "Unknown";
            }
        }
    }
}