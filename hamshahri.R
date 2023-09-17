library(xml2)
library(rvest)
library(tidyverse)

httr::set_config(httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/116.0"))

base_url <<- 'https://www.hamshahrionline.ir/page/archive.xhtml?wide=0&ms=0&pi='

news <- c()
for (i in 1:100) {
  url <- paste0(base_url,i)
  
  web <- read_html(url)
  news_tmp <- web %>% 
    html_element(css = '#box16') %>% 
    html_elements(css = 'li figure a') %>% 
    html_attr('href')
  news_tmp <- paste('https://www.hamshahrionline.ir', news_tmp, sep = '')
  news <- c(news,news_tmp)
}

cat('news url scraped')

for(n in news){
  web <- read_html(n)
  date <- web %>%
    html_elements(css = '.col-4.col-sm-4.col-xl-4.item-date') %>%
    html_elements(css = 'span') %>%
    html_text()
  tags <- web %>%
    html_elements('section.box.tags') %>%
    html_elements('div ul li') %>%
    html_text()
  subject <- web %>%
    html_elements('h1') %>%
    html_text()
  comments <- web %>%
    html_element('span.com-num') %>%
    html_text()
  comments <- sub('مجموع نظرات: ', '', comments)
  likes <- web %>%
    html_element('div.rate-count') %>%
    html_text()
  likes <- sub(' نفر', '', likes)
  data <- list(list(subject=subject, date=date, tags=tags,
                     comments=comments, likes=likes))
  if('hamshahri' %in% ls()) hamshahri <- c(hamshahri, data)
  else hamshahri <- data
}

save.image('hamshahri.RData')

