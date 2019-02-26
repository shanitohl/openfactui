FROM microsoft/dotnet:3.0-aspnetcore-runtime-stretch-slim AS base
WORKDIR /app
EXPOSE 8082
EXPOSE 443

FROM microsoft/dotnet:3.0-sdk-stretch AS build
WORKDIR /src
# COPY *.csproj ./
COPY ["OpenfactUI/OpenfactUI.csproj", "src/"]
RUN dotnet restore "src/OpenfactUI.csproj"
# RUN dotnet restore
COPY . .
# WORKDIR "/src/OpenfactUI"
RUN dotnet build  -c Release -o /app

FROM build AS publish
RUN dotnet publish  -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /src .
ENTRYPOINT ["dotnet", "OpenfactUI.dll"]