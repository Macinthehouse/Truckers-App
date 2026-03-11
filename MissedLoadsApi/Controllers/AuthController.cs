using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using MissedLoadsApi.Helpers;
using MissedLoadsApi.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace MissedLoadsApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _config;

        public AuthController(IConfiguration config)
        {
            _config = config;
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            var driver = FakeDriverStore.ValidateCredentials(request.Username, request.Password);
            if (driver == null)
                return Unauthorized("Invalid username or password");

            var token = GenerateJwtToken(driver);
            return Ok(new { token });
        }

        private string GenerateJwtToken(Driver driver)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, driver.Id.ToString()),
                new Claim(ClaimTypes.Name, driver.Username),
                new Claim("Company", driver.Company.ToString())
            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(6),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public class LoginRequest
        {
            public string Username { get; set; } = null!;
            public string Password { get; set; } = null!;
        }
    }
}