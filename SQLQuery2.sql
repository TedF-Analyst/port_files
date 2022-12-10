SELECT *
FROM [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project 1]..CovidVaccinations$
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project 1]..CovidDeaths$
ORDER by 1,2


-- Shows Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths$
ORDER by 1,2

-- Shows Total Cases vs Population
SELECT location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
FROM [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
ORDER by 1,2

-- Shows countries with highest case count vs population
SELECT location, MAX(total_cases) HighestCaseNum, population, MAX((total_cases/population))*100 as CasePercentage
FROM [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
GROUP BY location, population
ORDER by CasePercentage desc

-- Shows countries with highest death count vs population
-- Uses CAST, total_deaths is varchar
SELECT location, MAX(CAST(total_deaths as int)) AS MaxDeaths, population, MAX((total_deaths/population))*100 as DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
GROUP BY location, population
ORDER by DeathPercentage desc

-- Shows countries with highest death count
-- Uses CAST, total_deaths is varchar
SELECT location, MAX(CAST(total_deaths as int)) AS MaxDeaths
FROM [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
GROUP BY location, population
ORDER by MaxDeaths desc

-- Shows highest death count of a country by continent
-- Uses CAST, total_deaths is varchar
SELECT continent, MAX(CAST(total_deaths as int)) as MaxDeaths
From [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY MaxDeaths desc

-- Global total cases and deaths by date
SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int)) /SUM (new_cases)*100 as DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths$
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

SELECT * 
FROM [Portfolio Project 1]..CovidDeaths$ dea
JOIN [Portfolio Project 1]..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date

-- Shows total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Portfolio Project 1]..CovidDeaths$ dea
JOIN [Portfolio Project 1]..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2, 3

-- Shows total population vs vaccinations w rolling vaccination total
-- Uses CONVERT instead of CAST
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_total
FROM [Portfolio Project 1]..CovidDeaths$ dea
JOIN [Portfolio Project 1]..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2, 3

-- Shows total population vs vaccinations w rolling vaccination total
-- Uses CONVERT instead of CAST
-- Uses CTE
WITH PopVsVac (continent, location, date, population, new_vaccinations, rolling_total)
AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_total
FROM [Portfolio Project 1]..CovidDeaths$ dea
JOIN [Portfolio Project 1]..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT * ,(rolling_total/population)*100 AS rolling_percent
FROM PopVsVac

-- Same as above but uses temp table instead of CTE

DROP TABLE IF exists #PercentPopVac
CREATE TABLE #PercentPopVac
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
rolling_total numeric
)

INSERT INTO #PercentPopVac
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_total
FROM [Portfolio Project 1]..CovidDeaths$ dea
JOIN [Portfolio Project 1]..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
SELECT * ,(rolling_total/population)*100 AS rolling_percent
FROM #PercentPopVac

-- Creating view to store data for later visualizations
CREATE VIEW PercentPopVac AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_total
FROM [Portfolio Project 1]..CovidDeaths$ dea
JOIN [Portfolio Project 1]..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null