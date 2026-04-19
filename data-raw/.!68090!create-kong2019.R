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

    "Install {.pkg R.matlab}: {.code install.packages('R.matlab')}")
}
if (!requireNamespace("freesurferformats", quietly = TRUE)) {
  cli::cli_abort(

    "Install {.pkg freesurferformats}")
}

Sys.setenv(FREESURFER_HOME = "/Applications/freesurfer/7.4.1")

