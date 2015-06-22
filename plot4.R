url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "Project2.zip", method="curl")
unzip("Project2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#this will take some time, be patient...
NEI_SCC <- merge(NEI, SCC, by="SCC")
filter <- grep('coal', NEI_SCC$Short.Name, ignore.case = TRUE)
NEI_filter <- NEI_SCC[filter, c("year", "Emissions")]

library(dplyr)
mydata <- summarize(group_by(NEI_filter, year), sum(Emissions))
names(mydata) <- c("year", "Emissions")
DF <- data.frame(year=as.numeric(mydata$year), 
                 kEmissions = round((as.numeric(mydata$Emissions)/1000), digits=0))

library(ggplot2)
plot4 <-  ggplot(DF, aes(year, kEmissions))
plot4 + geom_line(col="red") + 
        labs(title="Total Emissions from coal sources") +
        ylab("Emissions in Ktons")

dev.copy(png, file = 'plot4.png', width=480, height=480)
dev.off()
