using Renci.SshNet;
using System.Text;
using Renci.SshNet.Common; // For SshAuthenticationException
using Renci.SshNet.Sftp;   // For SftpPathNotFoundException

namespace MissedLoadsApi.Helpers
{
    public static class SftpUploader
    {
        public static void Upload(string xmlContent, string fileName, IConfiguration config)
        {
            // Retrieve values from appsettings.json instead of hardcoding them
            var settings = config.GetSection("SftpSettings");
            string host = settings["Host"];
            int port = int.Parse(settings["Port"] ?? "22");
            string username = settings["Username"];
            string password = settings["Password"];
            string remotePath = settings["RemotePath"];

            // The rest of the logic remains the same, but uses the variables above
            using var sftp = new SftpClient(host, port, username, password);
            sftp.Connect();

            if (!sftp.IsConnected)
                throw new Exception("Failed to connect to SFTP.");

            using var ms = new MemoryStream(Encoding.UTF8.GetBytes(xmlContent));

            // Use the remotePath retrieved from configuration
            string fullRemotePath = $"{remotePath}/{fileName}";
            sftp.UploadFile(ms, fullRemotePath);

            sftp.Disconnect();
        }
    }
}
