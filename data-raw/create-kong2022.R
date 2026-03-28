# Create Kong 2022 Areal MS-HBM Cortical Atlases
#
# Creates the Kong et al. (2022) Areal Multi-Session Hierarchical Bayesian
# Model cortical parcellations at 100-1000 parcels with 17-network labels.
#
# Reference: Kong R, et al. (2022). Cerebral Cortex, 31(10):4477-4500.
#
# Run with: Rscript data-raw/create-atlas.R

library(ggseg.extra)
library(ggseg.formats)

Sys.setenv(FREESURFER_HOME = "/Applications/freesurfer/7.4.1")

# ── Download annotation files from CBIG repo ─────────────────────
cbig_base <- paste0(
  "https://raw.githubusercontent.com/ThomasYeoLab/CBIG/master/",
  "stable_projects/brain_parcellation/Yan2023_homotopic/parcellations/",
  "FreeSurfer/fsaverage5/label/kong17"
)

annot_dir <- here::here("data-raw", "fsaverage5")
dir.create(annot_dir, showWarnings = FALSE, recursive = TRUE)

parcels <- seq(100, 1000, by = 100)

for (res in parcels) {
  for (hemi in c("lh", "rh")) {
    fname <- sprintf("%s.%dParcels_Kong2022_17Networks.annot", hemi, res)
    dest <- file.path(annot_dir, fname)
    if (!file.exists(dest)) {
      url <- file.path(cbig_base, fname)
      cli::cli_alert_info("Downloading {.file {fname}}")
      download.file(url, dest, mode = "wb", quiet = TRUE)
    }
  }
}

# ── Build each atlas variant ─────────────────────────────────────
all_atlases <- list()

for (res in parcels) {
  atlas_name <- sprintf("kong2022_%d", res)

  annot_files <- file.path(
    annot_dir,
    sprintf(
      c("lh.%dParcels_Kong2022_17Networks.annot",
        "rh.%dParcels_Kong2022_17Networks.annot"),
      res
    )
  )

  if (!all(file.exists(annot_files))) next

  atlas_raw <- create_cortical_from_annotation(
    input_annot = annot_files,
    atlas_name = atlas_name,
    output_dir = file.path("data-raw", atlas_name),
    skip_existing = TRUE,
    cleanup = FALSE
  ) |>
    atlas_region_contextual("unknown|Background", "label")

  all_atlases[[atlas_name]] <- atlas_raw
  print(atlas_raw)
  plot(atlas_raw)
}

# ── Save all atlases as internal data ─────────────────────────────
sysdata_env <- new.env(parent = emptyenv())
for (nm in names(all_atlases)) {
  sysdata_env[[paste0(".", nm)]] <- all_atlases[[nm]]
}
save(
  list = ls(sysdata_env, all.names = TRUE),
  envir = sysdata_env,
  file = here::here("R", "sysdata.rda"),
  compress = "xz"
)
