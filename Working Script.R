# install.packages("rstudioapi")
install.packages("readr")
install.packages("rlang")
update.packages(ask = FALSE)
install.packages("readr", dependencies = TRUE)

# Remove the problematic package
unlink("C:/Users/Nini/AppData/Local/R/win-library/4.2/cli", recursive = TRUE)

# Reinstall the package
install.packages("cli")

Sys.setenv(VROOM_CONNECTION_SIZE = 50000072)



require(readr)
require(magrittr)
require(dplyr)

current_file_path = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(current_file_path)

# income_data = read.csv("County Income 2021 5-Year ACS Census.csv")

income_data = read_csv("County Income 2021 5-Year ACS Census.csv")
edu_data = read_csv("County Educational Attainment 2021 5-Year ACS Census.csv")
mobil_data = read_csv("County Geographic Mobility Past Year 2021 5-Year ACS.csv")
indmix_data = read_csv("County Industry Mix 2021 5-Year ACS Census.csv")
first_degree_data = read_csv("County First Bachelor's Field 2021 5-Year ACS.csv")

income_data$`Label (Grouping)` = trimws(income_data$`Label (Grouping)`,whitespace = "[\\h\\v]")
edu_data$`Label (Grouping)` = trimws(edu_data$`Label (Grouping)`,whitespace = "[\\h\\v]")
mobil_data$`Label (Grouping)` = trimws(mobil_data$`Label (Grouping)`,whitespace = "[\\h\\v]")
indmix_data$`Label (Grouping)` = trimws(indmix_data$`Label (Grouping)`,whitespace = "[\\h\\v]")
first_degree_data$`Label (Grouping)` = trimws(first_degree_data$`Label (Grouping)`,whitespace = "[\\h\\v]")




temp_cols = (grep("Total!!Estimate", names(indmix_data), value = TRUE))
print(temp_cols)
indmix_mod_data = indmix_data[, c("Label (Grouping)", temp_cols)]
indmix_mod_data = indmix_mod_data[-c(2,9,13,16,20,23),]



temp_cols = (grep("!!Estimate", names(first_degree_data), value = TRUE))
print(temp_cols)
first_degree_mod_data = first_degree_data[, c("Label (Grouping)", temp_cols)]
first_degree_mod_data[is.na(first_degree_mod_data)] = 0



temp_cols = (grep("!!Estimate", names(income_data), value = TRUE))
income_mod_data = income_data[, c("Label (Grouping)", temp_cols)]

temp_cols_2 = (grep("!!Percent", names(income_mod_data), value = TRUE))
print(temp_cols_2)
temp_cols_3 = (grep("!!Median", names(income_mod_data), value = TRUE))
print(temp_cols_3)

income_mod_data[temp_cols_2][is.na(income_mod_data[temp_cols_2])] = "0.0%"

income_mod_data <- income_mod_data %>%
  mutate(across(all_of(temp_cols_3), ~as.numeric(gsub(",", "", .))), .keep = "unused")

income_mod_data[is.na(income_mod_data)] = 0
  
  
# income_mod_data <- income_mod_data %>% mutate(across(all_of(temp_cols_2), ~ifelse(is.na(.), "0.0%", .)))

  
  
# sum(indmix_mod_data$`Autauga County, Alabama!!Total!!Estimate`)/2
# print(sum(first_degree_data$`Autauga County, Alabama!!Estimate`, na.rm = TRUE)/2)




