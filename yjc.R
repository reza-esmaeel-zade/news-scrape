library(xml2)
library(rvest)
library(tidyverse)

httr::set_config(httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/116.0"))

base_url <<- 'https://www.yjc.ir/fa/archive?service_id=-1&sec_id=-1&cat_id=-1&rpp=100&from_date=1390/01/01&to_date=1402/06/21&p='

news <- c()
for (i in 1:500) {
  url <- paste0(base_url,i)
  
  web <- read_html(url)
  news_tmp <- web %>% 
    html_element('div.archive_content') %>% 
    html_elements('a') %>% 
    html_attr('href')
  news_tmp <- paste('https://www.yjc.ir', news_tmp, sep = '')
  news <- c(news,news_tmp)
}

cat('news url scraped')
save.image('yjc.RData')

news2 <- news[20314:50000]
j <- 0L
for(n in news2){
  cond <<- T
  while (cond) {
    tryCatch(
      expr = {
        web <- read_html(n)
        date <- web %>%
          html_element('span.photo-newspage-date') %>%
          html_text2()
        tags <- web %>%
          html_elements('div.tag_items_photo') %>%
          html_elements('a') %>%
          html_text()
        subject <- web %>%
          html_elements('h1.Htags span.title-news') %>%
          html_text2()
        comments <- NA
        likes <- NA
        data <- list(list(subject=subject, date=date, tags=tags,
                          comments=comments, likes=likes))
        if('yjc' %in% ls()) yjc <- c(yjc, data)
        else yjc <- data
        j <- j+1L
        cat(j, 'news scraped\n')
        break},
      warning = function(w){print('warning occurred')},
      error = function(e){
        print(paste('error occurred:', e$message))
        if(e$message == 'HTTP error 404.'){ 
          cond <<- F
          news2 <<- news2[!news2 %in% n]
          news <<- news[!news %in% n]
          }
        },
      finally = {print('handled')} 
    )
  }
}

save.image('yjc.RData')

