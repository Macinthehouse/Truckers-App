using MissedLoadsApi.Models;
using System.Globalization;
using System.Text;

namespace MissedLoadsApi.Helpers
{
    public static class XmlHelper
    {
        public static string GenerateDailyReportXml(DailyReport report, string username, string ip)
        {
            var sb = new StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            sb.AppendLine("<TC_DailyReports>");
            sb.AppendLine(" <TC_DailyReport>");
            sb.AppendLine($"  <ReportDate>{report.Date.ToString("yyyy/MM/dd")}</ReportDate>");
            sb.AppendLine($"  <TC_ID>{report.Company}</TC_ID>");
            sb.AppendLine($"  <AnticipatedLoads>{report.LoadsAnticipated}</AnticipatedLoads>");
            sb.AppendLine($"  <Notes>{report.Notes}</Notes>");
            sb.AppendLine($"  <UserID>{username}</UserID>");
            sb.AppendLine($"  <IP>{ip}</IP>");
            sb.AppendLine(" </TC_DailyReport>");
            sb.AppendLine("</TC_DailyReports>");
            return sb.ToString();
        }

        public static string GenerateMissedLoadReportXml(MissedLoadReport report)
        {
            var sb = new StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            sb.AppendLine("<TC_Missed_Loads>");

            foreach (var item in report.MissedLoads)
            {
                sb.AppendLine(" <TC_Missed_Load>");
                sb.AppendLine($"  <ReportDate>{report.Date.ToString("yyyy/MM/dd")}</ReportDate>");
                sb.AppendLine($"  <TC_ID>{report.Company}</TC_ID>");
                sb.AppendLine($"  <LMR_ID>{item.ReasonType}</LMR_ID>");
                sb.AppendLine($"  <MissedLoads>{item.Missed}</MissedLoads>");
                sb.AppendLine($"  <Notes>{item.Notes}</Notes>");
                sb.AppendLine(" </TC_Missed_Load>");
            }

            sb.AppendLine("</TC_Missed_Loads>");
            return sb.ToString();
        }
    }
}
