library(httr)
library(rjson)

addresses <- read.csv(file.choose())
addresses$Street.address <- paste(as.character(addresses$Street.address),"USA")

geo.coder <- function(address){ # single address geocode with data sciences toolkit
  require(httr)
  require(rjson)
  url      <- "http://www.datasciencetoolkit.org/maps/api/geocode/json"
  response <- GET(url,query=list(sensor="FALSE",address=addr))
  json <- fromJSON(content(response,type="text",encoding = "UTF-8"))
  print(addr)
  loc  <- tryCatch(json['results'][[1]][[1]]$geometry$location,error=function(err) NA)
  ifelse(class(loc) == "list",return(c(addr=addr,long=loc$lng, lat= loc$lat)), return(c(addr=address,long=NA, lat= NA)))
}
result <- do.call(rbind,lapply(as.character(addresses$Street.address[1:nrow(addresses)]),geo.coder))

result15000 <- data.frame(result)
write.csv(result15000,"15000.csv")

