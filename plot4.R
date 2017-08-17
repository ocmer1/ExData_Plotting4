#Research question: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

#If necessary, download and unzip the data
#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(url, destfile = "NEIdata.zip")
#unzip("NEIdata.zip")

#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#merge emission file with classification codes
NEI <- merge(NEI, SCC, by = "SCC")

#subset coal combustion entries (using EI.Sector column) and calculate sums
coal <- subset(NEI, grepl("Coal|coal", NEI$EI.Sector))
sums_coal <- tapply(coal$Emissions, coal$year, sum)

#plot to PNG file
png(filename = "plot4.png")
plot(names(sums_coal), sums_coal/1000, type="b", pch=19, xlab="Year", ylab = "Emissions (thousands of tons)", main = "Total US coal combustion emissions", xaxt="n", yaxt="n", ylim = c(300,600))
axis(1, at = seq(1999, 2008, by = 1), las = 2)
axis(2, at = seq(300, 600, by = 50), las=2)
dev.off()