#prj 2
#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

png("plot2.png")

#Load Packages
library(dplyr)
#Convert data in tabular compact form
tabular <- tbl_df(NEI)

#extract data of baltimore
baltimore <- tabular[which(tabular$fips == "24510"),]

#Create grouping of data basis on year
baltimore.g <- group_by(baltimore, year)

#Summarize data on total emission versus year
Total.Emissions <- summarize(baltimore.g, TotalEmission = sum(Emissions))

#Plotting required condition
plot(Total.Emissions,type ="l")
dev.off()

