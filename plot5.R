#Research question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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

#subset Baltimore and motor verhicle emissions (using "on-road" as description in EI.Sector column)
balt_motor <- subset(NEI, fips=="24510" & grepl("On-Road", NEI$EI.Sector))

#differentiate between heavy duty and light duty vehicles and calculate sums
balt_motor[,21] <- ifelse(grepl("Light", balt_motor$EI.Sector), "light", "heavy")
names(balt_motor)[21] <- "vehicle"
balt_motor_sums <- tapply(balt_motor$Emissions, list(balt_motor$vehicle, balt_motor$year), sum)

#melt to long format to facilitate plotting
balt_motor_sums <- melt(balt_motor_sums)
names(balt_motor_sums) <- c("vehicle", "year", "emission")

#plot to PNG file
png(filename = "plot5.png")
ggplot(data=balt_motor_sums, aes(x = year, y = emission, group = vehicle, color = vehicle)) + geom_line() + geom_point() + labs(x = "Year", y = "Emissions (tons)", title = "Baltimore PM2.5 motor vehicle emission") + scale_color_discrete(name="Vehicle type", labels = c("Heavy duty", "Light duty"))
dev.off()