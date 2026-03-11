namespace MissedLoadsApi.Models
{
    public class Driver
    {
        public int Id { get; set; }
        public string Username { get; set; } = null!;
        public string PasswordHash { get; set; } = null!;
        public int Company { get; set; }    // This will be pre-filled in reports
    }
}