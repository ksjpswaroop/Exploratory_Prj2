#prj 2
#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

png("plot5.png")

#Load Packages
library(dplyr)

#Greping require data from SCC datasets
motordata <-SCC[which(SCC$EI.Sector ==  "Mobile - On-Road Diesel Heavy Duty Vehicles" |       
                      SCC$EI.Sector ==  "Mobile - On-Road Diesel Light Duty Vehicles" |       
                      SCC$EI.Sector ==  "Mobile - On-Road Gasoline Heavy Duty Vehicles" |     
                      SCC$EI.Sector ==  "Mobile - On-Road Gasoline Light Duty Vehicles"),]

#extract data of baltimore from NEI datasets
baltimore <- NEI[which(NEI$fips == "24510"),]

#matching dataframe
final <- merge(motordata,baltimore,by.x = "SCC",by.y = "SCC")

#final datasets with grouping and summarizing, in order to create plot
final.g <- ddply(final, .(year, EI.Sector), summarize, total.emissions = sum(Emissions) )

#Changing column names and replacing column value
colnames(final.g)[2] <- "Vehicles"
final.g$Vehicles <- mapvalues(final.g$Vehicles, from = c( "Mobile - On-Road Diesel Heavy Duty Vehicles", 
                                  "Mobile - On-Road Diesel Light Duty Vehicles",       
                                  "Mobile - On-Road Gasoline Heavy Duty Vehicles",     
                                  "Mobile - On-Road Gasoline Light Duty Vehicles"), 
                             to = c("Heavy.Diesel","Light.Diesel","Heavy.Gasoline","Light.Gasoline"))

#loading graphics library
library(ggplot2)
#Plotting data on plot
ggploting <- ggplot(final.g, aes(year, total.emissions, color = Vehicles) )
ggploting <- ggploting + geom_line() +xlab("Year") + ylab("Total Emissions")
ggploting
dev.off()

#Done