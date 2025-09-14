library(tidyverse)

# Character variable
example_R_character_variable <- "variable value"

# Numeric variable
example_R_numeric_variable <- 1234

# Data frame
example_R_data_frame <- tibble::tribble(
  ~column_1, ~column_2, ~column_3,
  "a", "A", 1,
  "b", "B", 2,
  "c", "C", 3
) |>
  as.data.frame()

# There are different classes of variables
class(example_R_variable) # example_R_character_variable is a "character" string
class(example_R_numeric_variable) # example_R_numeric_variable is numeric
class(example_R_data_frame) # example_R_numeric_variable is a data frame

