#!/usr/bin/Rscript
# Read arguments from commandline
args=(commandArgs(TRUE))
input=args[1]
output=args[2]
type=args[3]
require(grid)
library(ggplot2) # if missing, install with : install.packages("ggplot2")
# Read data
data <- read.table(file=input,sep='\t',header=TRUE)
# add percentage data
data$Percentage.of.original.size <- data$Compressed.size/data$Uncompressed.size

if (type == "png"){
	# Send output to png
	png(filename=output, bg="white", width=1920, height=1080)
} else {
	# Send output to pdf
	pdf(file=output, bg="white", width=11, height=8,paper="a4r")
}
# Plot the compression data
se <- 	ggplot(data, aes(x=Wall.clock.time, y=Percentage.of.original.size,geom = "point", group=Type, shape=Type) ) +
	geom_point(color = "blue", size = 8) +
	#scale_x_log10() +
	geom_point(data = data, mapping = aes (x=Wall.clock.time.1, y=Percentage.of.original.size, group=Type, shape=Type),color = "red", size = 8) +
	scale_x_log10() +
	theme_bw() +
        labs(x = "log duration (seconds)", y = "rate of compression", colour = "Displacement") +
	labs(title = "Parallel compression benchmark\n blue = compression, red = decompression") +
	theme(
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		panel.background = element_blank(),
		legend.position = c(0.9,0.8),
		legend.title = element_blank(),
		legend.text = element_text(size=12),
		legend.key.size = unit(1.5, "lines"),
		legend.key = element_blank()
        )+
        scale_shape(solid = FALSE)+
	scale_shape_manual(values=c(0:10,12:14))+
  geom_text(
        aes(
          hjust=-1,
          vjust=-1,
          size=10,
          label = Setting
          ))+
  geom_text(
        data = data,
        mapping = aes (
          x=Wall.clock.time.1,
          y=Percentage.of.original.size,
          hjust=-1,
          vjust=-1,
          size=10,
          label = Setting))
print(se)
summary(se)
