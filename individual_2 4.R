#map
#country
# change name for each variables in pie chart 
#(70+ years; 60-69 years; convert month to years)
#change line for prompt
#font size bigger or select causes () (if so, change titles)
#switch color
#label for scale of the death number in map
# death rate over time for scatterplot

# Load required libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(htmlwidgets)
library(RColorBrewer)
library(ggthemes)
library(tidyverse)
library(stringr)
library("car")
library(MatrixModels)
library(lme4)
library(minqa)
library(quantreg)

death <- read.csv("cause_of_deaths.csv")
population1 <- read.csv("world_population.csv") %>%
  rename("Code"="CCA3")

population <- population1[, !sapply(population1, is.numeric)]

data1 <- merge(death, population, by = c("Code", "Country.Territory")) 

data1$Country.Territory <- str_replace(data1$Country.Territory, "United States", "USA")

world_map = map_data("world") %>% 
  filter(! long > 180)

world_map$region <- str_replace(world_map$region, "Taiwan", "China")

data2000 <- read.csv("2000_global.csv")
data2010 <- read.csv("2010_global.csv")
data2015 <- read.csv("2015_global.csv")
data2019 <- read.csv("2019_global.csv")

summary <- bind_rows(data2000, data2010, data2015, data2019)
summary <-  summary %>%
  mutate(totalNum = as.numeric(gsub(",","", summary$total))) %>%
  mutate(maleNum = as.numeric(gsub(",","", summary$male))) %>%
  mutate(femaleNum = as.numeric(gsub(",","", summary$female))) %>%
  mutate(M_0_28_days = as.numeric(gsub(",","", summary$X0.28.days))) %>%
  mutate(F_0_28_days = as.numeric(gsub(",","", summary$X0.28.days.1))) %>%
  mutate(M_1_59_mons = as.numeric(gsub(",","", summary$X1.59.months))) %>%
  mutate(F_1_59_mons = as.numeric(gsub(",","", summary$X1.59.months.1))) %>%
  mutate(M_5_14_years = as.numeric(gsub(",","", summary$X5.14.years))) %>%
  mutate(F_5_14_years = as.numeric(gsub(",","", summary$X5.14.years.1))) %>%
  mutate(M_15_29_years = as.numeric(gsub(",","", summary$X15.29.years))) %>%
  mutate(F_15_29_years = as.numeric(gsub(",","", summary$X15.29.years.1))) %>%
  mutate(M_30_49_years = as.numeric(gsub(",","", summary$X30.49.years))) %>%
  mutate(F_30_49_years = as.numeric(gsub(",","", summary$X30.49.years.1))) %>%
  mutate(M_50_59_years = as.numeric(gsub(",","", summary$X50.59.years))) %>%
  mutate(F_50_59_years = as.numeric(gsub(",","", summary$X50.59.years.1))) %>%
  mutate(M_60_69_years = as.numeric(gsub(",","", summary$X60.69.years))) %>%
  mutate(F_60_69_years = as.numeric(gsub(",","", summary$X60.69.years.1))) %>%
  mutate(M_70_years = as.numeric(gsub(",","", summary$X70..years))) %>%
  mutate(F_70_years = as.numeric(gsub(",","", summary$X70..years.1)))

summary <- summary[-c(2:20)]

summary <- summary %>%
  mutate(causes = case_when(
    causes == "Protein-energy malnutrition" ~ "Protein.Energy.Malnutrition",
    causes == "Iodine deficiency" ~ "Nutritional.Deficiencies",
    causes == "Vitamin A deficiency" ~ "Nutritional.Deficiencies",
    causes == "Iron-deficiency anaemia" ~ "Nutritional.Deficiencies",
    causes == "Other nutritional deficiencies" ~ "Nutritional.Deficiencies",
    causes == "Alzheimer disease and other dementias" ~ "Alzheimer.s.Disease.and.Other.Dementias",
    causes == "Parkinson disease" ~ "Parkinson.s.Disease",
    causes == "Interpersonal violence" ~ "Interpersonal.Violence",
    causes == "Maternal conditions" ~ "Maternal.Disorders",
    causes == "HIV/AIDS" ~ "HIV.AIDS",
    causes == "Drug use disorders" ~ "Drug.Use.Disorders",
    causes == "Rheumatic heart disease" ~ "Cardiovascular.Diseases",
    causes == "Hypertensive heart disease" ~ "Cardiovascular.Diseases",
    causes == "Ischaemic heart disease" ~ "Cardiovascular.Diseases",
    causes == "Stroke" ~ "Cardiovascular.Diseases",
    causes == "Cardiomyopathy, myocarditis, endocarditis" ~ "Cardiovascular.Diseases",
    causes == "Other circulatory diseases" ~ "Cardiovascular.Diseases",
    causes == "Drug use disorders" ~ "Drug.Use.Disorders",
    causes == "Lower respiratory infections" ~ "Lower.Respiratory.Infections",
    causes == "Preterm birth complications" ~ "Neonatal.Disorders",
    causes == "Birth asphyxia and birth trauma" ~ "Neonatal.Disorders",
    causes == "Neonatal sepsis and infections" ~ "Neonatal.Disorders",
    causes == "Other neonatal conditions" ~ "Neonatal.Disorders",
    causes == "Alcohol use disorders" ~ "Alcohol.Use.Disorders",
    causes == "Self-harm" ~ "Self.harm",
    causes == "Natural disasters" ~ "Exposure.to.Forces.of.Nature",
    causes == "Diarrhoeal diseases" ~ "Diarrheal.Diseases",
    causes == "Malignant neoplasms" ~ "Neoplasms",
    causes == "Other neoplasms" ~ "Neoplasms",
    causes == "Interpersonal violence" ~ "Conflict.and.Terrorism",
    causes == "Collective violence and legal intervention" ~ "Conflict.and.Terrorism",
    causes == "Diabetes mellitus" ~ "Diabetes.Mellitus",
    causes == "Alcohol use disorders" ~ "Chronic.Kidney.Disease",
    causes == "Chronic kidney disease due to diabetes" ~ "Chronic.Kidney.Disease",
    causes == "Road injury" ~ "Road.Injuries",
    causes == "Respiratory diseases" ~ "Chronic.Respiratory.Diseases",
    causes == "Cirrhosis of the liver" ~ "Cirrhosis.and.Other.Chronic.Liver.Diseases",
    causes == "Other neoplasms" ~ "Neoplasms",
    causes == "Digestive diseases" ~ "Digestive.Diseases",
    causes == "Fire, heat and hot substances" ~ "Fire..Heat..and.Hot.Substances",
    causes == "Hepatitis" ~ "Acute.Hepatitis",
    TRUE ~ causes)) %>%
  group_by(causes)%>%
  summarize_all(.funs = sum) %>%
  mutate(T_0_28_days = M_0_28_days + F_0_28_days) %>%
  mutate(T_1_59_mons = M_1_59_mons+ F_1_59_mons) %>%
  mutate(T_5_14_years = M_5_14_years + F_5_14_years) %>%
  mutate(T_15_29_years = M_15_29_years + F_15_29_years) %>%
  mutate(T_30_49_years = M_30_49_years + F_30_49_years) %>%
  mutate(T_50_59_years = M_50_59_years + F_50_59_years) %>%
  mutate(T_60_69_years = M_60_69_years + F_60_69_years) %>%
  mutate(T_70_years = M_70_years + F_70_years)

age_sex_info <- summary[-c(5:20)]

ui <- fluidPage(
  
  # Application title
  titlePanel("Causes of Death Around the World (1990-2019)"),
  
  fluidRow(
    sidebarPanel(sliderInput("year_range", "Select Year Range", 
                             value = c(min(data1$Year), 
                                       max(data1$Year)), 
                             max = max(data1$Year),
                             min = min(data1$Year),
                             step = 1, width = 1000),
                 width = 6,
    ),
    sidebarPanel(
      p("In the bar chart, click on the bar for each cause to focus on the specific data for that cause of death."),
      p("You can hover over the bar chart to find the zoom in, zoom out, and autoscale icons in the top right for better filtering the data."),
      p("Selected cause is:"),
      verbatimTextOutput("click"),
      p("Total Death Number Over the World is:"),
      verbatimTextOutput("population"),
      width = 6
    )
  ),
  # Sidebar layout
  fluidRow(
    # Histogram plot
    plotlyOutput("barChart", height = 800)
  ),
  fluidRow(
    p(),
    p()
  ),
  fluidRow(
    column(6, plotlyOutput("piechart_gender", height = 500)),
    column(6,plotlyOutput("piechart_age", height = 500))
  ),
  fluidRow(
    sidebarPanel(
      p("In the map below, hover over a country to get the total number of deaths."),
      p("If you select the causes of death of a bar chart above, then hover over that country would give the total number of death for that cause."),
      p("On the right, you will see the change in death rate over time."),
      width = 12
    )
  ),
  fluidRow(
    column(8,plotlyOutput("map", height = 500) ),
    column(4,plotOutput("scatterplot", height = 500) ),
  )
)



# Define server logic
server <- function(input, output) {
  
  filtered_data <- reactive({
    subset(data1, Year >= input$year_range[1] & Year <= input$year_range[2])
  })
  
  continent_death <- reactive({
    filtered_data() %>%
      select(-c("Code","Country.Territory", "Year", "Capital"))%>%
      group_by(Continent)%>%
      summarise_all(.funs=sum)%>%
      pivot_longer(!Continent, names_to = "causes", values_to="death_number")%>%
      mutate(death_number_per_100_000_0 = death_number/1000000)
  })
  
  
  # Render histogram plot
  output$barChart <- renderPlotly({
    p <- ggplot(continent_death(), aes(x = reorder(causes, death_number_per_100_000_0), 
                                       y = death_number_per_100_000_0,
                                       fill = factor(Continent))) +
      geom_bar(stat = "identity") +
      labs(x = "Causes", y = "Population per 1,000,000", title = "Causes of Death by Continent") +
      coord_flip()
    ggplotly(p)%>%
      event_register("plotly_click")
  })
  
  sumorder <- reactive({
    sumorder <- continent_death() %>%
      select(-c("Continent"))%>%
      group_by(causes)%>%
      summarise_all(.funs=sum)
    sumorder<-sumorder[order(sumorder$death_number), ]
  })
  
  output$click <- renderPrint({
    if(is.null(event_data("plotly_click"))){
      print(paste0("Unselected Yet"))
    }else{
      cause <- sumorder()$causes[event_data("plotly_click")$y]
      print(paste0(cause))
    }
  })
  
  output$piechart_gender <- renderPlotly({
    height = 500
    if(is.null(event_data("plotly_click"))){
      findCause <- age_sex_info%>%
        select(c(maleNum, femaleNum, causes))%>%
        rename("male" = maleNum)%>%
        rename("female" = femaleNum)%>%
        pivot_longer(!causes, names_to = "right_num", values_to = "num")
      
      plot_ly(findCause, labels = findCause$right_num, values = findCause$num) %>%
        add_pie() %>%
        layout(title = "Death Rate by Gender", 
               showlegend = T,
               xaxis = list(showgrid = TRUE, zeroline = TRUE, showticklabels = FALSE),
               yaxis = list(showgrid = TRUE, zeroline = TRUE, showticklabels = FALSE)
        )
    }else{
      cause <- sumorder()$causes[event_data("plotly_click")$y]
      findCause <- age_sex_info%>%
        select(c(maleNum, femaleNum, causes))%>%
        filter(causes == cause)%>%
        pivot_longer(!causes, names_to = "right_num", values_to = "num")
      
      plot_ly(findCause, labels = findCause$right_num, values = findCause$num) %>%
        add_pie() %>%
        layout(title = "Death Rate by Gender", 
               showlegend = T,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
        )
    }
  })
  
  output$piechart_age <- renderPlotly({
    height = 500
    
    if(is.null(event_data("plotly_click"))){
      findCause <- age_sex_info%>%
        select(-c(maleNum, femaleNum, totalNum))%>%
        pivot_longer(!causes, names_to = "right_num", values_to = "num")
      
      plot_ly(findCause, labels = findCause$right_num, values = findCause$num) %>%
        add_pie() %>%
        layout(title = "Death Rate by Age", 
               showlegend = T,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
        )
    }else{
      cause <- sumorder()$causes[event_data("plotly_click")$y]
      findCause <- age_sex_info%>%
        select(-c(maleNum, femaleNum, totalNum))%>%
        filter(causes == cause)%>%
        pivot_longer(!causes, names_to = "right_num", values_to = "num")
      
      plot_ly(findCause, labels = findCause$right_num, values = findCause$num) %>%
        add_pie() %>%
        layout(title = "Death Rate by Age", 
               showlegend = T,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
        )
    }
  })
  
  country_cause <- reactive({
    filtered_data() %>%
      select(-c("Country.Territory", "Year", "Capital", "Continent"))%>%
      group_by(Code) %>%
      summarize_all(.funs = sum)%>%
      pivot_longer(!Code, names_to = "causes", values_to = "death_number")
  })
  
  # Calculate sum of causes and their logarithms
  
  output$map <- renderPlotly({
    if(is.null(event_data("plotly_click"))){
      country_cause <- country_cause()%>%
        select(-"causes")%>%
        group_by(Code)%>%
        summarise_all(.funs = sum)
        
      plot_ly(country_cause(), type = 'choropleth', 
              locations = country_cause()$Code, 
              z = country_cause()$death_number, 
              colorscale = "#e5ecf6")%>%
        layout(title = "Death per Country", 
               showlegend = T)
    }else{
      
      mapCause <- toString(sumorder()$causes[event_data("plotly_click")$y])
      country_cause <- country_cause()%>%
        filter(causes == mapCause)
    }
    
    plot_ly(country_cause, type = 'choropleth',
            locations = country_cause$Code, 
            z = country_cause$death_number,
            colorscale = "#e5ecf6")%>%
      layout(title = "Death per Country", 
             showlegend = T)
  })
  
  countryName <- reactive({
    filtered_data()%>%
      select(Code)%>%
      group_by(Code)%>%
      summarize_all(.funs = sum)
  })
  
  output$scatterplot <- renderPlot({
    if(is.null(event_data("plotly_click")) && (length(as.vector(event_data("plotly_hover"))) != 3)){
      overYear <- filtered_data()%>%
        select(-c("Continent","Country.Territory", "Code", "Capital"))%>%
        pivot_longer(!Year, names_to = "causes", values_to = "death_number")%>%
        group_by(Year)%>%
        select(-"causes")%>%
        summarise_all(.funs = sum)
      
      scatterplot(death_number~Year, data = overYear,
                  xlab="Year", ylab="Number of Population",
                  main="death rate over time")
      
    }else if(is.null(event_data("plotly_click"))&& (length(as.vector(event_data("plotly_hover"))) == 3)){
      country_code <- as.numeric(event_data("plotly_hover")[2])+1
      The_code <- countryName()$Code[country_code]
      
      overYear <- filtered_data()%>%
        filter(Code == The_code)%>%
        select(-c("Continent","Country.Territory", "Code", "Capital"))%>%
        pivot_longer(!Year, names_to = "causes", values_to = "death_number")%>%
        group_by(Year)%>%
        select(-"causes")%>%
        summarise_all(.funs = sum)
      
      scatterplot(death_number~Year, data = overYear,
                  xlab="Year", ylab="Number of Population",
                  main="death rate over time")
      
    }else if(is.null(event_data("plotly_hover"))){
      mapCause <- toString(sumorder()$causes[event_data("plotly_click")$y])
      overYear <- filtered_data()%>%
        select(c("Year", mapCause))%>%
        group_by(Year)%>%
        summarise_all(.funs = sum)%>%
        rename("death_number" = mapCause)
      scatterplot(death_number~Year, data = overYear,
                  xlab="Year", ylab="Number of Population",
                  main="death rate over time")
      
    }else if(length(as.vector(event_data("plotly_hover"))) != 3){
      mapCause <- toString(sumorder()$causes[event_data("plotly_click")$y])
      overYear <- filtered_data()%>%
        select(c("Year", mapCause))%>%
        group_by(Year)%>%
        summarise_all(.funs = sum)%>%
        rename("death_number" = mapCause)
      scatterplot(death_number~Year, data = overYear,
                  xlab="Year", ylab="Number of Population",
                  main="death rate over time")
      
    }else{
      
      mapCause <- toString(sumorder()$causes[event_data("plotly_click")$y])
      
      country_code <- as.numeric(event_data("plotly_hover")[2])+1
      The_code <- countryName()$Code[country_code]

      filteredCause <- country_cause()%>%
        filter(Code == The_code)%>%
        filter(causes == mapCause)%>%
        select(-c("death_number"))

      overYear <- filtered_data()%>%
        filter(Code == The_code)%>%
        select(c("Year", mapCause, "Code"))%>%
        left_join(filteredCause, by = "Code")%>%
        rename("death_number" = mapCause)%>%
        select(c("Year","death_number"))

      scatterplot(death_number~Year, data = overYear,
                  xlab="Year", ylab="Number of Population",
                  main="death rate over time")
    }
  })
  
  output$population <- renderPrint({
    if(is.null(event_data("plotly_click"))){
      print(paste0("Unselected Yet"))
    }else{
      cause <- sumorder()$causes[event_data("plotly_click")$y]
      Population <- country_cause()%>%
        filter(causes == cause)%>%
        select(c("death_number", "causes"))%>%
        group_by(causes)%>%
        summarise_all(.funs = sum)
      
      print(paste0(Population[2]))
    }
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
