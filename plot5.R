url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "Project2.zip", method="curl")
unzip("Project2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#this will take some time, be patient...
NEI_SCC <- merge(NEI, SCC, by="SCC")

Baltimore <- data.frame(NEI_SCC[NEI_SCC$fips == 24510,]) 
filter <- grep('vehicles', Baltimore$Short.Name, ignore.case = TRUE)
Baltimore_filter <- Baltimore[filter, c("year", "Emissions")]

library(dplyr)
mydata <- summarize(group_by(Baltimore_filter, year), sum(Emissions))
names(mydata) <- c("year", "Emissions")
DF <- data.frame(year=as.numeric(mydata$year), 
                 Emissions = round((as.numeric(mydata$Emissions)), digits=0))

library(ggplot2)
plot5 <-  ggplot(DF, aes(year, Emissions))
plot5 + geom_line(col="red") + 
        labs(title="Emissions from motor vehicle sources in Baltimore City") +
        ylab("Emissions in tons")

dev.copy(png, file = 'plot5.png', width=480, height=480)
dev.off()


