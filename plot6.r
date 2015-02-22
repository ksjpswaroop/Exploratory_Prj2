#prj 2
#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

png("plot6.png")

#Load Packages
library(plyr)
library(dplyr)

#Greping require data from SCC datasets
motordata <-SCC[which(SCC$EI.Sector ==  "Mobile - On-Road Diesel Heavy Duty Vehicles" |       
                          SCC$EI.Sector ==  "Mobile - On-Road Diesel Light Duty Vehicles" |       
                          SCC$EI.Sector ==  "Mobile - On-Road Gasoline Heavy Duty Vehicles" |     
                          SCC$EI.Sector ==  "Mobile - On-Road Gasoline Light Duty Vehicles"),]

#extract data of baltimore, and los angeles from NEI datasets
baltimore <- NEI[which(NEI$fips == "24510"),]
losangeles <- NEI[which(NEI$fips =="06037"),]

#merging baltimore data with grepped data from SCC datasets
final.b <- merge(motordata,baltimore,by.x = "SCC",by.y = "SCC")

#merging losangeles data with grepped data from SCC datasets
final.la <- merge(motordata,losangeles,by.x = "SCC",by.y = "SCC")

#combined both the datasets
combinedata <- rbind(final.b,final.la)

#replacin column value of fips in final baltimore data
combinedata$fips <- mapvalues(combinedata$fips, from = c("24510","06037"), 
                          to = c("Baltimore","Los Angeles"))

#final datasets with grouping and summarizing, in order to create plot
combinedata.g <- ddply(combinedata, .(year, EI.Sector,fips), summarize, total.emissions = sum(Emissions) )

#Changing column names and replacing column value
colnames(combinedata.g)[2] <- "Vehicles"
combinedata.g$Vehicles <- mapvalues(combinedata.g$Vehicles, from = c( "Mobile - On-Road Diesel Heavy Duty Vehicles", 
                                                          "Mobile - On-Road Diesel Light Duty Vehicles",       
                                                          "Mobile - On-Road Gasoline Heavy Duty Vehicles",     
                                                          "Mobile - On-Road Gasoline Light Duty Vehicles"), 
                              to = c("Heavy.Diesel","Light.Diesel","Heavy.Gasoline","Light.Gasoline"))
#converting fips column into factor
combinedata.g$fips <- as.factor(combinedata.g$fips)
#loading graphics library
library(ggplot2)
#Plotting data on plot
ggploting <- ggplot(combinedata.g, aes(year, total.emissions, color = Vehicles) )
ggploting <- ggploting + geom_line() + xlab("Year") + ylab("Total Emissions") + facet_grid(. ~ fips)   
ggploting
dev.off()

#done