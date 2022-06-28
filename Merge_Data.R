#' Script to merge the xls dataframes
#'
#'

library(data.table)
#library(xlsx)
#library(readxl)
library(plyr)
library(tidyverse)
library(stringr)
library(mltools)

setwd("CDSC_Data/ExtractedTables/")

#' Convert xlxs to csv
files.to.read = list.files(pattern = "xlsx")

#' Read the files and comvert
lapply(files.to.read,function(f){
  df = read_excel(f,sheet = 1)
  write.csv(df,gsub("xlsx","csv",f),row.names = FALSE)
})




data.files = list.files(pattern = ".csv")
# Read the csv files
read_files <- function(z){
  dat <- fread(z)
}
data_list <- lapply(data.files,read_files)
#Add coulumn for dates
for( i in 1:length(data.files)){
  data_list[[i]]$ID <- rep(tools::file_path_sans_ext(basename(data.files))[i],length(data_list[[i]]$`Sr. No.`))
}

# Clean columns
for (i in 1:length(data_list)){
  if(length(names(data_list[[i]]))>7){
    print(i)
  }
}


## Merge the list
combined_df <- rbindlist(data_list,fill = TRUE)
combined_df$...7 <- NULL
combined_df$...8 <- NULL
combined_df$...9 <- NULL
combined_df$`Name of Drugs/ Cosmetics...1` <- NULL
combined_df <- combined_df %>% mutate(Names=coalesce(`Name of Drugs/ Cosmetics`,`Name of Drugs/ Cosmetics...2`),
                                      Details = coalesce(`Batch No./ Date of Manufacture/ Date of Expiry/ Manufactured By`,`Name of Drugs/ Cosmetics...3`),
                                      DrawnBy = coalesce(`Drawn By`,`Declared by`),
                                      DrawnFrom=coalesce(`Drawn From`,`Received From`)) %>%
  select(`Sr. No.`,Names,Details,`Reason for Failure`,DrawnBy,DrawnFrom,ID)
combined_df$Details <- combined_df$`Batch No./ Date of Manufacture/ Date of Expiry/ Manufactured By`

## Remove extra characters
combined_df$Details <- gsub("[\r\n]","",combined_df$Details)
combined_df$Names <- gsub("[\r\n]","",combined_df$Names)
combined_df$`Reason for Failure` <- gsub("[\r\n]","",combined_df$`Reason for Failure`)
combined_df$DrawnBy <- gsub("[\r\n]","",combined_df$DrawnBy)
combined_df$DrawnFrom <- gsub("[\r\n]","",combined_df$DrawnFrom)
combined_df$ID <- gsub("_"," ", combined_df$ID)
for(i in 1:length(combined_df$ID)){
  combined_df$Month[i] <- strsplit(combined_df$ID[i],split = " ")[[1]][1]
  combined_df$Year[i] <- strsplit(combined_df$ID[i],split = " ")[[1]][2]
}
combined_df$`Sr. No.` <- NULL
#Set col names
names(combined_df)

##Fixing broken NA values
combined_df$ID[532:545] <- " December 2020"
combined_df$ID[737:769] <- "February 2020"
combined_df$ID[935:965] <- "January 2020"
combined_df$ID[1630:1670] <- "March 2020"
combined_df$ID[1995:2028] <- "November 2019"
combined_df$ID[2029:2042] <- "November 2020"
# ###
# combined_df$`Batch No./ Date of Manufacture/ Date of Expiry/ Manufactured By`[11:27] <- data_list[[3]]$`Name of Drugs/ Cosmetics...3`
# combined_df$`Batch No./ Date of Manufacture/ Date of Expiry/ Manufactured By`[1902:1909] <- data_list[[85]]$`Name of Drugs/ Cosmetics...3`
# combined_df$`Batch No./ Date of Manufacture/ Date of Expiry/ Manufactured By`[1269:1309] <- data_list[[58]]$`Name of Drugs/ Cosmetics...3`

# Save output as csv file
write.csv(combined_df,"Combined_List.csv")


## Edit the second column
# Add batch number
for( i in 1:length(combined_df$Names)){
  combined_df$Batch_Number[i] <- strsplit(combined_df$Details[i],split = "Mfg")[[1]][1]
}


# Add mfg date
a = 0
Dates <- str_extract_all(combined_df$Details, "[0-9]{2}/[0-9]{4}")
for(i in 1:length(Dates)){
  if(length(Dates[[i]])==2){
     combined_df$Mfg_Date[i] <- Dates[[i]][1]
     combined_df$Exp_Date[i] <- Dates[[i]][2]
    print(i)
    #a = a+1
  } else if (length(Dates[[i]])>2){
    if(Dates[[i]][1]==Dates[[i]][3]){
      combined_df$Mfg_Date[i] <- Dates[[i]][1]
      combined_df$Exp_Date[i] <- Dates[[i]][2]
    } else {
      combined_df$Mfg_Date[i] <- Dates[[i]][1]
      combined_df$Exp_Date[i] <- Dates[[i]][3]
    }
  }
}

for(i in 1:length(Dates)){
  if(is_empty(Dates[[i]])){
    print(list(combined_df$Details[i],Dates[[i]]))
    #a = a+1
  }
}

for(i in 1:length(Dates2)){
  if(!is_empty(Dates2[[i]])){
    print(list(combined_df$Details[i],Dates[[i]]))
    #a = a+1
  }
}
l1 <- c("Jan","Feb","Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct","Nov", "Dec")
Dates2 <- str_extract_all(combined_df$Details, "[mont.abb], [0-9]{4}")

# Add exp Date

#Test1 = combined_df%>%group_by(Names)

# encoding the name and reason columns
combined_df <- as.data.table(combined_df)
combined_df$Names.encoded <- tolower(combined_df$Names)
combined_df$Names.encoded <- as.factor(combined_df$Names.encoded)
combined_df$Names.encoded <- mltools::one_hot(combined_df$Names.encoded)
combined_df$Reason.encoded <- tolower(combined_df$`Reason for Failure`)
combined_df$Reason.encoded <- as.factor(combined_df$Reason.encoded)
combined_df$Reason.encoded <- mltools::one_hot(combined_df$Reason.encoded)


# Read NDc data
combined_df <- fread("Combined_List_wmfg.csv",header = TRUE)
ref <- fread("product.csv")

val <- grep(pattern = ref$propname[3545],x = combined_df$Names,value = TRUE)

write.csv(combined_df,"Combined_List_wmfg.csv")


