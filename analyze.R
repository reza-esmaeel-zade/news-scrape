load('yjc.RData')
load('hamshahri.RData')

data <- c(yjc, hamshahri)

rm(list = ls()[-4])

tags <- c()

for(l in data){
  tags <- c(tags, l$tags)
}

library(tidyverse)
tags <- data.frame(tags = tags)

tags_important <- tags %>% 
  group_by(tags) %>% 
  summarise(count = n()) %>% 
  filter(count >= 50)


png(file = "important_tags.png", width = 1920*4, height = 1080*4, pointsize = 12*4) #png device

ggplot(tags_important, mapping = aes(x = reorder(tags, count), y = count)) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90,vjust = 0.35, hjust = 1, size = 40),
        axis.text.y = element_text(size = 40),
        axis.title.x = element_text(size = 40),
        axis.title.y = element_text(size = 40),
        text = element_text(family = 'Vazirmatn')) +
  scale_y_continuous(breaks = seq(0,860,20), expand = c(0.01,0,0.01,0)) +
  labs(x = "مهم‌ترین برچسب‌ها", y = "تکرار")

dev.off()

#---- SUBJECT ----
subject <- c()

for(l in data){
  subject <- c(subject, l$subject)
}

subject <- data.frame(subject = subject)

#_________________________________________
# Load the required packages
library(tm)
library(SnowballC)
library(wordcloud)
library(wordcloud2)
library(dplyr)
library(htmlwidgets)
library(webshot2)

# Create a text corpus from the subject column of your dataframe
# Assuming your dataframe is called df
docs <- Corpus(VectorSource(subject$subject))

tdm <- TermDocumentMatrix(docs)
matrix <- as.matrix(tdm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)
# A vector of simple prepositions in Persian
simple_preps <- c("از", "به", "با", "بی", "در", "بر", "برای", "تا", "مگر", "جز", "الا", "چون", "اندر", "زی","شد", "است", "را")

rm(list = ls()[c(3,4,5,8,9)])

df <- df %>% 
  filter(!word %in% simple_preps)

wordcloud(words = df$word, freq = df$freq, min.freq = 100, max.words=200, colors=brewer.pal(8, "Dark2"),use.r.layout = T)

wc <- wordcloud2(data=df, shape = 'pentagon', fontFamily = 'Vazirmatn',fontWeight = 600, widgetsize = c(1920,1080), gridSize = 5)

# save the wordcloud object as an HTML file
saveWidget(wc, "wordcloud.html")

Sys.setenv(CHROMOTE_CHROME = "C:\\Program Files\\BraveSoftware\\Brave-Browser\\Application\\brave.exe")
webshot("wordcloud.html", "wordcloud.png", vwidth = 1920, vheight = 1080, delay = 10)

save.image('analyze.RData')

