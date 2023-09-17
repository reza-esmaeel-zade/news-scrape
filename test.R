list_of_packs <<- c('rvest', 'dplyr', 'stringr')
new_packs <<- list_of_packs[!(list_of_packs %in% rownames(installed.packages()))]
if(length(new_packs)) install.packages(pkgs = new_packs)
