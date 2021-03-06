FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

ENV config=Release

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs

COPY ["6.csproj", "/src"]
RUN dotnet restore "6.csproj" 
COPY . .

RUN dotnet build "6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "6.csproj" -c Release -o /app/publish


FROM base AS final
ENV ASPNETCORE_URLS http://*:5000


WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 5000
ENTRYPOINT ["dotnet", "6.dll"]
