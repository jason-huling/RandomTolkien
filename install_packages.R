
## Install CRAN Packages
cranRepo <- 'http://cran.rstudio.com'

install.packages('magrittr', repos = cranRepo)
install.packages('rvest', repos = cranRepo)
install.packages('plyr', repos = cranRepo)
install.packages('ngram', repos = cranRepo)

## Install Github Packages
packrat::install_github('trestletech/rapier')
