###########################################################################
## Download the data file given for the assignment and unzip the file    ##
## Emissions from motor vehicle sources from 1999–2008 in Baltimore City ##
###########################################################################

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
plotdata <- neidata[(fips == "24510") & (type == "ON-ROAD") ,  .(totalEmissions =sum(Emissions)), by = .(year)]
##Convert years to factors 
plotdata$year <- factor(plotdata$year, levels=c('1999', '2002', '2005', '2008'))

## Using ggplot package, construct the barplot
p<-ggplot(plotdata,aes(x=year,y=totalEmissions,fill=year))+ylim(0,400)+ geom_bar(stat = "identity")+geom_point()
q<-p+ggtitle("Baltimore Total Motor Vehicle Emissions")+theme(plot.title = element_text(hjust = 0.5))
yval<-round(plotdata$totalEmissions,3)
r<-q+ geom_text(aes(label=yval), vjust=-0.25)+ylab("Total Emissions")
r

## Copy the plot to the png file 
dev.copy(png, file="plot5.png")
dev.off()
