# FROM mcr.microsoft.com/dotnet/aspnet:3.1-focal AS base
FROM mcr.microsoft.com/dotnet/aspnet:3.1-focal-arm64v8 AS base 
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser

FROM mcr.microsoft.com/dotnet/sdk:3.1-focal-arm64v8 AS build
WORKDIR /src
COPY ["dnetmvc31.csproj", "./"]
# RUN dotnet restore "dnetmvc31.csproj"
RUN dotnet restore -r linux-arm64 "dnetmvc31.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dnetmvc31.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dnetmvc31.csproj" -c Release -o /app/publish -r linux-arm64

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "dnetmvc31.dll"]
ENTRYPOINT ["./dnetmvc31"]
