# PolyplChapter
A tutorial which can guide you through the practical aspects of analyses of diploid-autotetraploid species (associated to Bohutinska et al, 2021: Population genomic analysis of diploid - autopolyploid species)


## PART A. POLYPLOIDY TUTORIAL ScanTools - population genetic metrics 

0. Download Scantools from https://github.com/mbohutinska/ScanTools_ProtEvol.


You dont need to install anything, just carefully change paths throughout the script. Also, make sure to modify it to your cluster system - original ScanTools are developed for slurm. 


1. change directory 


to the locations of ScanTools scripts(here /storage/pruhonice1-ibot/home/holcovam/ScanTools) and place your vcf files into a subfolder in that directory (here polyplChapter) 

``

module add python36-modules-gcc
python3
import ScanTools
test = ScanTools.scantools("/storage/pruhonice1-ibot/home/holcovam/ScanTools") 

``


2. convert vcf to table

``
test.splitVCFsNorepol(vcf_dir="polyplChapter", min_dp="8",mffg="0.2", mem="16", time_scratch='02:00:00', ncpu="12",overwrite=True, scratch_gb="1",keep_intermediates=False, use_scratch=True,scratch_path="$SCRATCHDIR", pops=['SUB','VEL','TIS','BAL'], print1=False)
``

3a. calculate within population metrics - nucleotide diversity, Tajimas D,...

``
test.calcwpm(recode_dir = "VCF_polyplChapter_DP8.M0.2", window_size = 50000, min_snps = 50, pops=['SUB','VEL','TIS','BAL'], mem=1, ncpu=1, scratch_gb=1, use_repol=False, time_scratch="1:20:00", overwrite=True, sampind=7, print1=False)


cat VEL.WS50.0k_MS50_7ind_WPM.txt | head -n1 >>      genome.WS50.0k_MS50_7ind_WPM.txt

cat VEL.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt

cat SUB.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt

cat TIS.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt

cat BAL.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt
``

3b. calculate between population metrics - Fst, Rho, Dxy,...

``
test.calcPairwisebpm(recode_dir= "VCF_polyplChapter_DP8.M0.2", pops=['SUB','VEL','TIS','BAL'], window_size=50000, min_snps=50, mem=1, ncpu=1, use_repol=False, keep_intermediates=False, time_scratch="0:40:00",scratch_gb=1, print1=False)

cat SUBVEL_WS50000_MS50_BPM.txt | head -n1 >       genome.WS50000_MS50_BPM.txt

cat SUBVEL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt

cat SUBBAL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt

cat SUBTIS_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt

cat VELBAL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt

cat VELTIS_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt

cat TISBAL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt
``

4. download the results into your local computer

``
scp holcovam@nympha.metacentrum.cz:/storage/pruhonice1-ibot/home/holcovam/ScanTools/VCF......./genome* .
``


## PART B. POLYPLOIDY TUTORIAL population genetic structure (input for adegenet) 


1. filter only variable sites and individuals you need from your vcf of four-fold degenerated sites. 

``
ssh holcovam@tilia.ibot.cas.cz

qsub filterScaffoldsChapter.sh 
``


2. download locally and continue using AdegenetPolyplChapter.R 


## PART C. POLYPLOIDY TUTORIAL treemix


Converting vcf to TreeMix input, and running TreeMix

1. to extract variable sites from your vcf with fourfold sites:


``
qsub filter4dVariable.sh 
``

2. run .splitVCFsTreeMix function ScanTools_ProtEvol  

``
module add python36-modules-gcc

python3

import ScanTools

test = ScanTools.scantools("/storage/pruhonice1-ibot/home/holcovam/ScanTools") 


test.splitVCFsTreeMix(vcf_dir="polyplChapter", pops=['SUB','VEL','TIS','BAL'], mem="16", time_scratch='00:40:00', ncpu="5", scratch_path="$SCRATCHDIR",min_dp="8",mffg="0.2", overwrite=True, scratch_gb="8", keep_intermediates=False, use_scratch=True, print1=False) #
``

3. copy the output of .splitVCFsTreeMix to local folder, run:

``
python3 conversionTreemixMajda.py -i "chapter/" -o "chapter/"
``


4a. run treemix without migration

``
treemix -i chapter/treemix_input.table.gz -root BDO -o chapter/subs_mig0_boot0 -k 25
``

4b. run treemix for multiple migration events (in case of 4 pop incl. outgroup max 1 migration)

``
treemix -i chapter/treemix_input.table.gz -root BDO -m 1 -o chapter/subs_mig1_boot0 -k 25

treemix -i chapter/treemix_input.table.gz -root BDO -m 2 -o chapter/subs_mig2_boot0 -k 25

treemix -i chapter/treemix_input.table.gz -root BDO -m 3 -o chapter/subs_mig3_boot0 -k 25
``


5. find optimal n. of migrations, visualize the tree

treemix.R 




