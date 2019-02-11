FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 5000

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["SuperSite.csproj", "./"]
RUN dotnet restore "./SuperSite.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "SuperSite.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SuperSite.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SuperSite.dll"]
