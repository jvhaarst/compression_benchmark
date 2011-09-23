library(ggplot2)
source("http://egret.psychol.cam.ac.uk/statistics/R/extensions/rnc_ggplot2_border_themes.r") # http://egret.psychol.cam.ac.uk/statistics/R/graphs2.html
# Read data
data <- read.csv(file="compressieResults_454Img.csv",header=TRUE)
# add percentage data
data$Percentage.of.original.size <- data$Compressed.size/data$Uncompressed.size
# Send output to png
#png(filename="compressieResults_454Img.png", bg="white", width=1024, height=768)
# Send output to pdf
pdf(file="compressieResults_454Img.pdf", bg="white", width=11, height=8,paper="a4r")
# Plot the compression data
se <- 	ggplot(data, aes(x=Wall.clock.time, y=Percentage.of.original.size,geom = "point", group=Type, shape=Type) ) +
	geom_point(color = "blue", size = 8) +
	#scale_x_log10() +
	geom_point(data = data, mapping = aes (x=Wall.clock.time.1, y=Percentage.of.original.size, group=Type, shape=Type),color = "red", size = 8) +
	scale_x_log10() +
	theme_bw() +
        labs(x = "log duration (seconds)", y = "rate of compression", colour = "Displacement") +
	opts(
		title = "454 Images Compression benchmark\n blue = compression, red = decompression",
		panel.grid.major = theme_blank(),
		panel.grid.minor = theme_blank(),
		panel.background = theme_blank(),
		panel.border = theme_border(c("left","bottom")), # RNC hack, see above
		legend.position = c(0.8,0.3),
		legend.title = theme_blank(),
		legend.text = theme_text(size=12),
		legend.key.size = unit(1.5, "lines"),
		legend.key = theme_blank()
        )+
        scale_shape(solid = FALSE)+        
	scale_shape_manual(value=c(0:6,8,9))
	#+
	#levels(data$Type) <- c("bzip2, "gz, "xz, "7zip-lzma, "7zip-lzma2, "zip-deflate, "tamp, "lzop")
        #scale_colour_brewer(palette="Paired") #  RColorBrewer::display.brewer.all(n=8, exact.n=FALSE)
print(se)
summary(se)


