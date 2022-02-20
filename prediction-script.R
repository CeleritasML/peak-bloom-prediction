if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, styler,
               janitor, fpp3)

cherry <- read_csv("data/washingtondc.csv") |>
  bind_rows(read_csv("data/liestal.csv")) |>
  bind_rows(read_csv("data/kyoto.csv")) |>
  filter(year>=1980) |>
  select(location, lat, long, alt, year, bloom_doy)

wakkanai <- read_csv("data/japan.csv") |>
  filter(year>=1980) |>
  filter(location=="Japan/Wakkanai") |>
  select(location, lat, long, alt, year, bloom_doy) |>
  mutate(location="wakkanai")

cherry <- cherry |>
  bind_rows(wakkanai)

cherry |>
  ggplot(aes(x=year, y=bloom_doy)) +
  geom_point() +
  scale_x_continuous(breaks=seq(1980, 2020, by=5)) +
  facet_wrap(location ~ .) +
  labs(
    x="Year",
    y="Peak bloom day"
  )
