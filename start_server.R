library(rapier)
library(magrittr)
library(plyr)
library(ngram)

source('functions.R', local = TRUE)

## =============================================================================
## Startup Data Processing
## =============================================================================

## -----------------------------------------------------------------------------
## Tolkien Books
## -----------------------------------------------------------------------------

## Define books to get
tolkienBooks <- paste0('u', 5688:5691)

## Assemble the book corpus
tolkienCorpus <-
	tolkienBooks %>%
	llply(function(x) GetBookCorpus('classics', x)) %>%
	paste(collapse = ' ')

tolkienNgram2 <- ngram(tolkienCorpus, n = 2)


## =============================================================================
## Initializing the API
## =============================================================================

api <- rapier('api.R')  # Where 'myfile.R' is the location of the file shown above
api$run(port = 8000)
