# COVID-19 Data Analysis Project

## Overview

This project is designed to analyze COVID-19 data from the `portflioProject` database. The focus is on understanding the spread, impact, and vaccination efforts related to COVID-19 across various regions and continents. The analysis includes metrics such as infection rates, death rates, and vaccination coverage.

## Project Structure

The project is structured around SQL queries that extract and analyze data from two main tables: `CovidTable1` and `CovidTable2`.

### Tables

- **CovidTable1**: Contains data on COVID-19 cases, deaths, and population across various locations and dates.
- **CovidTable2**: Contains data on COVID-19 vaccinations across various locations and dates.

### Key Queries

1. **Selecting Non-Null Continents**
   ```sql
   select * 
   from portflioProject..CovidTable1 
   where continent is not null 
   order by 3,4
