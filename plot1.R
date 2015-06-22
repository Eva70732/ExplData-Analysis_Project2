url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "Project2.zip", method="curl")
unzip("Project2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
mydata <- summarize(group_by(NEI, year), sum(Emissions))
names(mydata) <- c("year", "Emissions")
DF <- data.frame(year=as.numeric(mydata$year), 
                 kEmissions = round((as.numeric(mydata$Emissions)/1000), digits=0))

par(mar=c(4,4,2,2))
plot(DF$year, DF$kEmissions, type='l', col = 'red', 
     main = "Total PM2.5 Emissions by year", 
     xlab = "year", ylab = 'Emissions in Ktons')

dev.copy(png, file = 'plot1.png', width=480, height=480)
dev.off()