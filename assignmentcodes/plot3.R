##########################################################################
## Download the data file given for the assignment and unzip the file   ##
##  Emissions from 1999–2008 for Baltimore City From different sources  ##
##########################################################################
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
##fips== 24510 subsets data for Baltimore City
NEI_balti <- neidata[(fips == "24510"),.(totalEmissions =sum(Emissions)), by = .(year, type)]

##Convert years to factors because otherwise these will be taken as continuous variables
NEI_balti$year <- factor(NEI_balti$year, levels=c('1999', '2002', '2005', '2008')) 
plotdata<-NEI_balti
 
## Using ggplot package, construct the barplot

ggplot(data = plotdata, aes( x = year, y = totalEmissions, fill = year))+facet_grid(.~type)  + geom_bar(stat = "identity")+geom_line() 

## Copy the plot to the png file 
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
