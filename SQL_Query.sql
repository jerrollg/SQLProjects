SELECT *
FROM PortfolioProject.dbo.COVIDDeaths
WHERE continent IS not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.COVIDVaccinations
--ORDER BY 3,4

--Select Data that we are going to be using

SELECT location,date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.COVIDDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract COVID in your country
SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.COVIDDeaths
WHERE location LIKE '%states%' and continent is not null	
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of populations got COVID
SELECT location,date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at countries with highest infection Rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with the Highest Death Count per Population
SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%'
WHERE continent IS not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Breakdown by continent
--Showing continents with highest death count per population
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%'
WHERE continent IS not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%'
WHERE continent IS null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Global numbers
SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%' 
WHERE continent is not null	
GROUP By date
ORDER BY 1,2

SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.COVIDDeaths
--WHERE location LIKE '%states%' 
WHERE continent is not null	
--GROUP By date
ORDER BY 1,2



SELECT *
FROM PortfolioProject.dbo.COVIDDeaths dea
JOIN PortfolioProject.dbo.COVIDVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

--Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.dbo.COVIDDeaths dea
JOIN PortfolioProject.dbo.COVIDVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location)
FROM PortfolioProject.dbo.COVIDDeaths dea
JOIN PortfolioProject.dbo.COVIDVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
