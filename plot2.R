url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "Project2.zip", method="curl")
unzip("Project2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

Baltimore <- data.frame(NEI[NEI$fips == 24510, c("Emissions", "year")]) 

library(dplyr)
mydata <- summarize(group_by(Baltimore, year), sum(Emissions))
names(mydata) <- c("year", "Emissions")
DF <- data.frame(year=as.numeric(mydata$year), 
                 Emissions = round((as.numeric(mydata$Emissions)), digits=0))

par(mar=c(4,4,2,2))
plot(DF$year, DF$Emissions, type='l', col = 'red', 
     main = "Total PM2.5 Emissions in Baltimore City", 
     xlab = "year", ylab = 'Emissions in tons')

dev.copy(png, file = 'plot2.png', width=480, height=480)
dev.off()