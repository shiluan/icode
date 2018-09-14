################################################
## 2017-05-19
## given a text file find frequent words
## of concepts or meaning
################################################


## https://www.r-bloggers.com/intro-to-text-analysis-with-r/

### get the data
data <- readLines("https://www.r-bloggers.com/wp-content/uploads/2016/01/vent.txt") # from: http://www.wvgazettemail.com/
df <- data.frame(data)
textdata <- df[df$data, ]

## remove punctuations
textdata = gsub("[[:punct:]]", "", textdata)
textdata = gsub("[[:digit:]]", "", textdata)
textdata = gsub("http\\w+", "", textdata)
textdata = gsub("[ \t]{2,}", "", textdata)
textdata = gsub("^\\s+|\\s+$", "", textdata)


# tolower words
try.error = function(x)
{
  y = NA
  try_error = tryCatch(tolower(x), error=function(e) e)
  if (!inherits(try_error, "error"))
    y = tolower(x)
  return(y)
}

textdata = sapply(textdata, try.error)
textdata = textdata[!is.na(textdata)]
names(textdata) = NULL

## split to words
avisos<- scan("anuncio.txt", what="character", sep="\n")
avisos1 <- tolower(avisos)
avisos2 <- strsplit(avisos1, "\\W")
avisos3 <- unlist(avisos2)
freq<-table(avisos3)
freq1<-sort(freq, decreasing=TRUE)
## temple.sorted.table<-paste(names(freq1), freq1, sep="\\t")
## cat("Word\tFREQ", temple.sorted.table, file="anuncio.txt", sep="\n")



my.word2 <- unlist(my.word)
my.sorted <- sort(table(my.word2), decreasing=TRUE)
barplot(head(my.sorted, 50))

# bar plot word frequence 
counts <- table(mtcars$gear)
barplot(counts, main="Car Distribution", 
  	xlab="Number of Gears")
	