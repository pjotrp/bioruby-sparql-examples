#! /bin/bash

biotable="$HOME/izip/git/opensource/ruby/bioruby-table/bin/bio-table"
num=-16

cd output
echo -e "Species\tSource\tCPGs" > table1.part1
tail $num species_clusters.txt |sort >> table1.part1
$biotable table1.part1 --rewrite "rowname = rowname + '-' + field[0]" > table1.part1.1
echo -e "Species\tSource\tCps" > table1.part2
tail $num species_clusters_pos_sel.txt |sort >> table1.part2
$biotable table1.part2 --rewrite "rowname = rowname + '-' + field[0]" > table1.part2.1
echo -e "Species\tSource\tNR\tNRgenes" > table1.part3
tail $num homolog_nr.txt |sort >> table1.part3
$biotable table1.part3 --rewrite "rowname = rowname + '-' + field[0]" > table1.part3.1
echo -e "Species\tSource\tSP\tSPgenes" > table1.part4
tail $num homolog_species.txt |sort >> table1.part4
$biotable table1.part4 --rewrite "rowname = rowname + '-' + field[0]" > table1.part4.1
$biotable --merge table1.part1.1 table1.part2.1 table1.part3.1 table1.part4.1 > table1.part1.2
$biotable --columns 0,2,4,6,7,9,10 table1.part1.2 > table1.txt
# $biotable --format eval -e 'field.join("\t")+" \\\\"' table1.txt > table1.tex
cat table1.txt

cd ..

