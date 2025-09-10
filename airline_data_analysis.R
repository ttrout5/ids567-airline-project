getwd()

my_data <- read.csv("bts_airline_data_2024.csv", header = TRUE)

library(DBI)
library(RSQLite)

db_path <- "C:/Users/trout/OneDrive/Documents/UIC MSBA/Fall 2025/IDS 567/Project/Data/flights.db"

con <- dbConnect(RSQLite::SQLite(), dbname = db_path)

dbListTables(con)

dbGetQuery(con, "SELECT * FROM flights LIMIT 10;")

# Get only Southwest Airlines flights
southwest <- dbGetQuery(con, "
  SELECT *
  FROM flights
  WHERE Reporting_Airline = 'WN'
  LIMIT 100;
")

head(southwest)

# Get column names
cols <- dbListFields(con, "flights")

# Build queries for each column
queries <- lapply(cols, function(c) {
  sql <- sprintf("SELECT '%s' AS column, COUNT(*) AS missing FROM flights WHERE %s IS NULL OR %s = '';", c, c, c)
  dbGetQuery(con, sql)
})

# Combine results
do.call(rbind, queries)

SELECT COUNT(*) AS TotalRows
FROM flights;

count_rows <- dbGetQuery(con, "SELECT COUNT(*) AS TotalRows FROM flights;")

head(count_rows)


