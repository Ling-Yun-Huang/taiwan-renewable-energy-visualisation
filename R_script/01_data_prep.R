library(tidyverse)
library(lubridate)

# read energy data from 2005-2023
rawdata1 <- read_csv("Documents/GitHub/taiwan-renewable-energy-visualisation/data/PowerGenerationM.csv")

energy05_23 <- rawdata1 %>%
  select(date, year, month, 
         NPGOverall, NPGRenewableTotal,
         NPGRenewableConventionalHydropower, NPGRenewableGeothermal,
         NPGRenewableSolar, NPGRenewableWind,
         NPGRenewableBiomass, NPGRenewableWaste) %>%
  #rename the features
  rename(
    Overall = NPGOverall,
    RenewableTotal = NPGRenewableTotal,
    Hydropower = NPGRenewableConventionalHydropower,
    Geothermal = NPGRenewableGeothermal,
    Solar = NPGRenewableSolar,
    Wind = NPGRenewableWind,
    Biomass = NPGRenewableBiomass,
    Waste = NPGRenewableWaste
  )

head(energy05_23)

# pivot into long data for plotting and modelling
energy05_23_long <- energy05_23 %>%
  pivot_longer(
    cols = c(Hydropower, Geothermal, Solar, Wind, Biomass, Waste),
    names_to = "item",  #renewable energy type
    values_to = "value"
  )

head(energy05_23_long)

# read 2024 energy data
rawdata2 <- read_csv("Documents/GitHub/taiwan-renewable-energy-visualisation/data/PowerGeneration2024.csv")
head(rawdata2)

energy24 <- rawdata2 %>%
  select(date, year, month, 
         NPGOverall, NPGRenewableTotal,
         NPGRenewableConventionalHydropower, NPGRenewableGeothermal,
         NPGRenewableSolar, NPGRenewableWind,
         NPGRenewableBiomass, NPGRenewableWaste) %>%
  #rename the features
  rename(
    Overall = NPGOverall,
    RenewableTotal = NPGRenewableTotal,
    Hydropower = NPGRenewableConventionalHydropower,
    Geothermal = NPGRenewableGeothermal,
    Solar = NPGRenewableSolar,
    Wind = NPGRenewableWind,
    Biomass = NPGRenewableBiomass,
    Waste = NPGRenewableWaste
  )

head(energy24)

# pivot into long data for plotting and modelling
energy24_long <- energy24 %>%
  pivot_longer(
    cols = c(Hydropower, Geothermal, Solar, Wind, Biomass, Waste),
    names_to = "item",  #renewable energy type
    values_to = "value"
  )

head(energy24_long)

# Save RDS
saveRDS(energy05_23, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23.rds")
saveRDS(energy05_23_long, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
saveRDS(energy24, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy24.rds")
saveRDS(energy24_long, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy24_long.rds")
