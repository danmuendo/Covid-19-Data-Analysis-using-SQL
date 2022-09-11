select *
from portflioProject..CovidTable1
where continent is not null
order by 3,4



--select *
--from portflioProject..CovidTable2
--order by 3,4

--Selecting the data that I will use
select location,date,total_cases,new_cases,total_deaths,population
from portflioProject..CovidTable1
order by 1,2

--look at the total cases vs the total deaths
--shows the likelihood of dying if you contract covid-19 in Africa

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from portflioProject..CovidTable1
where location like '%Africa%'
order by 1,2

--Analyzing the Total cases vs Population
--Shows population percentage that has Covid-19 in africa
select location,date,total_cases,population,(total_cases/population)*100 as casesPercentage
from portflioProject..CovidTable1
where location like '%Africa%'
order by 1,2

--Countries with highest infection rate compared to population
select location,max(total_cases) as infectedPopulation,max((total_deaths/total_cases))*100 as infectedPopulationPercentage
from portflioProject..CovidTable1
--where location like '%Africa%'
where continent is not null
group by location,population
order by infectedPopulationPercentage desc

--Showing Countries with highest death count per population
select location,max(cast(total_deaths as int)) as totalDeathCount
from portflioProject..CovidTable1
--where location like '%Africa%'
where continent is not null
group by location
order by totalDeathCount desc

--Breaking down by continent
--The continent with the highest death count
select continent,max(cast(total_deaths as int)) as totalDeathCount
from portflioProject..CovidTable1
--where location like '%Africa%'
where continent is not null
group by continent
order by totalDeathCount desc

--Analyzing Global Numbers

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from portflioProject..CovidTable1
--where location like '%Africa%'
where continent is not null
group by date
order by 1,2
 
 --total cases and total deaths across the world
 select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from portflioProject..CovidTable1
--where location like '%Africa%'
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination
select tab1.continent,tab1.location,tab1.date,tab1.population,tab2.new_vaccinations,
sum(convert(int,tab2.new_vaccinations)) over (partition by tab1.Location order by 
tab1.location,tab1.Date) as RollingPeopleVaccinated
from portflioProject..CovidTable1 tab1
join portflioProject..CovidTable2 tab2
on tab1.location=tab2.location
and tab1.date = tab2.date
where tab1.continent is not null
order by 1,2,3

--Use CTE
with popvsvac (Continent,Location,Population,Date,New_vaccinations,RollingPeopleVaccinated)
as
(
select tab1.continent,tab1.location,tab1.date,tab1.population,tab2.new_vaccinations,
sum(convert(int,tab2.new_vaccinations)) over (partition by tab1.Location order by 
tab1.location,tab1.Date) as RollingPeopleVaccinated
from portflioProject..CovidTable1 tab1
join portflioProject..CovidTable2 tab2
on tab1.location=tab2.location
and tab1.date = tab2.date
where tab1.continent is not null
--order by 2,3
)
select *,(convert(int,RollingPeopleVaccinated)/convert(int,Population))*100
from popvsvac

--Use Temp Table
create table #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select tab1.continent,tab1.location,tab1.date,tab1.population,tab2.new_vaccinations,
sum(convert(int,tab2.new_vaccinations)) over (partition by tab1.Location order by 
tab1.location,tab1.Date) as RollingPeopleVaccinated
from portflioProject..CovidTable1 tab1
join portflioProject..CovidTable2 tab2
on tab1.location=tab2.location
and tab1.date = tab2.date
where tab1.continent is not null

select *,(convert(int,RollingPeopleVaccinated)/convert(int,Population))*100
from #PercentPopulationVaccinated

--Creating View to store data for later visualization
create view PercentPopulationVaccinated as
select tab1.continent,tab1.location,tab1.date,tab1.population,tab2.new_vaccinations,
sum(convert(int,tab2.new_vaccinations)) over (partition by tab1.Location order by 
tab1.location,tab1.Date) as RollingPeopleVaccinated
from portflioProject..CovidTable1 tab1
join portflioProject..CovidTable2 tab2
on tab1.location=tab2.location
and tab1.date = tab2.date
where tab1.continent is not null