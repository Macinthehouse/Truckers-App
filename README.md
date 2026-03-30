# Multiplatform Logistics Reporting App

A cross-platform mobile solution built with **Flutter** and **.NET 8** designed to modernize legacy logistics reporting. This project migrates a traditional Windows-based "Missed Load" reporting tool into a mobile environment for iOS and Android.

## Key Technical Highlights
- **Cross-Platform Migration:** Successfully transitioned legacy business logic into a modern Flutter frontend.
- **Secure Backend API:** Developed an ASP.NET Core 8 Web API to handle data processing and SFTP uploads.
- **Security-First Architecture:** Implemented Dependency Injection (DI) and `IConfiguration` patterns to manage sensitive server credentials securely.
- **Enterprise Integration:** Generates standardized XML reports compatible with legacy SAP and ERP systems.

## Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** .NET 8, C#
- **Integration:** Renci.SshNet (SFTP), XML Serialization
- **Tools:** Git, Visual Studio, VS Code

## Local Setup
To protect sensitive server information, the `appsettings.json` file is excluded from version control. 

1. Clone the repository.
2. Navigate to the `MissedLoadsApi` directory.
3. Copy `appsettings.Example.json` and rename it to `appsettings.json`.
4. Enter your specific SFTP server credentials in the new file.