library(magrittr)
library(rvest)
library(plyr)


## =============================================================================
## Helper Functions
## =============================================================================

GetPageCount <- function(baseUrl) {

	## Return the html of the first page, look for the page count
	## link, extract the text, remove non numbers, convert to number

	paste0(baseUrl, '.html') %>%
		html() %>%
		html_node(xpath = "//ul[ @class = 'pagelist' ]/li[1]/a") %>%
		html_text() %>%
		{ gsub('[^0-9]', '', .) } %>%
		as.numeric()
}

AssemblePageUrls <- function(baseUrl) {

	## Get the page count for the home page, then assemble the urls for
	## all the pages in this book

	pages <- GetPageCount(baseUrl)

	paste0(baseUrl, '.html') %>%
		c(paste0(baseUrl, '_', 2:pages, '.html'))

}

DownloadHtmlPages <- function(baseUrl, maxPages = NULL) {

	## Assemble urls for all pages from baseUrl, then get
	## the html content for those urls

	message('Downloading web pages')
	baseUrl %>%
		AssemblePageUrls() %>% {
			if (!is.null(maxPages))
				.[1:maxPages]
			else
				.
		} %>%
		llply(function(x) html(x))

}

ExtractTextFromHtml <- function(htmlDocs) {

	## Extract/Parse out text from html documents and return single
	## string of data

	message('Extracting text from html')
	htmlDocs %>%
		llply( function(x) {
			html_nodes(x, xpath = "//p[ not(@class = 'info') ]") %>%
			html_text() } ) %>%
		unlist() %>%
		paste(collapse = ' ')

}

CleanseCorpus <- function(corpus) {

	## This will perform any cleansing of the corpus that
	## is needed before evaluating ngrams

	message('Cleansing the corpus')
	corpus %>%
		## Remove carriage returns
		{gsub('\r', '', .)}

}

GetBookCorpus <- function(genre, id, maxPages = NULL) {

	## DownloadHtmlPages are specific to this website
	website <- 'http://www.5novels.com'
	baseUrl <- paste(website, genre, id, sep = '/')

	message('Processing ', baseUrl)
	## Process the base url to return the corpus of the book
	baseUrl %>%
		DownloadHtmlPages(maxPages = maxPages) %>%
		ExtractTextFromHtml() %>%
		CleanseCorpus()

}
