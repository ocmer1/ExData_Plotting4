#Research question: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008? Use the base plotting system to make a plot answering this question.

#If necessary, download and unzip the data
#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(url, destfile = "NEIdata.zip")
#unzip("NEIdata.zip")

#read the data
NEI <- readRDS("summarySCC_PM25.rds")

#subset Baltimore data and calculate sums
balt <- subset(NEI, fips==24510)
sums_balt <- tapply(balt$Emissions, balt$year, sum)

#plot to PNG file
png(filename = "plot2.png")
plot(names(sums_balt), sums_balt, type="b", pch=19, xlab="Year", ylab = "Emissions (tons)", main = "Total Baltimore PM2.5 Emissions", xaxt="n", yaxt="n", ylim = c(1700, 3400))
axis(1, at = seq(1999, 2008, by = 1), las = 2)
axis(2, at = seq(1800, 3400, by = 200), las=2)
dev.off()