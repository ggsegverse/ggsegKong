# ggsegKong

<!-- badges: start -->
[![R-CMD-check](https://github.com/ggsegverse/ggsegKong/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ggsegverse/ggsegKong/actions/workflows/R-CMD-check.yaml)
[![r-universe](https://ggsegverse.r-universe.dev/badges/ggsegKong)](https://ggsegverse.r-universe.dev/ggsegKong)
<!-- badges: end -->

Kong Cortical Parcellation Atlases for the ggsegverse Ecosystem.

## Installation

``` r
# From r-universe
install.packages("ggsegKong", repos = "https://ggsegverse.r-universe.dev")

# From GitHub
# install.packages("remotes")
remotes::install_github("ggsegverse/ggsegKong")
```

## Usage

``` r
library(ggsegKong)
library(ggseg)

plot(kong2019()) +
  theme_brain()
```

## Atlases

### kong2019

Kong 2019 MS-HBM 17-network cortical parcellation (Kong et al., 2019).

### kong2022

Kong 2022 Areal MS-HBM 17-network parcellations at 10 resolutions (Kong et al., 2022).

| Parcels | Function |
|--------:|:---------|
| 100 | `kong2022_100()` |
| 200 | `kong2022_200()` |
| 300 | `kong2022_300()` |
| 400 | `kong2022_400()` |
| 500 | `kong2022_500()` |
| 600 | `kong2022_600()` |
| 700 | `kong2022_700()` |
| 800 | `kong2022_800()` |
| 900 | `kong2022_900()` |
| 1000 | `kong2022_1000()` |

## Data sources

| Atlas | Source | Reference | Date obtained |
|-------|--------|-----------|---------------|
| kong2019 | MATLAB group priors from [ThomasYeoLab/CBIG](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Kong2019_MSHBM/lib/group_priors/GSP_37), converted to fsaverage5 .annot | Kong et al. (2019) [doi:10.1093/cercor/bhy123](https://doi.org/10.1093/cercor/bhy123) | 2026-03-28 |
| kong2022 | Annotation files from [ThomasYeoLab/CBIG](https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Yan2023_homotopic/parcellations/FreeSurfer/fsaverage5/label/kong17) (fsaverage5) | Kong et al. (2022) [doi:10.1093/cercor/bhab101](https://doi.org/10.1093/cercor/bhab101) | 2026-03-28 |
