#prj 2
#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

png("plot1.png")

#Load Packages
library(dplyr)
#Convert data in tabular compact form
group <- tbl_df(NEI)

#Create grouping of data basis on year
group <- group_by(group, year)

#Summarize data on total emission versus year
Total.Emissions <- summarize(group, TotalEmission = sum(Emissions))

#Plotting required condition
plot(Total.Emissions,type ="l")
dev.off()
