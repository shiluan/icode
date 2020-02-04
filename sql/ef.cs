using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;



namespace EtsDbQryCmd
{
    class Program
    {
        static void Main(string[] args)
        {
            var ctx = new EtsDbContext();

            var ac = ctx.Accounts.FirstOrDefault(a => a.id == 101);

            Console.Write(string.Format("the Id = {0}", ac.id));

            Console.ReadLine();


            var cnames = ctx.Database.SqlQuery<Contact2>
                ("Select top 100 t102_ContactKey as [Key], t102_FirstName as [Val] from ett_Contact_102")
                .ToLookup(s=>s.Key, s=>s.Val);


            int[] ids = { 1, 2, 3, 101, 50 };
            foreach (var id in ids) {

                Console.WriteLine(string.Format("key = {0} name = {1}", id, cnames[id].FirstOrDefault()));


            }
            Console.ReadLine();


            /*
             SELECT ai.t661_AirDataKey as AirDataKey, ad.t660_AuditHostName as HostName FROM 
(SELECT * FROM adt_AirData_661 WHERE t661_Status = 'Review Failed') ai
JOIN
(SELECT DISTINCT t660_AirDataKey, t660_AuditHostName FROM adt_AirDataDocument_660
WHERE  t660_AirDataKey IN (SELECT t661_AirDataKey FROM adt_AirData_661 WHERE t661_Status = 'Review Failed')) ad
ON ai.t661_AirDataKey = ad.t660_AirDataKey
             
             */

            var sqc = @"SELECT ai.t661_AirDataKey as AirDataKey, ad.t660_AuditHostName as HostName FROM 
(SELECT * FROM adt_AirData_661 WHERE t661_Status = {0}) ai
JOIN
(SELECT DISTINCT t660_AirDataKey, t660_AuditHostName FROM adt_AirDataDocument_660
WHERE  t660_AirDataKey IN(SELECT t661_AirDataKey FROM adt_AirData_661 WHERE t661_Status = 'Review Failed')) ad
ON ai.t661_AirDataKey = ad.t660_AirDataKey";

            var re = ctx.Database.SqlQuery<Contact3>
               (sqc, "Review Failed")
               .ToList();

            foreach (var r in re) {

                Console.WriteLine(string.Format("key = {0} host = {1}", r.AirDataKey, r.HostName));
            }

            Console.ReadLine();

        }
    }


    public class Contact
    {
        
        public int id { get; set; }

    }

    public class Contact2
    {

        public int Key { get; set; }
            public string Val { get; set; }

    }


    public class Contact3
    {
        public int AirDataKey { get; set; }
        public string HostName { get; set; }
    }

    public class EtsDbContext : DbContext
    {
        public EtsDbContext() : base("EtsDbConn")
        {
            Database.SetInitializer<EtsDbContext>(null);
        }

        public DbSet<Contact> Accounts { get; set; }


        /*
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
        */

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            //Map entity to table
            modelBuilder.Entity<Contact>().ToTable("ett_Contact_102");


            modelBuilder.Entity<Contact>().HasKey(c => c.id);
            modelBuilder.Entity<Contact>().Property(c=>c.id).HasColumnName("t102_ContactKey");

                /*
                ap(m =>
            {
                m.Properties(p => new { p.Id, p.StudentName });
                m.ToTable("StudentInfo");
            }).Map(m => {
                m.Properties(p => new { p.StudentId, p.Height, p.Weight, p.Photo, p.DateOfBirth });
                m.ToTable("StudentInfoDetail");
            });
            */
        }
    }


}

