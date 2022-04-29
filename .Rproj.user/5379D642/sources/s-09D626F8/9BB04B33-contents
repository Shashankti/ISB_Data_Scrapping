library(rvest)
library(tidyverse)
my_url <- read_html("https://cdsco.gov.in/opencms/opencms/en/Notifications/Alerts/")
pdfs <-  my_url %>% html_nodes("td") %>% html_nodes("a") %>% html_attr("href")
for (i in 1:length(pdfs)) {
  pdfs[i] <-paste0("https://cdsco.gov.in",pdfs[i])
  url2[i] <- read_html(pdfs[i])
}

download.file(noquote(pdfs[12]),path.expand("CDSC_Data/file1.pdf"))
full_links <- "https://cdsco.gov.in/opencms/opencms/en/Notifications/Alerts/" %>%
  read_html()                                           %>%
  html_nodes("td")                                      %>%
  html_nodes("a")                                       %>%
  html_attr("href")                                     %>%
  {paste0("https://cdsco.gov.in", .)}

setwd("CDSC_Data/")
for (i in 151:196) {
  s1 <- session(full_links[i])
  frame_link1 <- s1%>%read_html%>%html_nodes("iframe") %>%
    html_attr("src")%>%{paste0("https://cdsco.gov.in", .)}
  download.file(frame_link1,method = "curl",destfile = basename(frame_link1))
}


Search_links <- "https://cdsco.gov.in/opencms/opencms/en/Notifications/Alerts/" %>%
  read_html() %>%
  html_nodes("section") %>%
  .[[1]]
Search_links

paste0("https://cdsco.gov.in","/opencms/resources/UploadCDSCOWeb/2018/UploadAlertsFiles/Drug Alert Listfeb22.pdf")
download.file(noquote(paste0("https://cdsco.gov.in","/opencms/resources/UploadCDSCOWeb/2018/UploadAlertsFiles/Drug Alert Listfeb22.pdf")
),path.expand("CDSC_Data/file2.pdf"))
link <- paste0("https://cdsco.gov.in","/opencms/resources/UploadCDSCOWeb/2018/UploadAlertsFiles/Drug Alert Listfeb22.pdf")
download.file(link,"pdf.pdf",mode = "wb.")

############3

s1 <- session(full_links[12])
frame_link1 <- s1%>%read_html%>%html_nodes("iframe") %>%
  html_attr("src")%>%{paste0("https://cdsco.gov.in", .)}

frame_link1 <- s1 %>% read_html() %>% html_nodes(xpath="//frame[@name='iframe']")

s <- s %>%session_jump_to(url=frame_link)
temp_url <- s %>% read_html() %>%
  html_nodes("meta") %>%
  html_attr("content") %>% {gsub(".*URL=","",.)}
s <- s %>% session_jump_to(url=link)

s %>% session_jump_to(url=full_links[12]) %>%
  session_back()
pdf_link <- s %>% read_html() %>%
  html_nodes(xpath="//meta[@http-equiv='refresh']") %>%
  html_attr("content") %>% {gsub(".*URL=","",.)}
wget.download("https://cdsco.gov.in/opencms/resources/UploadCDSCOWeb/2018/UploadAlertsFiles/Drug Alert Listfeb22.pdf")
download.file(link,method = "wget",extra = "-r -p --random-wait")
