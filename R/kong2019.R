#' Kong 2019 MS-HBM 17-Network Atlas
#'
#' Brain atlas for the Kong et al. (2019) Multi-Session Hierarchical
#' Bayesian Model 17-network cortical parcellation.
#' Contains both 2D polygon geometry for [ggseg::geom_brain()] and
#' 3D vertex indices for [ggseg3d::ggseg3d()].
#'
#' @family ggseg_atlases
#' @family cortical_atlases
#'
#' @references Kong R, et al. (2019). "Spatial Topography of Individual-Specific
#'   Cortical Networks Predicts Human Cognition, Personality, and Emotion."
#'   *Cerebral Cortex*, 29(6):2533-2551.
#'   \doi{10.1093/cercor/bhy123}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (cortical).
#' @export
#' @examples
#' kong2019()
#' plot(kong2019())
kong2019 <- function() .kong2019
