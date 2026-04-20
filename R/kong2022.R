#' Kong 2022 Areal MS-HBM 17-Network Atlases
#'
#' Brain atlases for the Kong et al. (2022) Areal MS-HBM cortical
#' parcellation aligned to Yeo 17 resting-state networks. Available in
#' 100 to 1000 parcel configurations.
#' Contains both 2D polygon geometry for [ggseg::geom_brain()] and
#' 3D vertex indices for [ggseg3d::ggseg3d()].
#'
#' @family ggseg_atlases
#' @family cortical_atlases
#'
#' @references Kong R, et al. (2022). "Individual-Specific Areal-Level
#'   Parcellations Improve Functional Connectivity Prediction of Behavior."
#'   *Cerebral Cortex*, 31(10):4477-4500.
#'   \doi{10.1093/cercor/bhab101}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (cortical).
#' @export
#' @examples
#' kong2022_100()
#' plot(kong2022_100())
#' plot(kong2022_1000())
kong2022_100 <- function() .kong2022_100

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_200()
kong2022_200 <- function() .kong2022_200

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_300()
kong2022_300 <- function() .kong2022_300

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_400()
kong2022_400 <- function() .kong2022_400

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_500()
kong2022_500 <- function() .kong2022_500

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_600()
kong2022_600 <- function() .kong2022_600

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_700()
kong2022_700 <- function() .kong2022_700

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_800()
kong2022_800 <- function() .kong2022_800

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_900()
kong2022_900 <- function() .kong2022_900

#' @rdname kong2022_100
#' @export
#' @examples
#' kong2022_1000()
kong2022_1000 <- function() .kong2022_1000
