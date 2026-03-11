namespace MissedLoadsApi.Models
{
    public class TruckerCompany
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public TruckerCompany(int id, string name)
        {
            Id = id;
            Name = name;
        }
    }
}