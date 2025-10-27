using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Root endpoint
app.MapGet("/", () => Results.Text("RGIS_PrijavaVSistem: OK", "text/plain"));

// Simple health endpoint
app.MapGet("/health", () => Results.Ok(new { status = "healthy" }));

app.Run();
