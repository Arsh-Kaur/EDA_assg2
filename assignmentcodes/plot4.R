########################################################################################
## Download the data file given for the assignment and unzip the file                 ##
## Emissions from coal combustion-related sources in  United States from 1999–2008    ##
########################################################################################

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

##Get the row numbers which contain values for the coa-combustion related sources
##This is read from the sccdata file which contains information about the SCC numbers

grep("[C|c]oal",sccdata$Short.Name)->scc.no
sccdata[scc.no,1]->SCCreqd

##Subset the data set
data1 <- neidata[(SCC %in% SCCreqd$SCC),.(totalEmissions =sum(Emissions)), by = .(year)]

##Convert years to factors 
data1$year <- factor(data1$year, levels=c('1999', '2002', '2005', '2008')) 
yvalue = data1$totalEmissions/1000

## Using ggplot package, construct the barplot
p<-ggplot(data1,aes(x=year,y=yvalue,fill=year))+ geom_bar(stat = "identity")
q<-p+ggtitle(" Total Coal Emissions in US")+theme(plot.title = element_text(hjust = 0.5))
yval<-round(yvalue,3)
r<-q+ geom_text(aes(label=yval), vjust=-0.25)+ylab("Total Emissions(in Thousands)")
r

## Copy the plot to the png file 
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
