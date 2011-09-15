#!/bin/bash

#lzop	: http://www.lzop.org/
#p7zip	: http://sourceforge.net/projects/p7zip/files/p7zip/
#pbzip2	: http://www.compression.ca/pbzip2/
#pigz	: http://www.zlib.net/pigz/
#pixz	: https://github.com/vasi/pixz (aptitude install  liblzma-dev libarchive-dev && make)
#tamp	: http://blogs.sun.com/timc/entry/tamp_a_lightweight_multi_threaded
#zip	: http://info-zip.org/

START=1
END=9
NAME=/home/jvh/nobackup/test.rawImages.tar		# 676ba83248fa50922408fa7243358667
#NAME=/home/jvh/effe/SRR001665.interleaved.fastq	# 8e0cefac38d14de0d816d02c5459c5fc
export TMPDIR=`pwd`

echo gz
for block in `seq 1 ${END}`
do
	echo "$block"
	/usr/bin/time --format "%e\t%S\t%U\t%P" pigz -${block} -k --suffix .${block}.gz ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.gz`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pigz -d -c ${NAME}.${block}.gz > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.gz
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.gz
done
echo bzip2
for block in `seq 1 ${END}`
do
	echo $block
	/usr/bin/time --format "%e\t%S\t%U\t%P" pbzip2 -${block} -k ${NAME} -c > ${NAME}.${block}.bz2
	FILE=`mktemp -u tmp.XXXXXXX.bz2`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pbzip2 -d -c ${NAME}.${block}.bz2 > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.bz2
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.bz2
done
echo xz
for block in `seq 1 ${END}`
do
	echo $block
	/usr/bin/time --format "%e\t%S\t%U\t%P" ~/code/pixz/pixz -t -${block} -i ${NAME} -o ${NAME}.${block}.xz
	FILE=`mktemp -u tmp.XXXXXXX.xz`
	/usr/bin/time --format "%e\t%S\t%U\t%P" ~/code/pixz/pixz -t -x -i ${NAME}.${block}.xz -o $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.xz
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.xz
done
echo 7zip-lzma
for block in `seq 1 ${END}`
do
	echo $block
	/usr/bin/time --format "%e\t%S\t%U\t%P" /home/jvh/bin/p7zip_9.20.1/bin/7zr a -bd -t7z -mmt=on -mx=${block} -m0=lzma ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.7z`
	/usr/bin/time --format "%e\t%S\t%U\t%P" /home/jvh/bin/p7zip_9.20.1/bin/7zr e -bd -so -mmt=on ${NAME}.${block}.7z  > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.7z
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.7z
done
echo 7zip-lzma2
for block in `seq 1 ${END}`
do
	echo $block
	/usr/bin/time --format "%e\t%S\t%U\t%P" /home/jvh/bin/p7zip_9.20.1/bin/7zr a -bd -t7z -mmt=on -mx=${block} -m0=lzma2 ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.7z2`
	/usr/bin/time --format "%e\t%S\t%U\t%P" /home/jvh/bin/p7zip_9.20.1/bin/7zr e -bd -so -mmt=on ${NAME}.${block}.7z  > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.7z
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.7z
done
echo zip-deflate
for block in `seq 1 ${END}`
do
	echo $block
	/usr/bin/time --format "%e\t%S\t%U\t%P" zip -${block} --quiet ${NAME}.${block}.zip ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.zip`
	/usr/bin/time --format "%e\t%S\t%U\t%P" unzip -p ${NAME}.${block}.zip > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.zip
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.zip
done
echo tamp
for block in 1
do
	echo $block
	/usr/bin/time --format "%e\t%S\t%U\t%P" /home/jvh/code/tamp/tamp-2.5/tamp -i ${NAME} -o ${NAME}.${block}.q
	FILE=`mktemp -u tmp.XXXXXXX.tamp`
	/usr/bin/time --format "%e\t%S\t%U\t%P" /home/jvh/code/tamp/tamp-2.5/tamp -d -i ${NAME}.${block}.q -o $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.q
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.q
done
echo lzop
for block in `seq 1 ${END}`
do
	echo "$block"
	/usr/bin/time --format "%e\t%S\t%U\t%P" lzop -${block} -k -c ${NAME} > ${NAME}.${block}.lz
	FILE=`mktemp -u tmp.XXXXXXX.lzop`
	/usr/bin/time --format "%e\t%S\t%U\t%P" lzop -d -c ${NAME}.${block}.lz > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.lz
	echo
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.lz
done
# Time format used:
# e      Elapsed real (wall clock) time used by the process, in seconds.
# S      Total number of CPU-seconds used by the system on behalf of the process (in kernel mode), in seconds.
# U      Total number of CPU-seconds that the process used directly (in user mode), in seconds.
# P      Percentage of the CPU that this job got.  This is just user + system times divided by the total running time. It also prints a percentage sign.

# Creating graphs
# First edit the output to:
#cat compress.fastq.out | sed ':a;N;$!ba;s/%\n/ /g' | perl -e 'while(<>){if ($_ =~ /^(\d)$/){chomp;print $_." ";}else{print $_;}}' | perl -p -e 's/^8e0cefac38d14de0d816d02c5459c5fc\n//'
#type,in time,out time,ratio
#gz_1,161.48,229.02,61.0
#
# In R:
#c <- read.csv(file="compress.out.data",sep=",",head=TRUE)
#plot(c$out.time,c$ratio)
#pointLabel(c$out.time,c$ratio,labels=c$"type",method="GA")
#plot(c$ratio,c$in.time)
#pointLabel(c$ratio,c$in.time,labels=c$"type",method="GA")
#colorlabel
#http://r.789695.n4.nabble.com/color-code-from-csv-td864993.html
#type,setting,in,out
#color, number, italic, nonitalic