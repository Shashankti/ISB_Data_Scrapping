## Reading the PDFs
library(pdftools)
library(stringr)
library(data.table)
library(tabulizer)
## Read trial PDF

## Future goal is to utilise the tabulizer pakage
## extract all tables and then proceed with the work

trial_pdf <- "CDSC_Data/danov13.pdf"
out1 <- extract_tables(trial_pdf,output = "data.frame",header="TRUE")
df <- as.data.frame(out1)
out1

renames <- function(x){
  colnames(x) <- x[1,]
  x <- x[2:dim(x)[1],,drop=F]
  return(as.data.frame(x))
}
df21 <- lapply(out1,renames)
# df21 <- as.data.frame(df21)
df1 <- rbindlist(df21,use.names = FALSE)
typeof(df21)
length(df$X1)
df1


## Setting up a function to rename the files based on the date
