#! /bin/sh

./bin/gwp/query species > output/species_clusters.txt 
# ./bin/gwp/query match --is_pos_sel > output/match_pos_sel.txt 
./bin/gwp/query match > output/match.txt 
./bin/gwp/query match --is_pos_sel > output/match_pos_sel.txt 

