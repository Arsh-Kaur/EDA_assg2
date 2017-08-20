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
plot1data <- neidata[, .(totalEmissions =sum(Emissions)), by = .(year)]
ylab <- expression('Total PM'[2.5]*' Emissions in kilo tons')
main <- expression('U.S. Total yearwise PM'[2.5]*' Emissions in kilo tons')
yvalue = plot1data$totalEmissions/1000

## Using base package, construct the barplot
myplot <- barplot(height = yvalue, space = .8 , names = plot1data$year, xlab = "Year",
                 ylab = ylab, ylim = c(0,8000), main= main)
                 
## Add text at the top of the barplot
text(x =myplot,y = yvalue ,label = round(yvalue,2),pos = 3,cex = .7,col = "black")

## Copy the plot to the png file 
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()
