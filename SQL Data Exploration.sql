

select * From CovidDeaths 
where continent is not null
order by 3,4

Select location, date, total_cases,new_cases,total_deaths,population 
from CovidDeaths
where continent is not null
order by 1,2;


--Looking at total cases Vs Total Deaths

Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
Where location like '%India%' and  continent is not null
order by 1,2;

-- Looking at total cases vs Population

Select location, date, population,total_cases,(total_cases/population)*100 as DeathPercentage
from CovidDeaths
Where location like '%India%' and  continent is not null
order by 1,2;


-- Looking at countries with higest infection rate compared to Population

Select location, population,max(total_cases) as Highestinfectioncount,Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
Group by location, population
Order by PercentPopulationInfected desc;

-- Showing Countries Highest Deathcount Per Population

Select Location,MAX(Cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by Location
Order by TotalDeathCount desc;

-- Let's Break things down by continent

-- Showing continent with highest Deathcount per population

Select continent,MAX(Cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc;

-- Global Numbers

Select  date, SUM(new_cases) as Total_Cases,SUM(cast(new_deaths as int)) as Total_Deaths,SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2


Select c.continent, c.location, c.date, c.population, v.new_vaccinations,
sum	(convert(int, v.new_vaccinations)) over (Partition by c.location order by c.location, c.date) as Rolling_People_Vaccinated
From CovidDeaths c
join CovidVaccinations v
on c.location = v.location
and c.date = v.date
where c.continent is not null
order by 2,3

-- Using CTE

with PopvsVac (continent,location,date,population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
Select c.continent, c.location, c.date, c.population, v.new_vaccinations,
sum	(convert(int, v.new_vaccinations)) over (Partition by c.location order by c.location, c.date) as Rolling_People_Vaccinated
From CovidDeaths c
join CovidVaccinations v
on c.location = v.location
and c.date = v.date
where c.continent is not null	
)
Select * , (Rolling_People_Vaccinated/population)*100
from PopvsVac



-- Temp Table

Create Table #percentpopulationvaccinated
(
continent varchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)


Insert into #percentpopulationvaccinated
Select c.continent, c.location, c.date, c.population, v.new_vaccinations,
sum	(convert(int, v.new_vaccinations)) over (Partition by c.location order by c.location, c.date) as Rolling_People_Vaccinated
From CovidDeaths c
join CovidVaccinations v
on c.location = v.location
and c.date = v.date
where c.continent is not null

Select * , (Rolling_People_Vaccinated/population)*100
from #percentpopulationvaccinated

-- Creating View to store Data for later visualizations

Create View percentpopulationvaccinated as
Select c.continent, c.location, c.date, c.population, v.new_vaccinations,
sum	(convert(int, v.new_vaccinations)) over (Partition by c.location order by c.location, c.date) as Rolling_People_Vaccinated
From CovidDeaths c
join CovidVaccinations v
on c.location = v.location
and c.date = v.date
where c.continent is not null

Select * 
from percentpopulationvaccinated