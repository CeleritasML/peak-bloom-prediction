if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, styler,
               janitor, fpp3, fable,
               rnoaa)

#' Get the annual average maximum temperature at the given station,
#' separated into the 4 meteorological seasons (Winter, Spring, Summer, Fall).
#' 
#' The seasons are span 3 months each.
#' Winter is from December to February, Spring from March to May,
#' Summer from June to August, and Fall from September to November.
#' Note that December is counted towards the Winter of the next year, i.e.,
#' temperatures in December 2020 are accounted for in Winter 2021.
#' 
#' @param stationid the `rnoaa` station id (see [ghcnd_stations()])
#' @return a data frame with columns
#'   - `year` ... the year of the observations
#'   - `season` ... the season (Winter, Spring, Summer, Fall)
#'   - `tmax_avg` ... average maximum temperate in tenth degree Celsius
get_temperature <- function (stationid) {
  ghcnd_search(stationid = stationid, var = c("tmax"), 
               date_min = "1950-01-01", date_max = "2022-01-31")[[1]] %>%
    mutate(year = as.integer(format(date, "%Y")),
           month = as.integer(strftime(date, '%m')) %% 12, # make December "0"
           season = cut(month, breaks = c(0, 2, 5, 8, 11),
                        include.lowest = TRUE,
                        labels = c("Winter", "Spring", "Summer", "Fall")),
           year = if_else(month == 0, year + 1L, year)) %>%
    group_by(year, season) %>%
    summarize(tmax_avg = mean(tmax, na.rm = TRUE))
}

historic_temperatures <-
  tibble(location = "washingtondc", get_temperature("USC00186350")) %>%
  bind_rows(tibble(location = "liestal", get_temperature("GME00127786"))) %>%
  bind_rows(tibble(location = "kyoto", get_temperature("JA000047759"))) %>%
  bind_rows(tibble(location = "vancouver", get_temperature("CA001108395")))

winter_temp <- historic_temperatures |>
  filter(year >= 1980 & season=="Winter") |>
  select(location, year, tmax_avg)

cherry <- read_csv("data/washingtondc.csv") |>
  bind_rows(read_csv("data/liestal.csv")) |>
  bind_rows(read_csv("data/kyoto.csv")) |>
  filter(year>=1980) |>
  select(location, lat, long, alt, year, bloom_doy) |>
  left_join(winter_temp, by=c("location"="location", "year"="year"))

# wakkanai <- read_csv("data/japan.csv") |>
#   filter(year>=1980) |>
#   filter(location=="Japan/Wakkanai") |>
#   select(location, lat, long, alt, year, bloom_doy) |>
#   mutate(location="wakkanai")

# cherry <- cherry |>
#   bind_rows(wakkanai)

# cherry |>
#   ggplot(aes(x=year, y=bloom_doy)) +
#   geom_point() +
#   scale_x_continuous(breaks=seq(1980, 2020, by=5)) +
#   facet_wrap(location ~ .) +
#   labs(
#     x="Year",
#     y="Peak bloom day"
#   )

washingtondc <- cherry |>
  filter(location=="washingtondc") |>
  select(year, bloom_doy, tmax_avg) |>
  as_tsibble(index = year)

washingtondc_pred <- washingtondc |>
  model(VAR(vars(bloom_doy, tmax_avg) ~ AR(3))) |>
  forecast(h=10)

washingtondc_pred |>
  autoplot(washingtondc) +
  labs(x="Year", y="bloom date of the year",
       title="Yearly bloom date")

liestal <- cherry |>
  filter(location=="liestal") |>
  select(year, bloom_doy, tmax_avg) |>
  as_tsibble(index = year)

liestal_pred <- liestal |>
  model(VAR(vars(bloom_doy, tmax_avg) ~ AR(3))) |>
  forecast(h=10)

liestal_pred |>
  autoplot(liestal) +
  labs(x="Year", y="bloom date of the year",
       title="Yearly bloom date")

kyoto <- cherry |>
  filter(location=="kyoto") |>
  select(year, bloom_doy, tmax_avg) |>
  as_tsibble(index = year)

kyoto_pred <- kyoto |>
  model(VAR(vars(bloom_doy, tmax_avg) ~ AR(3))) |>
  forecast(h=10)

kyoto_pred |>
  autoplot(kyoto) +
  labs(x="Year", y="bloom date of the year",
       title="Yearly bloom date")

output <- tibble(
  year = seq(2022, 2031),
  kyoto = round(kyoto_pred$.mean[,1]),
  liestal = round(liestal_pred$.mean[,1]),
  washingtondc = round(washingtondc_pred$.mean[,1])
)

output <- output |>
  rowwise() |>
  mutate(vancouver = round((kyoto+liestal+washingtondc)/3)) |>
  write_csv("cherry-predictions.csv")
