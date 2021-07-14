# converstion from AF tables from ScanTools function .splitVCFsTreeMix to TreeMIX input file format
# 18 April 2016, update 28 July 2017, re-written 13 September 2018 by Majda B.

import os, sys, argparse, subprocess
from natsort import natsorted

parser = argparse.ArgumentParser(description='Takes allele count tables as input and converts them into Treemix input format.')
parser.add_argument('-i', type=str, metavar='AC_folder', required=True, help='REQUIRED: Relative path to input directory containing allele count tables')
parser.add_argument('-o', type=str, metavar='output_folder', required=True, help='REQUIRED: Relative path to output directory')
args = parser.parse_args()
# test whether output directory exists
if os.path.exists(args.o) == False:
	os.mkdir(args.o)
	print('Created directory '+str(args.o))

## STEP 1: Convert data to treemix input format ##
# Obtain list with all AC tables, 1 table per Population
infile_list = []
for file in os.listdir(args.i):
	if '_tm.table' in file:
		infile_list.append(file)
infile_list_sorted = natsorted(infile_list)
print('Found following input files: '+str(infile_list_sorted)+'\n')
header = open('header.txt', 'w')
for x in infile_list_sorted:
	print('\tConvert '+x)
	tpop = x.replace('variants_only_', '')
	pop = tpop.replace('_tm.table', '')
	print(pop)
	header.write(pop+' ')
	with open(args.o+pop+'_treein.out', 'w') as outfile:
		outfile.write(pop+'\n')
		with open(args.i+x) as infile:
			infile.readline() # to read and remove the header
			num_lines = sum(1 for line in infile)
			print(str(num_lines)+' SNPs in '+x)
			infile.seek(0)
			infile.readline()
			for line in infile:
				scaffold, position, AC, AN = line.split()
				RC = int(AN)-int(AC) # RC stands for Reference Count, count of reference alleles
				outfile.write(str(scaffold)+'_'+str(position)+' '+str(RC)+','+str(AC)+'\n')
	outfile.close()
	infile.close()
header.write('\n')
header.close()

## STEP 2: Paste populations by column into singe file ##
# obtain input list
inlist = []
for dirName, subdirList, fileList in os.walk(args.o):
	for file in fileList:
		if file.endswith('_treein.out'):
			inlist.append(file)
inlist_sorted = natsorted(inlist)
print('\nCreate treemix input table.')
shfile1 = open('join.sh', 'w')
shfile1.write('#!/bin/bash\n')
for j in range(len(inlist_sorted)):
	shfile1.write('tail -n+2 '+args.o+inlist_sorted[j]+' | sort -k 1,1 > '+args.o+'sorted.'+inlist_sorted[j]+' \n')

shfile1.write('function multijoin() {\n    out=$1\n    shift 1\n    cat $1 | awk \'{print $1}\' > $out\n    for f in $*; do join $out $f > tmp; mv tmp $out; done\n}\n\n multijoin all1 ')


for j in range(len(inlist_sorted)):
	print(str(args.i+inlist_sorted[j]))
	shfile1.write(args.o+'sorted.'+inlist_sorted[j]+ ' ')
shfile1.write('\n\n cut -f2- -d " " all1 > all2 \n cat header.txt all2 | gzip > '+args.o+'treemix_input.table.gz \n rm '+args.o+'sorted.* \n rm header.txt \n rm all* \n rm '+args.o+'*treein.out\n')
shfile1.close()
cmd1 = ('bash join.sh')
subprocess.call(cmd1, shell=True) 
os.remove('join.sh')
print('Treemix input file created.\n')
