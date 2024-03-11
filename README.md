## How to access the Shiny app
Shiny app have been uploaded in shinyapps.io. Users could access the website through the link: https://ez35kq-han1210.shinyapps.io/CSC-324-Han/

---
title: "Project Documentation"
author: "Han Xie"
---

## Acknowledgment: 

In this project, I have used different answers from stack overflow and the package documentation for ggplot, dplyr, tidyr, plotly, stringr. Those informations helps me 
build the plots, figure out the specific questions I have encountered.

I am also acknowledge the help from Professor Priscilla Jiménez Pazmino and CSC 324 
class mentor Elijah Mendoza in their help of finding problems and mentally modeling
the shiny app. 

I am acknowledge the help from Vivero Digital Fellows program in better designing the
visualization and give advice about the graphs titles.

## Project Purpose

A straightforward way to assess the health status of a population is to focus on mortality – or concepts like child mortality or life expectancy, which are based on mortality estimates. A focus on mortality, however, does not take into account that the burden of diseases is not only that they kill people, but that they cause suffering to people who live with them. Assessing health outcomes by both mortality and morbidity (the prevalent diseases) provides a more encompassing view on health outcomes. 

## Audience and Users

The audience of the project is for general audience. The shinyapp with data visualization
provides a accessible way for different audiences to select the information they want.
The users could be scientists who would like to see how effective certain types of theropies work by looking at how the invention of certian medicine leads to the reduction of death number. The users could also be sociologist in viewing how different social conflicts cause the death of people. The users could also be general audiences who want to look at the death over years based on certain causes.

## Goal

As described in the purpose, the projects aims to help people assess the health status of population based on different causes of death. The general data visualization helps users to view the trends of the variation in death population.

## Data Description
There are 6 different datasets collected from 3 different sources. 

## Source 1: data from WHO (2000_global.csv, 2010_global.csv, 2015_global.csv, 2019_global.csv)
The data from World Health Organization (WHO) provides the cause-specific mortality with regard of gender and age information from 2000 - 2019. (data source: https://www.who.int/data/gho/data/themes/mortality-and-global-health-estimates/ghe-leading-causes-of-death). It orginally is one excel file with different sheets (each sheet represent one year). Since r is not able to load the data in a roughly accurate format. I mannually change each of them as 4 separate files and clean data based on those 4 files.

Format: Each of the data frame involves 202 observations of 20 variables. All the observations are character variables. The variables were then convert to numberics information in r if they are numbers. The columns separate the total gender information and age information that separate by gender.

1. causes: describe different causes of diseases, character
2. total: total number of death, character (convert to numeric data in the shiny app)
3. male: total male number of death, character (convert to numeric data in the shiny app)
4. female: total female number of death, character (convert to numeric data in the shiny app)
5. X0.28.days: total male number of death that in the age range of 0-28 days, character (convert to numeric data in the shiny app)
6. X1.59.months: total male number of death that in the age range of 1-59 months, character (convert to numeric data in the shiny app)
7. X5.14.years: total male number of death that in the age range of 5-14 years, character (convert to numeric data in the shiny app)
8. X15.29.years: total male number of death that in the age range of 15-29 years, character (convert to numeric data in the shiny app)
9. X30.49.years: total male number of death that in the age range of 30-49 years, character (convert to numeric data in the shiny app)
10. X50.59.years: total male number of death that in the age range of 50-59 years, character (convert to numeric data in the shiny app)
11. X60.69.years: total male number of death that in the age range of 60-69 years, character (convert to numeric data in the shiny app)
12. X70..years: total male number of death that in the age range of 70 + years, character (convert to numeric data in the shiny app)
13. X0.28.days.1: total female number of death that in the age range of 0-28 days, character (convert to numeric data in the shiny app)
14. X1.59.months.1: total female number of death that in the age range of 1-59 months, character (convert to numeric data in the shiny app)
15. X5.14.years.1: total female number of death that in the age range of 5-14 years, character (convert to numeric data in the shiny app)
16. X15.29.years.1: total female number of death that in the age range of 15-29 years, character (convert to numeric data in the shiny app)
17. X30.49.years.1: total female number of death that in the age range of 30-49 years, character (convert to numeric data in the shiny app)
18. X50.59.years.1: total female number of death that in the age range of 50-59 years, character (convert to numeric data in the shiny app)
19. X60.69.years.1: total female number of death that in the age range of 60-69 years, character (convert to numeric data in the shiny app)
20. X70..years.1: total female number of death that in the age range of 70 + years, character (convert to numeric data in the shiny app)

## Source 2: Kaggle-Cause of Deaths around the World (Historical Data)
The data from Cause of Deaths around the World (Historical Data) in Kaggle website. (data Source: https://www.kaggle.com/datasets/iamsouravbanerjee/cause-of-deaths-around-the-world) It involves the data of different causes of death from 1990 to 2019 in different countries or regions.

Format: The data frame involves 34 columns and 6120 observations. The observations involves both numerics and character variables.

1.	Country/Territory - Name of the regions, character
2.	Code - region Codes, character
3.	Year - Year of the Incident, numerics
4.	Meningitis - No. of People died from Meningitis, numerics
5.	Alzheimer's Disease and Other Dementias - No. of People died from Alzheimer's Disease and Other Dementias, numerics
6.	Parkinson's Disease - No. of People died from Parkinson's Disease, numerics
7.	Nutritional Deficiencies - No. of People died from Nutritional Deficiencies, numerics
8.	Malaria - No. of People died from Malaria, numerics
9.	Drowning - No. of People died from Drowning, numerics
10.	Interpersonal Violence - No. of People died from Interpersonal Violence, numerics
11.	Maternal Disorders - No. of People died from Maternal Disorders, numerics
12.	HIV AIDS- No. of people died from HIV or AIDS, numerics
13.	Drug Use Disorders - No. of People died from Drug Use Disorders, numerics
14.	Tuberculosis - No. of People died from Tuberculosis, numerics
15.	Cardiovascular Diseases - No. of People died from Cardiovascular Diseases, numerics
16.	Lower Respiratory Infections - No. of People died from Lower Respiratory Infections, numerics
17.	Neonatal Disorders - No. of People died from Neonatal Disorders, numerics
18.	 Alcohol Use Disorders - No. of People died from Alcohol Use Disorders, numerics
19.	Self-harm - No. of People died from Self-harm, numerics
20.	 Exposure to Forces of Nature - No. of People died from Exposure to Forces of Nature, numerics
21.	Diarrheal Diseases - No. of People died from Diarrheal Diseases, numerics
22.	Environmental Heat and Cold Exposure - No. of People died from Environmental Heat and Cold Exposure, numerics
23.	Neoplasms - No. of People died from Neoplasms, numerics
24.	Conflict and Terrorism - No. of People died from Conflict and Terrorism, numerics
25.	Diabetes Mellitus - No. of People died from Diabetes Mellitus, numerics
26.	Chronic Kidney Disease - No. of People died from Chronic Kidney Disease, numerics
27.	Poisonings - No. of People died from Poisoning, numerics
28.	Protein-Energy Malnutrition - No. of People died from Protein-Energy Malnutrition, numerics
29.	Road Injuries – No. of people died from road injuries, numerics
30.	 Chronic Respiratory Diseases - No. of People died from Chronic Respiratory Diseases, numerics
31.	Cirrhosis and Other Chronic Liver Diseases - No. of People died from Cirrhosis and Other Chronic Liver Diseases, numerics
32.	Digestive Diseases - No. of People died from Digestive Diseases, numerics
33.	Fire, Heat, and Hot Substances - No. of People died from Fire or Heat or any Hot Substances, numerics
34.	Acute Hepatitis - No. of People died from Acute Hepatitis, numerics

## Source 3: Kaggle- World Population️ Analysis
The dataframe about the world population analysis is sourced from kaggle. (data source: https://www.kaggle.com/code/hasibalmuzdadid/world-population-analysis/notebook) Data involves the population of the world based on different regions, continents.

Format: There are 234 observations of 17 variables. The observations involves both numerics and character variables.

1. Rank: Rank by population, numerics, character
2. CCA3: 3 digit Country/Territories code, character
3. Country: Name of the Country/Territories, character
4. Capital: Name of the Capital, character
5. Continent: Name of the Continent, character
6. 2022 Population: Population of the Country/Territories in the year 2022, numerics
7. 2020 Population: Population of the Country/Territories in the year 2020, numerics
8. 2015 Population: Population of the Country/Territories in the year 2015, numerics
9. 2010 Population: Population of the Country/Territories in the year 2010, numerics
10. 2000 Population: Population of the Country/Territories in the year 2000, numerics
11. 1990 Population: Population of the Country/Territories in the year 1990, numerics
12. 1980 Population: Population of the Country/Territories in the year 1980, numerics
13. 1970 Population: Population of the Country/Territories in the year 1970, numerics
14. Area (km²): Area size of the Country/Territories in square kilometer, numerics
15. Density (per km²): Population density per square kilometer, numerics
16. Growth Rate: Population growth rate by Country/Territories, numerics
17. World Population Percentage: The population percentage by each Country/Territories, numerics
