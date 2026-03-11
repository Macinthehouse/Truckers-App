using MissedLoadsApi.Models;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace MissedLoadsApi.Helpers
{
    public static class FakeDriverStore
    {
        // In-memory "database"
        public static List<Driver> Drivers = new List<Driver>
        {
            new Driver
            {
                Id = 1,
                Username = "driver1",
                PasswordHash = HashPassword("password123"),
                Company= 3 // Conrad
            },
            new Driver
            {
                Id = 2,
                Username = "driver2",
                PasswordHash = HashPassword("letmein"),
                Company = 7 // Greenhaven
            }
        };

        public static string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(bytes);
            }
        }

        public static Driver? ValidateCredentials(string username, string password)
        {
            var hash = HashPassword(password);
            return Drivers.FirstOrDefault(d => d.Username == username && d.PasswordHash == hash);
        }
    }
}