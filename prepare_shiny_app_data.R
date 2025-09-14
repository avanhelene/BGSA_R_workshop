library(dplyr)
library(tidyr)
library(tigris)

# Read in cancer data
data_path <- file.path("data", "us_cancer_incidence_county_09-04-2025.csv")
us_cancer_incidence_county <- read.csv(data_path,
                                       check.names = FALSE)

# Get columns that we will pivot to long format
columns <- colnames(us_cancer_incidence_county) # Get all columns
columns <- columns[!columns %in% c("FIPS", "County", "State", "Type", "RE", "Sex")] # Filter out columns that we are not pivoting to long format 

# Pivot the table to long format
us_cancer_incidence_county_long <- us_cancer_incidence_county |>
  tidyr::pivot_longer(cols = -c(FIPS, 
                                County, 
                                State, 
                                Type, 
                                RE, 
                                Sex), # Specify which columns are serve as row IDs and are not pivoted to long format
                      names_to = "cancer_site", # Store the old column names in the new "cancer_site' column
                      values_to = "age_adjusted_rate") # Store the old column values in the new

# Get a vector of all values in "cancer_site" that end with ")"
# We want to remove "cancer_site" values with parentheses like "Bladder (18-49 years)"
cancer_site_values <- unique(us_cancer_incidence_county_long$cancer_site) # Get all unique values in the "cancer_site" column
cancer_site_values_with_parentheses <- cancer_site_values[endsWith(cancer_site_values, ")")]

# Filter out rows where "cancer_site" is in cancer_site_values_with_parentheses
us_cancer_incidence_county_long <- us_cancer_incidence_county_long |>
  dplyr::filter(!cancer_site %in% cancer_site_values_with_parentheses)

# Get county polygons with FIPS GEOID
# Exclude AK, HI, PR, and territories for a compact continental view
counties_sf <- counties(cb = TRUE, resolution = "5m", year = 2023, class = "sf") 
counties_sf_filt <- counties_sf|>
  # Filter out states that are not in the contiguous US
  dplyr::filter(!STATEFP %in% c("02","15","60","66","69","72","78")) |>
  # Combine the state and county FIPS code 
  dplyr::mutate(FIPS = as.integer(paste0(STATEFP, COUNTYFP))) |>
  dplyr::select(FIPS, geometry)

# Keep only certain cancer sites
sites_to_keep <- c(
  "Lung & Bronchus",
  "Colon & Rectum",
  "Melanoma of the Skin",
  "Non-Hodgkin Lymphoma",
  "Thyroid",
  "Kidney & Renal Pelvis",
  "Bladder",
  "Head and Neck",
  "Liver & IBD",
  "Pancreas",
  "Stomach",
  "Leukemia",
  "Brain & ONS"
)
us_cancer_incidence_county_long <- us_cancer_incidence_county_long |>
  dplyr::filter(cancer_site %in% sites_to_keep)

write.csv(us_cancer_incidence_county_long,
          file.path("BGSA_R_workshop_cancer_incidence_app", 
                    "shiny_app_cancer_data.csv"),
          row.names = FALSE)

saveRDS(counties_sf_filt,
        file.path("BGSA_R_workshop_cancer_incidence_app", 
                  "county_polygons.RData"))
