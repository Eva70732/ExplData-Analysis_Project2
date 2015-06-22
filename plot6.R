url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, "Project2.zip", method="curl")
unzip("Project2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#this will take some time, be patient...
NEI_SCC <- merge(NEI, SCC, by="SCC")

##Baltimore 
Baltimore <- data.frame(NEI_SCC[NEI_SCC$fips == 24510,]) 
filter_B <- grep('vehicles', Baltimore$Short.Name, ignore.case = TRUE)
Baltimore_filter <- Baltimore[filter_B, c("year", "Emissions")]

library(dplyr)
mydata_B <- summarize(group_by(Baltimore_filter, year), sum(Emissions))
names(mydata_B) <- c("year", "Emissions")
DF_B <- data.frame(year=as.numeric(mydata_B$year), 
                 Emissions = round((as.numeric(mydata_B$Emissions)), digits=0), 
                 city="Baltimore")

##Los Angeles
Los_Angeles <- data.frame(NEI_SCC[NEI_SCC$fips == "06037",]) 
filter_LA <- grep('vehicles', Los_Angeles$Short.Name, ignore.case = TRUE)
LA_filter <- Los_Angeles[filter_LA, c("year", "Emissions")]

library(dplyr)
mydata_LA <- summarize(group_by(LA_filter, year), sum(Emissions))
names(mydata_LA) <- c("year", "Emissions_LA")
DF_LA <- data.frame(year=as.numeric(mydata_LA$year), 
                   Emissions = round((as.numeric(mydata_LA$Emissions)), digits=0),
                   city="Los Angeles")

DF_Both <- rbind(DF_B, DF_LA)

library(ggplot2)
plot6 <- ggplot(DF_Both, aes(year, Emissions, col=city))
plot6 + geom_line() + labs(title="Emissions from motor vehicle sources in Baltimore City vs Los Angeles")

dev.copy(png, file = 'plot6.png', width=480, height=480)
dev.off()
