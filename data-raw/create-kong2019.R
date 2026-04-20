# Create Kong 2019 MS-HBM 17-Network Cortical Atlas
#
# Downloads the group-level 17-network spatial priors from the CBIG
# repository (GSP_37 variant, fsaverage5 space) and converts to
# FreeSurfer .annot format for atlas creation.
#
# Source: https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/
#   brain_parcellation/Kong2019_MSHBM/lib/group_priors/GSP_37
#
# Reference: Kong R, et al. (2019). "Spatial Topography of Individual-Specific
#   Cortical Networks Predicts Human Cognition, Personality, and Emotion."
#   Cerebral Cortex, 29(6):2533-2551. DOI: 10.1093/cercor/bhy123
#
# Requirements:
#   - FreeSurfer installed with fsaverage5 subject
#   - ggseg.extra, ggseg.formats, R.matlab, freesurferformats packages
#
# Run with: Rscript data-raw/create-atlas.R

library(ggseg.extra)
library(ggseg.formats)

if (!requireNamespace("R.matlab", quietly = TRUE)) {
  cli::cli_abort(
    "Install {.pkg R.matlab}: {.code install.packages('R.matlab')}"
  )
}
if (!requireNamespace("freesurferformats", quietly = TRUE)) {
  cli::cli_abort(
    "Install {.pkg freesurferformats}"
  )
}

Sys.setenv(FREESURFER_HOME = "/Applications/freesurfer/7.4.1")

# ── Download group priors from CBIG repository ─────────�
cbig_base <- paste0(
  "https://raw.githubusercontent.com/ThomasYeoLab/CBIG/master/",
  "stable_projects/brain_parcellation/Kong2019_MSHBM/",
  "lib/group_priors/GSP_37"
)

mat_dir <- here::here("data-raw", "mat")
dir.create(mat_dir, showWarnings = FALSE, recursive = TRUE)

for (f in c("Params_Final.mat", "17network_labels.mat")) {
  dest <- file.path(mat_dir, f)
  if (!file.exists(dest)) {
    url <- file.path(cbig_base, f)
    cli::cli_alert_info("Downloading {.file {f}}")
    download.file(url, dest, mode = "wb", quiet = TRUE)
  }
}

# ── Read group prior theta (network probability per vertex) ─────
mat <- R.matlab::readMat(file.path(mat_dir, "Params_Final.mat"))

params <- mat$Params[,, 1]
theta <- params$theta
if (is.null(theta) || !is.matrix(theta)) {
  cli::cli_abort("Could not find theta matrix in Params_Final.mat")
}
cli::cli_alert_info("Found theta: {paste(dim(theta), collapse = ' x ')}")

if (ncol(theta) != 17 && nrow(theta) == 17) {
  theta <- t(theta)
}
stopifnot("Expected 17 network columns" = ncol(theta) == 17)

n_vertices <- nrow(theta)
n_per_hemi <- n_vertices %/% 2L
cli::cli_alert_info("{n_vertices} vertices ({n_per_hemi} per hemisphere)")

vertex_labels <- apply(theta, 1, which.max)
lh_labels <- vertex_labels[seq_len(n_per_hemi)]
rh_labels <- vertex_labels[seq(n_per_hemi + 1L, n_vertices)]

# ── Read network label mapping ──────────────�
labels_mat <- R.matlab::readMat(file.path(mat_dir, "17network_labels.mat"))
label_map <- NULL
for (nm in names(labels_mat)) {
  obj <- labels_mat[[nm]]
  if (is.numeric(obj) && length(obj) == 17) {
    label_map <- as.integer(obj)
    cli::cli_alert_info(
      "Network label mapping from '{nm}': {paste(label_map, collapse = ', ')}"
    )
    break
  }
}

# ── 17-network colortable (standard Yeo 2011 colors) ───────�
yeo17_colors <- data.frame(
  struct_name = c(
    "MedialWall",
    "17Networks_1",
    "17Networks_2",
    "17Networks_3",
    "17Networks_4",
    "17Networks_5",
    "17Networks_6",
    "17Networks_7",
    "17Networks_8",
    "17Networks_9",
    "17Networks_10",
    "17Networks_11",
    "17Networks_12",
    "17Networks_13",
    "17Networks_14",
    "17Networks_15",
    "17Networks_16",
    "17Networks_17"
  ),
  r = c(
    1L,
    120L,
    255L,
    70L,
    42L,
    74L,
    0L,
    196L,
    255L,
    220L,
    122L,
    119L,

    230L,
    135L,
    12L,
    0L,
    255L,
    205L
  ),
  g = c(
    1L,
    18L,
    0L,
    130L,
    204L,
    155L,
    118L,
    58L,
    152L,
    248L,
    135L,
    140L,

    148L,
    50L,
    48L,
    0L,
    255L,
    62L
  ),
  b = c(
    1L,
    134L,
    0L,
    180L,
    164L,
    60L,
    14L,
    250L,
    213L,
    164L,
    50L,
    176L,

    34L,
    74L,
    255L,
    130L,
    0L,
    78L
  ),
  a = rep(0L, 18L),
  stringsAsFactors = FALSE
)

if (!is.null(label_map)) {
  reordered <- yeo17_colors[1L, , drop = FALSE]
  for (i in seq_along(label_map)) {
    reordered <- rbind(reordered, yeo17_colors[label_map[i] + 1L, ])
  }
  yeo17_colors <- reordered
}

# ── Write annotation files ────────────────
annot_dir <- here::here("data-raw", "fsaverage5")
dir.create(annot_dir, showWarnings = FALSE, recursive = TRUE)

lh_codes <- yeo17_colors$r[lh_labels + 1L] +
  yeo17_colors$g[lh_labels + 1L] * 256L +
  yeo17_colors$b[lh_labels + 1L] * 65536L +
  yeo17_colors$a[lh_labels + 1L] * 16777216L

rh_codes <- yeo17_colors$r[rh_labels + 1L] +
  yeo17_colors$g[rh_labels + 1L] * 256L +
  yeo17_colors$b[rh_labels + 1L] * 65536L +
  yeo17_colors$a[rh_labels + 1L] * 16777216L

annot_files <- file.path(
  annot_dir,
  c("lh.Kong2019_17Networks.annot", "rh.Kong2019_17Networks.annot")
)

freesurferformats::write.fs.annot(
  annot_files[1],
  num_vertices = n_per_hemi,
  colortable = yeo17_colors,
  labels_as_colorcodes = lh_codes
)

freesurferformats::write.fs.annot(
  annot_files[2],
  num_vertices = n_per_hemi,
  colortable = yeo17_colors,
  labels_as_colorcodes = rh_codes
)

cli::cli_alert_success("Created annotation files in {.path {annot_dir}}")

# ── Create atlas ───────────────────�
cli::cli_h1("Creating kong2019 cortical atlas (17 networks)")

kong2019 <- create_cortical_from_annotation(
  input_annot = annot_files,
  atlas_name = "kong2019",
  output_dir = "data-raw",
  skip_existing = TRUE,
  cleanup = FALSE
) |>
  atlas_region_contextual("unknown|Background|MedialWall", "label")


kong2019 <- kong2019 |>
  ggseg.formats::atlas_region_rename("17Networks_(\\d+)", "\\1") |>
  ggseg.formats::atlas_region_contextual("17Networks_1$", "label")


print(kong2019)
plot(kong2019)

sysdata_path <- here::here("R", "sysdata.rda")
sysdata_env <- new.env(parent = emptyenv())
if (file.exists(sysdata_path)) {
  load(sysdata_path, envir = sysdata_env)
}
sysdata_env$.kong2019 <- kong2019
save(
  list = ls(sysdata_env, all.names = TRUE),
  envir = sysdata_env,
  file = sysdata_path,
  compress = "xz"
)
