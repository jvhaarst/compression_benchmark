#!/bin/bash

#lzop	: http://www.lzop.org/
#p7zip	: http://sourceforge.net/projects/p7zip/files/p7zip/
#pbzip2	: http://www.compression.ca/pbzip2/
#pigz	: http://www.zlib.net/pigz/
#pixz	: https://github.com/vasi/pixz (aptitude install  liblzma-dev libarchive-dev && make)
#tamp	: http://blogs.sun.com/timc/entry/tamp_a_lightweight_multi_threaded
#zip	: http://info-zip.org/
# The script expects all programs to be in the PATH.
START=1
END=9
NAME=$1
export TMPDIR=`pwd`
# print header
echo ',,Compression,,,,Decompression,,,,,,,'
echo 'Type,Setting,Wall clock time,System time,User time,CPU,Wall clock time,System time,User time,CPU,Original size,Uncompressed size,Compressed size,Percentage of original size'

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
	/usr/bin/time --format "%e\t%S\t%U\t%P" pixz -t -${block} -i ${NAME} -o ${NAME}.${block}.xz
	FILE=`mktemp -u tmp.XXXXXXX.xz`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pixz -t -x -i ${NAME}.${block}.xz -o $FILE
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
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr a -bd -t7z -mmt=on -mx=${block} -m0=lzma ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.7z`
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr e -bd -so -mmt=on ${NAME}.${block}.7z  > $FILE
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
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr a -bd -t7z -mmt=on -mx=${block} -m0=lzma2 ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.7z2`
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr e -bd -so -mmt=on ${NAME}.${block}.7z  > $FILE
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
	/usr/bin/time --format "%e\t%S\t%U\t%P" tamp -i ${NAME} -o ${NAME}.${block}.q
	FILE=`mktemp -u tmp.XXXXXXX.tamp`
	/usr/bin/time --format "%e\t%S\t%U\t%P" tamp -d -i ${NAME}.${block}.q -o $FILE
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

# After this is finished do this on the output:
# sed -i -f filter.sed output.out
# grep -P -v '^\s*$' < output.out > output.out.cleaned


