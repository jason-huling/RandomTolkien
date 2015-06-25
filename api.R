
# api.R

#' @get /tolkien
tolkienBabble <- function(n = 40) {
	babble(tolkienNgram2, n)
}
