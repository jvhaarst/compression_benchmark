This set of scripts can be used to test the advantages of using parallel versions of compression programs on you own dataset.
We have written a bash script to perform the compressions, and a R script to create a graph of the data.

The bash script is called like this :

compresstest.sh file_to_compress 2>&1 | tee `hostname`_`date +%Y%m%d_%H%M%S`.csv

After it finished, the data needs to be filtered and formatted for use in the R script, like this:

cat galaxy_20120210_150137.csv | grep -f matches.grep  | grep -v Pavlov | sed ':a;N;$!ba;s/%\n/%\t/g' > compressieResults.csv

Then use the R script to generate a graph of the result :

R CMD BATCH --no-save --no-restore "--args compressieResults.csv blah.pdf pdf" compressieResults.R


