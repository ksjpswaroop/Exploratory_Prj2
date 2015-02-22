#prj 2
#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

png("plot4.png")

#Greping required data from SCC Datasets
coaldata <-SCC[which(SCC$EI.Sector ==  "Fuel Comb - Comm/Institutional - Coal" |              
                     SCC$EI.Sector ==  "Fuel Comb - Electric Generation - Coal" |     
                     SCC$EI.Sector ==  "Fuel Comb - Industrial Boilers, ICEs - Coal"),]

#merging data from Grepped datasets (coaldata) and original datasets of NEI with common colun SCC
final <- merge(coaldata,NEI,by.x = "SCC")

#Creating final datasets with grouping and Summarize(total emission versus year)
final.g <- ddply(final, .(year, EI.Sector), summarize, total.emissions = sum(Emissions) )

#Replacing columnnames and content of column(factor values)
colnames(final.g)[2]<- "Coal"
final.g$Coal <- mapvalues(final.g$Coal, from = c("Fuel Comb - Comm/Institutional - Coal",
                                 "Fuel Comb - Electric Generation - Coal",
                                 "Fuel Comb - Industrial Boilers, ICEs - Coal"),
                        to = c("Institutional", "Electric","Industrial"))

#Plotting begins
ggploting <- ggplot(final.g, aes(year, total.emissions, color = Coal) )
ggploting <- ggploting + geom_line() + xlab("Year") + ylab("Total Emissions")

#printing data
ggploting
dev.off()

#Done