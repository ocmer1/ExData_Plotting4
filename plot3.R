#Research question: Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

#If necessary, download and unzip the data
#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(url, destfile = "NEIdata.zip")
#unzip("NEIdata.zip")

library(reshape2)
library(ggplot2)

#read the data
NEI <- readRDS("summarySCC_PM25.rds")

#subset Baltimore and calculate sums by emission type
balt <- subset(NEI, fips=="24510")
balt_type_sums <- tapply(balt$Emissions, list(balt$type, balt$year), sum)

#melt to long format to facilitate plotting
balt_type_sums <- melt(balt_type_sums)
names(balt_type_sums) <- c("type", "year", "Emission")

#plot to PNG file
png(filename = "plot3.png")
ggplot(data=balt_type_sums, aes(x = year, y = Emission, group = type, color = type)) + geom_line() + geom_point() + labs(x = "Year", y = "Emissions (tons)", title = "Baltimore PM2.5 emission by type") + scale_color_discrete(name="Type", breaks = c("NONPOINT", "POINT", "NON-ROAD", "ON-ROAD"), labels = c("Non point", "Point", "Non road", "On road"))
dev.off()