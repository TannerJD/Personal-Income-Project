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
  
  



# temp_cols = 
# print(edu_data[1,1])
# print(edu_data$`Label (Grouping)`[1])
edu_mod_data = edu_data
name_col = edu_data$`Label (Grouping)`
print(name_col)

for (i in 2:6)
{
  name_col[i] = paste(name_col[i], ' 18-24')
}

for (i in 8:16)
{
  name_col[i] = paste(name_col[i], ' 25+')
}

for (i in 18:19)
{
  name_col[i] = paste(name_col[i], ' 25-34')
}

for (i in 21:22)
{
  name_col[i] = paste(name_col[i], ' 35-44')
}

for (i in 24:25)
{
  name_col[i] = paste(name_col[i], ' 45-64')
}

for (i in 27:28)
{
  name_col[i] = paste(name_col[i], ' 65+')
}

for (i in 31:32)
{
  name_col[i] = paste(name_col[i], ' White alone')
}

for (i in 34:35)
{
  name_col[i] = paste(name_col[i], ' White alone, not Hispanic or Latino')
}

for (i in 37:38)
{
  name_col[i] = paste(name_col[i], ' Black alone')
}

for (i in 40:41)
{
  name_col[i] = paste(name_col[i], ' American Indian or Alaska Native alone')
}

for (i in 43:44)
{
  name_col[i] = paste(name_col[i], ' Asian alone')
}

for (i in 46:47)
{
  name_col[i] = paste(name_col[i], ' Native Hawaiian and Other Pacific Islander alone')
}

for (i in 49:50)
{
  name_col[i] = paste(name_col[i], ' Some other race alone')
}

for (i in 52:53)
{
  name_col[i] = paste(name_col[i], ' Two or more races')
}

for (i in 55:56)
{
  name_col[i] = paste(name_col[i], ' Hispanic or Latino Origin')
}

for (i in 58:61)
{
  name_col[i] = paste(name_col[i], ' Poverty Rate')
}

for (i in 64:68)
{
  name_col[i] = paste(name_col[i], ' Median earnings')
}

edu_mod_data$`Label (Grouping)` = name_col





name_col = mobil_data$`Label (Grouping)`
mobil_mod_data = mobil_data

for (i in 2:6)
{
  name_col[i] = paste(name_col[i], ' Population estimate')
}

for (i in 8:12)
{
  name_col[i] = paste(name_col[i], ' Same house 1 year ago:')
}

for (i in 14:18)
{
  name_col[i] = paste(name_col[i], ' Moved within same county:')
}

for (i in 20:24)
{
  name_col[i] = paste(name_col[i], ' Moved from different county within same state:')
}

for (i in 26:30)
{
  name_col[i] = paste(name_col[i], ' Moved from different state:')
}

for (i in 32:36)
{
  name_col[i] = paste(name_col[i], ' Moved from abroad:')
}

mobil_mod_data$`Label (Grouping)` = name_col
