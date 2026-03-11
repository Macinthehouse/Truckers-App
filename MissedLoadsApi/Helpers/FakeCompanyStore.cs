using MissedLoadsApi.Models;

namespace MissedLoadsApi.Helpers
{
    public static class FakeCompanyStore
    {
        public static List<TruckerCompany> Companies = new List<TruckerCompany>
        {
            new(1, "Asante"),
            new(2, "Buchanan"),
            new(3, "Conrad"),
            new(4, "Daryl Harper"),
            new(5, "Graham Lime"),
            new(6, "Granvel Sullivan"),
            new(7, "Greenhaven"),
            new(8, "Jeff McCorquindale"),
            new(9, "Melais"),
            new(10, "Millport"),
            new(11, "OC Maillet"),
            new(12, "Reagon"),
            new(13, "Shane Donnelly"),
            new(14, "WeHaul")
        };
    }
}