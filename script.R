library(tidyverse)
library(ggthemes)

# Get files to load
file_list <- list.files(path = "./data/")

# Set which ERCOT bus we'll be using for the graph, I'm using the first one listed for simplicity
bus <- "RTW_345E_EB"

# Initialize empty df
df <- data.frame()

# Load in data
for ( i in 1:length(file_list)){
  temp <- read.csv(file = paste0('./data/',file_list[i]))
  # Filter to just get the bus we're using
  temp <- temp%>%
    filter(BusName == bus)
  date_time = as.POSIXct(paste(temp$DeliveryDate,temp$HourEnding), format = "%m/%d/%Y %H:%M")
  temp <- cbind(temp,date_time)
  temp <- temp%>%
    select(date_time, LMP)
  df <- rbind(df,temp)
}

p <- ggplot(data = df, aes(x=date_time,y=LMP))+
  geom_line()+
  xlab("")+
  ylab("Locational Marginal Price")+
  theme_wsj()
p
