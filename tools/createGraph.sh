#!/bin/sh

set -e

DIR1="$1"
DIR2="$2"

#Sort the file1
tail -n +6  ${DIR1}/all_results.csv > r10.csv
sort r10.csv > r11.csv
NAME1=`grep -o "mcpu=.*" ${DIR1}/all_results.csv | cut -f1 -d' ' | cut -d'=' -f2`

#Sort the file1
tail -n +6  ${DIR2}/all_results.csv > r20.csv
sort r20.csv > r21.csv
NAME2=`grep -o "mcpu=.*" ${DIR2}/all_results.csv | cut -f1 -d' ' | cut -d'=' -f2`

#get them in the same file
pr -m -t -s\, r11.csv r21.csv > r30.csv

#get global geomean
cat r30.csv | awk 'BEGIN{ FS ="," } \
{a=1.0;if (($3 != 0) && ($6 != 0)) a=$3/$6; C+=log(a); D++}\
END{ print "Geomean per file: ", exp(C/D)}'

#compute sum per test
cat r30.csv | awk 'BEGIN{ FS =","; test="" }\
{if (test == $1) { sum0 += $3; sum1 += $6;} \
else { print test "," sum0 "," sum1; test = $1; sum0 = $3; sum1 = $6;}}\
END{ print test "," sum0 "," sum1}' > r31.csv
tail -n +2 r31.csv > r32.csv

#get per test geomean
cat r32.csv | awk 'BEGIN{ FS ="," } \
{a=1.0;if (($2 != 0) && ($3 != 0)) a=$2/$3; C+=log(a); D++}\
END{ print "Geomean per bench: ", exp(C/D)}'

#prepare data for gnugraph
cat r32.csv | awk 'BEGIN{ FS ="," } \
{a = 1; if (($2 != 0) && ($3 != 0)) a=(1-$2/$3)*100; print $1 "\t" a}' > r33.dat

#dump the gnugaph script
cat > norm.p <<EOF
#Gnuplot script file for ploting data
set title "CSiBE Size Benchmark (normalized ${NAME1} / ${NAME2})"
set auto x
set style fill solid 0.8 border -1
set boxwidth 0.9 relative
set xtic rotate by 315
set xtic auto
set ytic auto
set terminal gif
set output "normalized.gif"
set nokey
plot "r33.dat" using 2:xtic(1) with boxes
EOF

#get the picture
gnuplot -p -e "load 'norm.p'"
display normalized.gif &

#clean up
rm -rf norm.p
rm -rf r*.csv
