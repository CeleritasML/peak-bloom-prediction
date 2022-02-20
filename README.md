# Cherry Blossom Peak Bloom Prediction

> The list of stations can be retrieved using the ghcnd_stations() function. Note that the closest weather station to each city with continuously collected maximum temperatures are USC00186350 (Washington D.C.), GME00127786 (Liestal), JA000047759 (Kyoto), and CA001108395 (Vancouver).

[GHCND Stations](https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt)

- JA000047401, 45.4170, 141.6830, 12.0, WAKKANAI JAPAN


***

The rendered demo analysis is available at https://competition.statistics.gmu.edu/demo_analysis.html.

## Competition rules

To enter the competition you must submit your predictions and the URL pointing to your repository via https://competition.statistics.gmu.edu.

**Entries must be submitted by the end of February 28, 2022 (anywhere on earth)**.
If it's February anywhere on earth, your submission will be considered.

The predictions are judged based on the sum of the absolute differences between your predicted peak bloom dates and the publicly posted peak bloom dates:

```
| predicted_bloom_date_kyoto_2022 - actual_bloom_date_kyoto_2022 | +
  | predicted_bloom_date_washingtondc_2022 - actual_bloom_date_washingtondc_2022 | +
  | predicted_bloom_date_liestal_2022 - actual_bloom_date_liestal_2022 | +
  | predicted_bloom_date_vancouver_2022 - actual_bloom_date_vancouver_2022 |
```

The true bloom dates for 2022 are taken to be the dates reported by the following agencies/institutions:

- **Kyoto (Japan):** a local news paper from Arashiyama as published at http://atmenv.envi.osakafu-u.ac.jp/aono/kyophenotemp4,
- **Washington, D.C. (USA):** National Park Service,
- **Liestal-Weideli (Switzerland):** MeteoSwiss,
- **Vancouver, BC (Canada):** Vancouver Cherry Blossom Festival in collaboration with Douglas Justice, Associate Director, Curator of Collections, UBC Botanical Garden.

The full competition rules are available under https://competition.statistics.gmu.edu.

## License

![CC-BYNCSA-4](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)

Unless otherwise noted, the content in this repository is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

For the data sets in the _data/_ folder, please see [_data/README.md_](data/README.md) for the applicable copyrights and licenses.
