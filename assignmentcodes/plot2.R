#######################################################################
## Download the data file given for the assignment and unzip the file##
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

##Subset the data set
plot2data <- neidata[(fips == "24510") ,  .(totalEmissions =sum(Emissions)), by = .(year)]


clp <- colorRampPalette(c("Yellow","red"))
ylab <- expression('Total PM'[2.5]*' Emissions in kilo tons')
main <- expression('Baltimore Total yearwise PM'[2.5]*' Emissions in kilo tons')
yvalue = plot2data$totalEmissions/1000

## Using base package, construct the barplot
myplot <- barplot(height = yvalue, space = .8, names = plot2data$year, xlab = "Year"
                 , col = clp(4), ylab = ylab, ylim = c(0,4), main= main)
                 
## Add text at the top of the barplot
text(x =myplot,y = yvalue ,pos=3,label = round(yvalue,2),cex = .8,col = "black")

## Copy the plot to the png file 
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()
