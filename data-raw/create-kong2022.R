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

# ── Download annotation files from CBIG repo ──────────
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

# ── 17 networks from Kong 2022 (for network-column derivation) ──
networks <- c(
  "VisualA", "VisualB", "VisualC",
  "SomMotA", "SomMotB",
  "DorsAttnA", "DorsAttnB",
  "SalVenAttnA", "SalVenAttnB",
  "ContA", "ContB", "ContC",
  "DefaultA", "DefaultB", "DefaultC",
  "Language", "Aud"
)
net_rx <- paste0("^(", paste(networks, collapse = "|"), ")")

clean_kong2022 <- function(atlas) {
  stripped <- sub("^17networks_(LH|RH)_", "", atlas$core$region)
  net <- regmatches(stripped, regexpr(net_rx, stripped))
  network_df <- unique(data.frame(
    region = stripped,
    network = net,
    stringsAsFactors = FALSE
  ))

  atlas |>
    atlas_region_rename("^17networks_(LH|RH)_", "") |>
    atlas_core_add(network_df, by = "region")
}

# ── Build each atlas variant ───────────────�
all_atlases <- list()

for (res in parcels) {
  atlas_name <- sprintf("kong2022_%d", res)

  annot_files <- file.path(
    annot_dir,
    sprintf(
      c(
        "lh.%dParcels_Kong2022_17Networks.annot",
        "rh.%dParcels_Kong2022_17Networks.annot"
      ),
      res
    )
  )

  if (!all(file.exists(annot_files))) {
    next
  }

  atlas_raw <- create_cortical_from_annotation(
    input_annot = annot_files,
    atlas_name = atlas_name,
    output_dir = file.path("data-raw", atlas_name),
    skip_existing = TRUE,
    cleanup = FALSE,
    tolerance = 0.1 * 100 / res
  ) |>
    atlas_region_contextual("unknown|Background", "label") |>
    clean_kong2022()

  all_atlases[[atlas_name]] <- atlas_raw
  plot(atlas_raw)
}

# ── Save all atlases as internal data ────────────�
sysdata_path <- here::here("R", "sysdata.rda")
sysdata_env <- new.env(parent = emptyenv())
if (file.exists(sysdata_path)) {
  load(sysdata_path, envir = sysdata_env)
}
for (nm in names(all_atlases)) {
  sysdata_env[[paste0(".", nm)]] <- all_atlases[[nm]]
}
save(
  list = ls(sysdata_env, all.names = TRUE),
  envir = sysdata_env,
  file = sysdata_path,
  compress = "xz"
)
