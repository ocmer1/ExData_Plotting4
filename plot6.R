#Research question: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions?

#If necessary, download and unzip the data
#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(url, destfile = "NEIdata.zip")
#unzip("NEIdata.zip")

library(reshape2)
library(ggplot2)

#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#merge emission file with classification codes
NEI <- merge(NEI, SCC, by = "SCC")

#subset Balitmore and LA motor vehicle emissions (using "on-road" as description in EI.Sector column)
balt_la <- subset(NEI, fips=="24510" | fips=="06037")
balt_la_motor <- subset(balt_la, grepl("On-Road", balt_la$EI.Sector))

#calculate sums and melt data to long format to facilitate further analysis
baltla_sums <- tapply(balt_la_motor$Emissions, list(balt_la_motor$fips, balt_la_motor$year), sum)
baltla_sums <- melt(baltla_sums)
baltla_sums$City <- ifelse(baltla_sums$Var1 == 6037, "LA", "Baltimore")
names(baltla_sums) <- c("fips", "year", "value", "City")

#calculate percentage differences of observations in the different years
la_ts <- ts(subset(baltla_sums, fips == 6037)$value, start = 1999, end = 2008, deltat = 3)
bm_ts <- ts(subset(baltla_sums, fips == 24510)$value, start = 1999, end = 2008, deltat = 3)
la_dif <- (la_ts / lag(la_ts, -1) - 1)*100
bm_dif <- (bm_ts / lag(bm_ts, -1) - 1)*100

#put results in new data frame and melt to long format to facilitate plotting
mydf <- data.frame(year = time(la_dif)[1:3], LA = la_dif[1:3], Baltimore = bm_dif[1:3])
mmydf <- melt(mydf, id = "year")

#plot to PNG file
png(filename = "plot6.png")
ggplot(data=mmydf, aes(x = as.factor(year), y = value, fill = variable)) + geom_col(position = "dodge") + labs(x = "Year", y = "Emissions 3-year percentage change", title= "LA & Baltimore motor vehicle PM2.5 emissions %-change") + scale_fill_discrete(name = "City") 
dev.off()