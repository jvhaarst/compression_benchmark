#!/bin/bash
#lzop	: http://www.lzop.org/
#p7zip	: http://sourceforge.net/projects/p7zip/files/p7zip/
#pbzip2	: http://www.compression.ca/pbzip2/
#pigz	: http://www.zlib.net/pigz/
#pixz	: https://github.com/vasi/pixz (aptitude install liblzma-dev libarchive-dev && make)
#tamp	: https://blogs.oracle.com/timc/entry/tamp_a_lightweight_multi_threaded
#zip	: http://info-zip.org/

# Debugging
#set -o xtrace
#set -o verbose
# Safeguards
set -o nounset
#set -o errexit

# The script expects all programs to be in the PATH.
END=9
NAME=$1
export TMPDIR=`pwd`
c=6
# print header
echo 'Type	Setting	Wall clock time	System time	User time	CPU	Wall clock time	System time	User time	CPU	Original size	Uncompressed size	Compressed size		md5sum'

# GZ
for block in `seq 0 ${END}` 11
do
	echo -e gz"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" pigz --processes ${THREADS} -${block} --keep --suffix .${block}.gz ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.gz`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pigz --processes ${THREADS} --decompress --stdout ${NAME}.${block}.gz > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.gz | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.gz
done

# BZIP2
for block in `seq 1 ${END}`
do
	echo -e bzip2"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" pbzip2 -p${THREADS} -${block} --keep ${NAME} --stdout > ${NAME}.${block}.bz2
	FILE=`mktemp -u tmp.XXXXXXX.bz2`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pbzip2 -p${THREADS} --decompress --stdout ${NAME}.${block}.bz2 > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.bz2 | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.bz2
done

# XZ
for block in `seq 0 ${END}`
do
	echo -e xz"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" pixz -p ${THREADS} -t -${block} -i ${NAME} -o ${NAME}.${block}.xz
	FILE=`mktemp -u tmp.XXXXXXX.xz`
	/usr/bin/time --format "%e\t%S\t%U\t%P" pixz -p ${THREADS} -t -x -i ${NAME}.${block}.xz -o $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.xz | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.xz
done

# 7zip-lzma2
for block in 0 1
do
	echo -e 7zip-lzma2"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr a -bd -t7z -mmt=${THREADS} -mx=${block} -m0=lzma2 ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.7z2`
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr e -bd -so -mmt=${THREADS} ${NAME}.${block}.7z  > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.7z | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.7z
done

# 7zip-PPMd
for block in `seq 2 32`
do
	echo -e 7zip-PPMd"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7z a -bd -t7z -mmt=${THREADS} -mo=${block} -m0=PPMd ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.ppmd`
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7z e -bd -so -mmt=${THREADS} ${NAME}.${block}.7z  > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.7z | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.7z
done

# zip-deflate
for block in `seq 0 ${END}`
do
	echo -e zip-deflate"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" zip -${block} --quiet ${NAME}.${block}.zip ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.zip`
	/usr/bin/time --format "%e\t%S\t%U\t%P" unzip -p ${NAME}.${block}.zip > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.zip | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.zip
done

# 7zip-lzma
for block in 0 1
do
	echo -e 7zip-lzma"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr a -bd -t7z -mmt=${THREADS} -mx=${block} -m0=lzma ${NAME}.${block}.7z ${NAME}
	FILE=`mktemp -u tmp.XXXXXXX.7z`
	/usr/bin/time --format "%e\t%S\t%U\t%P" 7zr e -bd -so -mmt=${THREADS} ${NAME}.${block}.7z  > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.7z | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.7z
done

# TAMP
for block in 1
do
	echo -e tamp"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" tamp -p ${THREADS} -m ${THREADS} -i ${NAME} -o ${NAME}.${block}.q
	FILE=`mktemp -u tmp.XXXXXXX.tamp`
	/usr/bin/time --format "%e\t%S\t%U\t%P" tamp -p ${THREADS} -m ${THREADS} -d -i ${NAME}.${block}.q -o $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.q | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.q
done

# LZOP
for block in `seq 1 ${END}`
do
	echo -e lzop"\t"$block'%'
	/usr/bin/time --format "%e\t%S\t%U\t%P" lzop -${block} -k -c ${NAME} > ${NAME}.${block}.lz
	FILE=`mktemp -u tmp.XXXXXXX.lzop`
	/usr/bin/time --format "%e\t%S\t%U\t%P" lzop -d -c ${NAME}.${block}.lz > $FILE
	stat --printf="%s\t" ${NAME} $FILE ${NAME}.${block}.lz | tr -d '\n'
	echo '%'
	md5sum $FILE | cut -f 1 -d' '
	rm $FILE
	rm ${NAME}.${block}.lz
done
# Time format used:
# e      Elapsed real (wall clock) time used by the process	 in seconds.
# S      Total number of CPU-seconds used by the system on behalf of the process (in kernel mode)	 in seconds.
# U      Total number of CPU-seconds that the process used directly (in user mode)	 in seconds.
# P      Percentage of the CPU that this job got.  This is just user + system times divided by the total running time. It also prints a percentage sign.

# After this is finished do this on the output:
# cat galaxy_20120210_150137.csv | grep -f matches.grep  | grep -v Pavlov | sed ':a;N;$!ba;s/%\n/%\t/g' > galaxy_20120210_150137.filtered.csv
# sed filter from http://stackoverflow.com/questions/1251999/sed-how-can-i-replace-a-newline-n


