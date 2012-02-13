#!/bin/bash
#lzop	: http://www.lzop.org/
#p7zip	: http://sourceforge.net/projects/p7zip/files/p7zip/
#pbzip2	: http://www.compression.ca/pbzip2/
#pigz	: http://www.zlib.net/pigz/
#pixz	: https://github.com/vasi/pixz (aptitude install liblzma-dev libarchive-dev && make)
#tamp	: http://blogs.sun.com/timc/entry/tamp_a_lightweight_multi_threaded
#zip	: http://info-zip.org/

# Debugging
#set -o xtrace
#set -o verbose
# Safeguards
set -o nounset
set -o errexit

# The script expects all programs to be in the PATH.
START=1
END=32
NAME=$1
block=1
export TMPDIR=`pwd`
# print header
echo ',,Compression,,,,Decompression,,,,,,,'
echo 'Type,Setting,Wall clock time,System time,User time,CPU,Wall clock time,System time,User time,CPU,Original size,Uncompressed size,Compressed size,Percentage of original size'

for cpu in `seq 1 ${END}`
do
	echo -e gz"\t"$cpu"%"
	/usr/bin/time --format "%e\t%S\t%U\t%P" pigz --processes ${cpu} -${block} -k --suffix .${block}.gz ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.gz`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pigz --processes ${cpu} -d -c ${NAME}.${block}.gz > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.gz | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.gz
done
for cpu in `seq 1 ${END}`
do
	echo -e bzip2"\t"$cpu"%"
	/usr/bin/time --format "%e\t%S\t%U\t%P" pbzip2 -p${cpu} -${block} -k ${NAME} -c > ${NAME}.${block}.bz2
	FILE=`mktemp -u tmp.XXXXXXX.bz2`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pbzip2 -p${cpu} -d -c ${NAME}.${block}.bz2 > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.bz2 | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.bz2
done
