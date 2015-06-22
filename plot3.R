url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "Project2.zip", method="curl")
unzip("Project2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

Baltimore <- data.frame(NEI[NEI$fips == 24510, c("Emissions","type", "year")]) 

library(dplyr)
mydata <- summarize(group_by(Baltimore, type, year), sum(Emissions))
names(mydata) <- c("type", "year", "Emissions")
mydata_upd <- data.frame(type=as.character(mydata$type), year=as.numeric(mydata$year), 
                 Emissions = round((as.numeric(mydata$Emissions)), digits=0))

library(ggplot2)
plot3 <-  ggplot(mydata_upd, aes(year, Emissions, color=type))
plot3 + geom_line() + 
        labs(title="Emissions PM2.5 in Baltimore City by Source type")
        
dev.copy(png, file = 'plot3.png', width=480, height=480)
dev.off()