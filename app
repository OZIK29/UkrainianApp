// FolkloreEntry.cs
public class FolkloreEntry
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
}

// FolkloreDbContext.cs
using Microsoft.EntityFrameworkCore;

public class FolkloreDbContext : DbContext
{
    public FolkloreDbContext(DbContextOptions<FolkloreDbContext> options) : base(options)
    {
    }

    public DbSet<FolkloreEntry> FolkloreEntries { get; set; }
}

// FolkloreController.cs
using Microsoft.AspNetCore.Mvc;
using System.Linq;

[Route("api/[controller]")]
[ApiController]
public class FolkloreController : ControllerBase
{
    private readonly FolkloreDbContext _context;

    public FolkloreController(FolkloreDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public ActionResult<IEnumerable<FolkloreEntry>> GetFolkloreEntries()
    {
        return _context.FolkloreEntries.ToList();
    }

    [HttpPost]
    public ActionResult<string> AddFolkloreEntry(FolkloreEntry entry)
    {
        _context.FolkloreEntries.Add(entry);
        _context.SaveChanges();
        return "Folklore entry added successfully.";
    }
}

// Startup.cs
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace UkrainianFolkloreDatabaseApp
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<FolkloreDbContext>(options =>
                options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection"))
            );

            services.AddControllers();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
