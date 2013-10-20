#! /bin/sh

./bin/gwp/query species > output/species_clusters.txt 2>&1
./bin/gwp/query match > output/match.txt 2>&1
./bin/gwp/query match --is_pos_sel > output/match_pos_sel.txt 2>&1
./bin/gwp/query homolog > output/homolog.txt 2>&1
./bin/gwp/query homolog --species > output/homolog_species.txt 2>&1
./bin/gwp/query homolog --nr > output/homolog_nr.txt 2>&1
