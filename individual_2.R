# Load required libraries
#library(shiny)
library(leaflet)
library(ggplot2)
library(wordcloud)
library(dplyr)
library(tidyr)
library(plotly)
library(htmlwidgets)
library(RColorBrewer)
library(ggthemes)
library(tidyverse)
library(stringr)

death <- read.csv("../CSC-324-Han/cause_of_deaths.csv")
population1 <- read.csv("../CSC-324-Han/world_population.csv") %>%
  rename("Code"="CCA3")

population <- population1[, !sapply(population1, is.numeric)]
data1 <- merge(death, population, by = c("Code", "Country.Territory"))

data1$Country.Territory <- str_replace(data1$Country.Territory, "United States", "USA")

world_map = map_data("world") %>% 
  filter(! long > 180)

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
    causes == "maternal condition" ~ "Maternal.Disorders",
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
  mutate(T_15_29_years = M_15_29_years + F_15_29_years) %>%
  mutate(T_30_49_years = M_30_49_years + F_30_49_years) %>%
  mutate(T_50_59_years = M_50_59_years + F_50_59_years) %>%
  mutate(T_60_69_years = M_60_69_years + F_60_69_years) %>%
  mutate(T_70_years = M_70_years + F_70_years)

age_sex_info <- summary[-c(5:20)]

ui <- fluidPage(
  
  # Application title
  titlePanel("Visualization App"),
  
  # Sidebar layout
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      # Numeric input for number of data points
      sliderInput("year_range", "Select Year Range", 
                  value = c(min(data1$Year), max(data1$Year)), max = max(data1$Year), min = min(data1$Year), step = 1)
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      # Display the plots and map
      fluidRow(
        # Histogram plot
        column(6, plotlyOutput("histogram")),
      ),
      fluidRow(
        # Word cloud
        column(6, plotOutput("wordcloud")),
      ),
      
      # Pie chart
      fluidRow(
        column(12, plotlyOutput("piechart"))
      ),
      
      # Map
      fluidRow(
        column(12, plotOutput("map"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Filter data based on selected year range
  filtered_data <- reactive({
    subset(data1, Year >= input$year_range[1] & Year <= input$year_range[2])
  })
  
  # Calculate sum of causes and their logarithms
  sum_cause <- reactive({
    causes <- filtered_data() %>%
      select(-c("Code", "Country.Territory", "Year", "Capital", "Continent"))%>%
    data.frame(Cause = names(causes), Sum = colSums(causes)) %>%
      mutate(sum_per_10000000 = as.numeric(Sum)/10000000)%>%
      arrange(desc(Sum))
    print(head(causes$Sum))
  })
  
  # Render histogram plot
  output$histogram <- renderPlotly({
    plot_ly(sum_cause(), aes(x = ~sum_per_10000000, y = ~Cause)) +
      geom_bar(stat = "identity") +
      labs(x = "Cause", y = "Log of Sum")+
      coord_flip()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
