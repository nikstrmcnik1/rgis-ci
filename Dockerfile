# slika, ki jo uporabimo za osnovo/strežnik (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
# aplikacija posluša na 8080
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# slika, ki jo uporabimo za izgradnjo (SDK)
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# kopiranje csproj in obnova odvisnosti
COPY ["RGIS_PrijavaVSistem/RGIS_PrijavaVSistem.csproj", "RGIS_PrijavaVSistem/"]
RUN dotnet restore "RGIS_PrijavaVSistem/RGIS_PrijavaVSistem.csproj"

# kopiranje ostale kode in izgradnja
COPY . .
WORKDIR "/src/RGIS_PrijavaVSistem"
RUN dotnet build "RGIS_PrijavaVSistem.csproj" -c Release -o /app/build

# objava (publish)
FROM build AS publish
RUN dotnet publish "RGIS_PrijavaVSistem.csproj" -c Release -o /app/publish /p:UseAppHost=false

# končna slika
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RGIS_PrijavaVSistem.dll"]
