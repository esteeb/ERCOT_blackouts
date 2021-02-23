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
  # Concatenate date and hour columns & convert to POSIX format
  date_time = as.POSIXct(paste(temp$DeliveryDate,temp$HourEnding), format = "%m/%d/%Y %H:%M")
  # Add in new column
  temp <- cbind(temp,date_time)
  # Drop extraneous columns
  temp <- temp%>%
    select(date_time, LMP)
  # Combine
  df <- rbind(df,temp)
}

# Create plot
p <- ggplot(data = df, aes(x=date_time,y=LMP))+
  geom_line()+
  xlab("")+
  ylab("Locational Marginal Price")+
  theme_wsj()+
  theme(axis.text = element_text(size=30))
p
