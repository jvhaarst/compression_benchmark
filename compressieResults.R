library(ggplot2)
source("http://egret.psychol.cam.ac.uk/statistics/R/extensions/rnc_ggplot2_border_themes.r") # http://egret.psychol.cam.ac.uk/statistics/R/graphs2.html
# Read data
data <- read.csv(file="compressieResults.csv",header=TRUE)
# Send output to png
png(filename="compressieResults.png", bg="white", width=1024, height=768)
# Send output to pdf
#pdf(file="compressieResults.pdf", bg="white", width=11, height=8,paper="a4r")
# Plot the compression data
se <- 	ggplot(data, aes(x=Wall.clock.time, y=Percentage.of.original.size,geom = "point", group=Type, color=Type) ) +
	geom_point(shape = 3, size = 8) +
	scale_x_log10() +
	geom_point(data = data, mapping = aes (x=Wall.clock.time.1, y=Percentage.of.original.size, group=Type, color=Type),shape = 4, size = 8) +
	scale_x_log10() +
	theme_bw() +
        labs(x = "log duration (seconds)", y = "rate of compression", colour = "Displacement") +
	opts(
		title = "Compression benchmark\n + = compression, x = decompression",
		panel.grid.major = theme_blank(),
		panel.grid.minor = theme_blank(),
		panel.background = theme_blank(),
		panel.border = theme_border(c("left","bottom")), # RNC hack, see above
		legend.position = c(0.8,0.2),
		legend.title = theme_blank(),
		legend.text = theme_text(size=12),
		legend.key.size = unit(1.5, "lines"),
		legend.key = theme_blank()
        )+
        scale_colour_brewer(palette="Paired") #  RColorBrewer::display.brewer.all(n=8, exact.n=FALSE)
print(se)
summary(se)


