#Research question: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

#If necessary, download and unzip the data
#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(url, destfile = "NEIdata.zip")
#unzip("NEIdata.zip")

#read the data
NEI <- readRDS("summarySCC_PM25.rds")

#calculate sums
sums <- tapply(NEI$Emissions, NEI$year, sum)

#plot to PNG file
png(filename = "plot1.png")
plot(names(sums), sums/1000000, type="b", pch=19, xlab = "Year", ylab = "Emissions (million tons)", main = "Total US PM2.5 emission", xaxt="n", ylim= c(3,8))
axis(1, at = seq(1999, 2008, by = 1), las = 2)
dev.off()