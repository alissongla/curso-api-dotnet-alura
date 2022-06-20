FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["FilmesAPI/FilmesAPI.csproj", "FilmesAPI/"]
RUN dotnet restore "FilmesAPI/FilmesAPI.csproj"
COPY . .
WORKDIR "/src/FilmesAPI"
RUN dotnet build "FilmesAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FilmesAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FilmesAPI.dll"]
