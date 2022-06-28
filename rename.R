## Rename files in bulk in a folder
library(pdftools)
library(dplyr)
folder = "CDSC_Data/"
files <- list.files(folder,pattern = "*.pdf",full.names = T)
files[7:73]
names(file) <- basename(files)
for (i in 1:length(files)){
  print(i)
  #if(i==104 | i==1) next
  head_data <- pdf_data(files[i])[[1]]$text[1:30]
  j = which(head_data == "Month" | head_data =="month")
  Year_data[i] = ifelse(head_data[j+3]==hyp,head_data[j+4],head_data[j+3])
  Month_data[i] = ifelse(is.null(head_data[j+2]),NA,head_data[j+2])
  #Year_data[i] = head_data[j+3]
  #Month_data[i] = head_data[j+2]
  #print(pdf_data(files[i])[[1]]$text[1:15])
}
Year_data[1] <- 2021
Year_data[104] <- 2021

data1 <- pdf_data(files[104])
data1[[1]]$text[1:30]
basename(files)
