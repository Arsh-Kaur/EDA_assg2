#######################################################################
## Download the data file given for the assignment and unzip the file
##Emissions from motor vehicle sources in Baltimore City with Los Angeles County, California (fips == "06037"). 
#######################################################################

## Read The RDS files into the R memory

file1<- "summarySCC_PM25.rds"
file2<- "Source_Classification_Code.rds"
neidata <- readRDS(file1)
sccdata <- readRDS(file2)

## Convert the files into Data Table format##
## Data Table is easy to subset
library(data.table)
setDT(neidata)
setDT(sccdata)

## Load library for ggplot function
library(ggplot2)

##Subset the data set
##I considered ON-ROAD as a measure for the vehicle emission
##fips== 24510 subsets data for Baltimore City
##fips== 06037 subsets data for Los Angeles
fip<-c("24510","06037")
plotdata <- neidata[(fips %in% fip) & (type == "ON-ROAD") ,  .(totalEmissions =sum(Emissions)), by = .(fips,year)]
plotdata$year <- factor(plotdata$year, levels=c('1999', '2002', '2005', '2008'))


plotdata[fips=="24510",1]<-"Baltimore"
plotdata[fips=="06037",1]<-"Los Angeles"
plotdata[order(fips,year)]->plotdata

## Using ggplot package, construct the barplot
p<-ggplot(data = plotdata, aes( x = year, y = totalEmissions, fill = year))+facet_grid(.~fips)  + geom_bar(stat = "identity") 
q<-p+ggtitle("Total Motor Vehicle Emissions")+theme(plot.title = element_text(hjust = 0.5))
yval<-round(plotdata$totalEmissions)
r<-q+ geom_text(aes(label=yval), vjust=-0.25)
r

# Copy the plot to the png file 
dev.copy(png, file="plot6.png", height=480, width=480)
dev.off()
