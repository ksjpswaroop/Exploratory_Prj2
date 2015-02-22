#prj 2
#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

png("plot3.png")

#extract data of baltimore
baltimore <- NEI[which(NEI$fips == "24510"),]

#Create grouping of data basis on year and type
baltimore.g <- group_by(baltimore, year,type)


#Summarize data on total emission versus year
Total.Emissions <- summarize(baltimore.g, TotalEmission = sum(Emissions))


#Use ggplot method
library(ggplot2)
ggploting <- ggplot(Total.Emissions, aes(year, TotalEmission, color = type) )
ggploting <- ggploting + geom_line()
ggploting
dev.off()

#done
