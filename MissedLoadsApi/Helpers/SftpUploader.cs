using Renci.SshNet;
using System.Text;
using Renci.SshNet.Common; // For SshAuthenticationException
using Renci.SshNet.Sftp;   // For SftpPathNotFoundException

namespace MissedLoadsApi.Helpers
{
    public static class SftpUploader
    {
        public static void Upload(string xmlContent, string fileName)
        {
            const string host = "sftp.abgcanada.com";
            const int port = 22;
            const string username = "Srv_TCML";
            const string password = "Wfg%%678"; // Secure this better in production
            const string remotePath = "/home/SAP/TC_MissedLoads";

            using var sftp = new SftpClient(host, port, username, password);
            sftp.Connect();

            if (!sftp.IsConnected)
                throw new Exception("Failed to connect to SFTP.");

            using var ms = new MemoryStream(Encoding.UTF8.GetBytes(xmlContent));

            string fullRemotePath = $"{remotePath}/{fileName}";
            sftp.UploadFile(ms, fullRemotePath);

            sftp.Disconnect();
        }
    }
}