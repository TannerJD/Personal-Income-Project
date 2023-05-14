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

current_file_path = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(current_file_path)

# income_data = read.csv("County Income 2021 5-Year ACS Census.csv")

income_data = read_csv("County Income 2021 5-Year ACS Census.csv")
edu_data = read_csv("County Educational Attainment 2021 5-Year ACS Census.csv")
mobil_data = read_csv("County Geographic Mobility Past Year 2021 5-Year ACS.csv")
indmix_data = read_csv("")


income_data$Label..Grouping. = trimws(income_data$Label..Grouping.,whitespace = "[\\h\\v]")
