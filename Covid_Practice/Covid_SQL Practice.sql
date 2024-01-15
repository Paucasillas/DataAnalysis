--Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortafolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortafolioProject..CovidDeaths
Where location like '%Mexico%'
order by 1,2

--Shows Lwhat percentage of population got covid
Select Location, date, population,total_cases, (total_cases/population)*100 as PopulationPercentageInfected
From PortafolioProject..CovidDeaths
Where location like '%Mexico%'
order by 1,2

--Looking at countries with highest infection rate compared to population

Select Location, population,MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PopulationPercentageInfected
From PortafolioProject..CovidDeaths
--Where location like '%Mexico%'
Group by Location, Population
order by PopulationPercentageInfected desc


--Showing Countries with Highest Cout Per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortafolioProject..CovidDeaths
--Where location like '%Mexico%'
Where continent is not null
Group by Location
order by TotalDeathCount desc


Select *
From PortafolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Data by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortafolioProject..CovidDeaths
Where continent is null
Group by location
order by TotalDeathCount desc

-- Continents with the highest death count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortafolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

Select sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum (new_cases)*100 as DeathPercentage
From PortafolioProject..CovidDeaths
Where continent is not null
order by 1,2


--Covid Vacc

Select *
From PortafolioProject..CovidVaccinations


--Combining the two tables
Select *
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date

--Looking at total population vs vaccinations
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Use CTE (TEMP TABLE)
with PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating view to store data for later visualization

Create View PercentPopulationVaccinated3 as
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null


Select *
From PercentPopulationVaccinated3 


--Querues used for Tableu
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortafolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortafolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortafolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortafolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

