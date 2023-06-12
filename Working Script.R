# install.packages("rstudioapi")
install.packages("readr")
install.packages("rlang")
update.packages(ask = FALSE)
install.packages("readr", dependencies = TRUE)
install.packages("compositions")

# Remove the problematic package
unlink("C:/Users/Nini/AppData/Local/R/win-library/4.2/cli", recursive = TRUE)

# Reinstall the package
install.packages("cli")

Sys.setenv(VROOM_CONNECTION_SIZE = 50000072)



require(readr)
require(magrittr)
require(dplyr)
require(compositions)
# require(Compositional)
# detach(package:Compositional, unload = TRUE)

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





print(colnames(indmix_mod_data))
counties = colnames(indmix_mod_data)
counties = counties[-1]
print(counties)

counties = substring(counties, 1, regexpr(",",counties) - 1)
print(counties)



# IMPORTANT:
# The below code is the initial declaration of total_frame

total_frame = data.frame(county = counties)
print(total_frame)


# 
# 
# The below code adds the total household number
#     from the income data set as a column to the 
#     total_frame data frame
# 
#--------------------------------------------------------

temp_cols = (grep("Number!!Estimate", names(income_mod_data), value = TRUE))
temp_frame = income_mod_data[,c("Label (Grouping)", temp_cols)]

# The code directly below removes every character from column names after a comma and removes the comma as well
# But it excludes the first column name
colnames(temp_frame) = substring(names(temp_frame), 1, ifelse(seq_along(names(temp_frame)) > 1, regexpr(",", names(temp_frame)) - 1, nchar(names(temp_frame))))


temp_add = unname(as.vector(t(temp_frame[2, ])))
num_households = as.numeric(temp_add[-1])
total_frame$num_households = num_households

#--------------------------------------------------------




temp_add = unname(as.vector(t(temp_frame[4, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_white_only_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[5, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_black_only_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[6, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_american_indian_or_alaskan_native_only_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[7, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_asian_only_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[8, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_native_hawaiian_or_other_pacific_islander_only_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[9, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_some_other_race_only_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[10, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_two_or_more_races_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[11, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_hispanic_or_latino_origin_of_any_race_household_head = temp_add


temp_add = unname(as.vector(t(temp_frame[12, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$num_white_alone_not_hispanic_or_latino_household_head = temp_add





total_frame$frac_white_only_household_head = 
  total_frame$num_white_only_household_head / total_frame$num_households
total_frame$num_white_only_household_head = NULL

total_frame$frac_black_only_household_head = 
  total_frame$num_black_only_household_head / total_frame$num_households
total_frame$num_black_only_household_head = NULL

total_frame$frac_american_indian_or_alaskan_native_only_household_head = 
  total_frame$num_american_indian_or_alaskan_native_only_household_head / total_frame$num_households
total_frame$num_american_indian_or_alaskan_native_only_household_head = NULL

total_frame$frac_asian_only_household_head = 
  total_frame$num_asian_only_household_head / total_frame$num_households
total_frame$num_asian_only_household_head = NULL

total_frame$frac_native_hawaiian_or_other_pacific_islander_only_household_head = 
  total_frame$num_native_hawaiian_or_other_pacific_islander_only_household_head / total_frame$num_households
total_frame$num_native_hawaiian_or_other_pacific_islander_only_household_head = NULL

total_frame$frac_some_other_race_only_household_head = 
  total_frame$num_some_other_race_only_household_head / total_frame$num_households
total_frame$num_some_other_race_only_household_head = NULL

total_frame$frac_two_or_more_races_household_head = 
  total_frame$num_two_or_more_races_household_head / total_frame$num_households
total_frame$num_two_or_more_races_household_head = NULL

total_frame$frac_hispanic_or_latino_origin_of_any_race_household_head = 
  total_frame$num_hispanic_or_latino_origin_of_any_race_household_head / total_frame$num_households
total_frame$num_hispanic_or_latino_origin_of_any_race_household_head = NULL

total_frame$frac_white_alone_not_hispanic_or_latino_household_head = 
  total_frame$num_white_alone_not_hispanic_or_latino_household_head / total_frame$num_households
total_frame$num_white_alone_not_hispanic_or_latino_household_head = NULL






temp_add = unname(as.vector(t(temp_frame[14, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$frac_15_to_24_age_household_head = temp_add/total_frame$num_households

temp_add = unname(as.vector(t(temp_frame[15, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$frac_25_to_44_age_household_head = temp_add/total_frame$num_households

temp_add = unname(as.vector(t(temp_frame[16, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$frac_45_to_64_age_household_head = temp_add/total_frame$num_households

temp_add = unname(as.vector(t(temp_frame[17, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$frac_65_and_older_age_household_head = temp_add/total_frame$num_households




# All the code in this block is to add median household income to
#     total_frame
#
#---------------------------------------------------------------------
temp_cols = (grep("Median income (dollars)!!Estimate", names(income_mod_data), value = TRUE, fixed = TRUE))
print(temp_cols)
temp_frame = income_mod_data[,c("Label (Grouping)", temp_cols)]

colnames(temp_frame) = substring(names(temp_frame), 1, ifelse(seq_along(names(temp_frame)) > 1, regexpr(",", names(temp_frame)) - 1, nchar(names(temp_frame))))

temp_add = unname(as.vector(t(temp_frame[2, ])))
temp_add = as.numeric(temp_add[-1])
total_frame$median_household_income = temp_add
#--------------------------------------------------------------------------------








# All the code in this block is to add the indmix mod data to 
#     the total_frame dataframe
#
#-------------------------------------------------------------------------------
temp_cols = (grep("Total!!Estimate", names(indmix_mod_data), value = TRUE))
temp_frame = indmix_mod_data[,c("Label (Grouping)", temp_cols)]


temp_add = unname(as.vector(t(temp_frame[1, ])))
temp_add = as.numeric(temp_add[-1])
print(temp_add)
total_frame$num_full_time_16_plus_employed = temp_add


for (i in 2:21)
{
  new_col_name = temp_frame$`Label (Grouping)`[i]
  new_col_name = gsub(",", "", new_col_name)
  new_col_name = gsub(" ", "_", new_col_name)
  new_col_name = paste("frac_", new_col_name)
  new_col_name = gsub(" ", "", new_col_name)
  
  # print(new_col_name)
  
  temp_add = unname(as.vector(t(temp_frame[i, ])))
  temp_add = as.numeric(temp_add[-1])
  total_frame$temp_col = temp_add
  total_frame$temp_col = total_frame$temp_col / total_frame$num_full_time_16_plus_employed
  colnames(total_frame)[ncol(total_frame)] = new_col_name
}
#-------------------------------------------------------------------------------

# The below code removes the columns added by the for loop (ONLY IF THEY'RE
#     AT THE END)
#
# total_frame = total_frame[, -c((ncol(total_frame) - 20 + 1):ncol(total_frame))]

#-------------------------------------------------------------------------------







# The below code adds mobil_mod_data to total_frame
#
#-------------------------------------------------------------------------------
temp_cols = (grep("!!Estimate", names(mobil_mod_data), value = TRUE))
temp_frame = mobil_mod_data[,c("Label (Grouping)", temp_cols)]




for (i in 2:ncol(temp_frame))
{
  temp_vec = temp_frame[[i]]
  temp_denom = temp_vec[1]
  temp_vec = sapply(temp_vec, function(x) x/temp_denom)
  temp_frame[,i] = temp_vec
}

print(temp_frame[[1,1]])





for (i in 2:length(temp_frame$`Label (Grouping)`))
{
  if ( grepl("  ", temp_frame[[i,1]]))
  {
    split_string = strsplit(temp_frame[[i,1]], "  ")
    split_string = split_string[[1]]
    new_str = paste(split_string[2], split_string[1])
  }
}



total_frame = total_frame[,1:37]


for (i in 7:length(temp_frame$`Label (Grouping)`))
{
  new_col_name = temp_frame$`Label (Grouping)`[i]
  new_col_name = gsub(",", "", new_col_name)
  new_col_name = gsub(" ", "_", new_col_name)
  new_col_name = gsub("  ", "_", new_col_name)
  new_col_name = paste("frac_", new_col_name)
  new_col_name = gsub(" ", "", new_col_name)
  
  # print(new_col_name)
  
  temp_add = unname(as.vector(t(temp_frame[i, ])))
  temp_add = as.numeric(temp_add[-1])
  total_frame$temp_col = temp_add
  colnames(total_frame)[ncol(total_frame)] = new_col_name
}
#-------------------------------------------------------------------------------







# The below code adds edu_mod_data to total_frame
#
#-------------------------------------------------------------------------------
temp_cols = (grep("Total!!Estimate", names(edu_mod_data), value = TRUE))
temp_frame = edu_mod_data[,c("Label (Grouping)", temp_cols)]

temp_frame = temp_frame[-1,]
temp_frame = temp_frame[-c(1:5,16:67),]

# total_frame = total_frame[, 1:(ncol(total_frame) - 10)]



for (i in 2:ncol(temp_frame))
{
  
  temp_vec = temp_frame[[i]]
  # print(temp_vec)
  
  for (j in 1:length(temp_vec))
  {
    temp_vec[j] = gsub(",", "", temp_vec[j])
  }
  temp_vec = as.numeric(temp_vec)
  
  temp_denom = temp_vec[1]
  temp_vec_2 = sapply(temp_vec[2:length(temp_vec)], function(x) x/temp_denom)
  temp_vec = c(temp_vec[1], temp_vec_2)
  temp_frame[,i] = temp_vec
}




for (i in 1:length(temp_frame$`Label (Grouping)`))
{
  new_col_name = temp_frame$`Label (Grouping)`[i]
  new_col_name = gsub(",", "", new_col_name)
  new_col_name = gsub(" ", "_", new_col_name)
  new_col_name = gsub("  ", "_", new_col_name)
  
  if (i > 1)
  {
    new_col_name = paste("frac_", new_col_name)
  }
  
  new_col_name = gsub(" ", "", new_col_name)
  
  # print(new_col_name)
  
  temp_add = unname(as.vector(t(temp_frame[i, ])))
  temp_add = as.numeric(temp_add[-1])
  total_frame$temp_col = temp_add
  colnames(total_frame)[ncol(total_frame)] = new_col_name
}
#-------------------------------------------------------------------------------







# The below code adds first_degree_mod data to total_frame
#
#-------------------------------------------------------------------------------
temp_frame = first_degree_mod_data
temp_frame = temp_frame[-c(2,13),]



for (i in 2:ncol(temp_frame))
{
  
  temp_vec = temp_frame[[i]]
  # print(temp_vec)
  
  for (j in 1:length(temp_vec))
  {
    temp_vec[j] = gsub(",", "", temp_vec[j])
  }
  temp_vec = as.numeric(temp_vec)
  
  temp_denom = temp_vec[1]
  temp_vec_2 = sapply(temp_vec[2:length(temp_vec)], function(x) x/temp_denom)
  temp_vec = c(temp_vec[1], temp_vec_2)
  temp_frame[,i] = temp_vec
}



for (i in 2:length(temp_frame$`Label (Grouping)`))
{
  new_col_name = temp_frame$`Label (Grouping)`[i]
  new_col_name = gsub(",", "", new_col_name)
  new_col_name = gsub(" ", "_", new_col_name)
  new_col_name = gsub("  ", "_", new_col_name)
  
  new_col_name = paste("frac_of_bacc_degree_holders_first_degree_in_", new_col_name)
  
  new_col_name = gsub(" ", "", new_col_name)
  
  # print(new_col_name)
  
  temp_add = unname(as.vector(t(temp_frame[i, ])))
  temp_add = as.numeric(temp_add[-1])
  total_frame$temp_col = temp_add
  colnames(total_frame)[ncol(total_frame)] = new_col_name
}
#-------------------------------------------------------------------------------









# The below code is an attempt at compositional regression
#
#-------------------------------------------------------------------------------
race_frame = total_frame[, 3:11]
age_frame = total_frame[, 12:15]

# race_frame = ilr(race_frame)
# age_frame = ilr(age_frame)
# test_frame = alri

# analysis_frame = cbind(race_frame, age_frame)
analysis_frame = age_frame
analysis_frame = data.frame(analysis_frame, income = total_frame$median_household_income)

analysis_frame = analysis_frame[-2675, ]

# analysis_frame <- mutate_all(analysis_frame, ~ ifelse(is.infinite(.), 1e-10, .))

Y = log(analysis_frame$income)
X = acomp(analysis_frame[,1:(ncol(analysis_frame)-1)])

# bad_frame = subset(analysis_frame, income == 0)
# print(X)
# print(Y)
# print(any(Y < 0))
# negs = Y[Y<0]
# print(negs)

ilr_model = lm(Y~ilr(X))

summary(ilr_model)




# Obtain the coefficient estimates from the compositional regression model
coef_estimates <- as.numeric(coef(ilr_model))

# Define the inverse ALR transformation function
# inv_alr <- function(x) exp(x) / (1 + exp(x))
# Apply the inverse ALR transformation to the coefficient estimates
transformed_coefs <- ilrInv(coef(ilr_model)[-1],orig=X)

print(ilrInv(9236.859))

print(coef_estimates)
print(transformed_coefs)
# print(exp(coef_estimates))
# print(sum(coef_estimates))

# Interpret the transformed coefficients
for (i in seq_along(transformed_coefs)) {
  cat("An increase in", names(transformed_coefs)[i], "is correlated with an increase of", transformed_coefs[i], "in county median household income.\n")
}

#-------------------------------------------------------------------------------










#The following code is a naive regression attempt
#
#-------------------------------------------------------------------------------

regres_frame = total_frame[, -c(1,2)]

income_model = lm(median_household_income~., data = regres_frame)
summary(income_model)
