namespace MissedLoadsApi.Models;

public class DailyReport
{
    public required int Company { get; set; }
    public DateTime Date { get; set; } = DateTime.Today;
    public required int LoadsAnticipated { get; set; }
    public required List<MissedLoadItem> MissedLoads { get; set; }
    public string? Notes { get; set; }
}

public class MissedLoadReport
{
    public required int Company { get; set; }
    public DateTime Date { get; set; } = DateTime.Today;
    public required List<MissedLoadItem> MissedLoads { get; set; }
}


public class MissedLoadItem
{
    public required int ReasonType { get; set; }
    public required string Reason { get; set; }
    public required int Missed { get; set; }
    public string? Notes { get; set; }
}