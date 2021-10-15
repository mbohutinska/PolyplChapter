# PolyplChapter
A tutorial which can guide you through the practical aspects of analyses of diploid-autotetraploid species (associated to Bohutínská et al, 2021: Population genomic analysis of diploid - autopolyploid species). 

Part A covers a conversion of VCF to ScanTools table format and calculation of within- and between- population genomic metrics.

Part B introduces poplation genetic structure reconstruction with adegenet.

Part C describes population structure and admixture analysis with TreeMix.


By Magdalena Bohutínská (holcovam@natur.cuni.cz) and Filip Kolář (filip.kolar@gmail.com )


## PART A. POLYPLOIDY TUTORIAL ScanTools - population genetic metrics 

0. Download Scantools from https://github.com/mbohutinska/ScanTools_ProtEvol. You will also find there a dedicated readme about the script.


You don't need to install ScanTools, just carefully change paths throughout the script. Also, make sure to modify it to your cluster system - ScanTools at my repository are developed for PBS. Then prepare a PopKey which assigns individuals in your dataset into populations. You may find an example PopKey in the folder PartA. 

 -Requirments: python3 (os, subprocess, pandas, math, datetime, time, glob), GATK3.7, fastsimcoal2


1. change directory to the locations of ScanTools scripts (here /storage/pruhonice1-ibot/home/holcovam/ScanTools) and place your vcf files into a subfolder in that directory (here polyplChapter), than initialize them:

``module add python36-modules-gcc``

``python3``

``import ScanTools``

``test = ScanTools.scantools("/storage/pruhonice1-ibot/home/holcovam/ScanTools") ``



2. before starting any popgen calculations with ScanTools, convert vcf to table by following command in ScanTools: 

``
test.splitVCFsNorepol(vcf_dir="polyplChapter", min_dp="8",mffg="0.2", mem="16", time_scratch='02:00:00', ncpu="12",overwrite=True, scratch_gb="1",keep_intermediates=False, use_scratch=True,scratch_path="$SCRATCHDIR", pops=['SUB','VEL','TIS','BAL'], print1=False)
``
Here we only remained sites with maximum fraction of filtered genotypes lower than 20% (mffg="0.2") and minimum sequencing depth of a site in individual higher or equalt to 8 (min_dp="8"). For details on other parameters see the ScanTools.py and recode12.py scripts.  

We recommend using vcf with four-fold degenetared or any other nearly-neutral type of sites. In order to correctly estimate some of the matrics (like nucleotide diversity) this vcf should contain both invariable and variable sites.

You can find the output of this initial step in the folder PartA and (after extracting them from .tar.gz to .txt) use it as an example dataset for the next steps.


3a. calculate within population metrics - nucleotide diversity, Tajimas D,...

``test.calcwpm(recode_dir = "VCF_polyplChapter_DP8.M0.2", window_size = 50000, min_snps = 50, pops=['SUB','VEL','TIS','BAL'], mem=1, ncpu=1, scratch_gb=1, use_repol=False, time_scratch="1:20:00", overwrite=True, sampind=7, print1=False)``

.calcwpm module will output population genetic metrics for each window and also genome-wide - genome-wide values are summarised on the last line, starting with "Genome". You can easily summarise them across your populations using bash:

``cat VEL.WS50.0k_MS50_7ind_WPM.txt | head -n1 >>      genome.WS50.0k_MS50_7ind_WPM.txt``

``cat VEL.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt``

``cat SUB.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt``

``cat TIS.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt``

``cat BAL.WS50.0k_MS50_7ind_WPM.txt | grep "Genome" >> genome.WS50.0k_MS50_7ind_WPM.txt``

3b. calculate between population metrics - Fst, Rho, Dxy,...

``test.calcPairwisebpm(recode_dir= "VCF_polyplChapter_DP8.M0.2", pops=['SUB','VEL','TIS','BAL'], window_size=50000, min_snps=50, mem=1, ncpu=1, use_repol=False, keep_intermediates=False, time_scratch="0:40:00",scratch_gb=1, print1=False)``

Same as above, .calcPairwisebpm module will output population genetic metrics for each window and also genome-wide - genome-wide values are summarised on the last line, starting with "Genome". You can easily summarise them across your populations using bash:


``cat SUBVEL_WS50000_MS50_BPM.txt | head -n1 >       genome.WS50000_MS50_BPM.txt``

``cat SUBVEL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt``

``cat SUBBAL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt``

``cat SUBTIS_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt``

``cat VELBAL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt``

``cat VELTIS_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt``

``cat TISBAL_WS50000_MS50_BPM.txt | grep "Genome" >> genome.WS50000_MS50_BPM.txt``


4. download the results into your local computer

``
scp holcovam@nympha.metacentrum.cz:/storage/pruhonice1-ibot/home/holcovam/ScanTools/VCF......./genome* .
``


## PART B. POLYPLOIDY TUTORIAL population genetic structure (input for adegenet) 


1. filter only variable sites and individuals you need from your vcf of four-fold degenerated sites. 

``ssh holcovam@tilia.ibot.cas.cz``

``qsub filterScaffoldsChapter.sh ``

You will find the filtering script (for slurm cluster) together with the output file in the folder PartB. You may use the output as an example dataset for the next steps.

2. download locally and continue using AdegenetPolyplChapter.R 


## PART C. POLYPLOIDY TUTORIAL treemix


Converting vcf to TreeMix input, and running TreeMix
0. Download TreeMix and get familiar with the software (https://bitbucket.org/nygcresearch/treemix/wiki/Home). 

1. Extract variable sites from your vcf with fourfold sites. Here we also add an outgroup population from the most ancestral diploid lineage of A. arenosa - BDO. You may find the filtering script (for slurm cluster) in the folder PartC.

``
qsub filter4dVariable.sh 
``

2. run .splitVCFsTreeMix function ScanTools_ProtEvol  

``module add python36-modules-gcc``

``python3``

``import ScanTools``

``test = ScanTools.scantools("/storage/pruhonice1-ibot/home/holcovam/ScanTools") ``


``test.splitVCFsTreeMix(vcf_dir="polyplChapter", pops=['SUB','VEL','TIS','BAL','BDO'], mem="16", time_scratch='00:40:00', ncpu="5", scratch_path="$SCRATCHDIR",min_dp="8",mffg="0.2", overwrite=True, scratch_gb="8", keep_intermediates=False, use_scratch=True, print1=False) ``

I provide the output of this script in the folder PartC. You may use it (after extraction from .tar.gz) as an example dataset for the next steps.

3. copy the output of .splitVCFsTreeMix to local folder, find the TreeMix input conversion script building on the ScanTools output here: https://github.com/mbohutinska/TreeMix_input. Run:

``python3 conversionTreemixMajda.py -i "chapter/" -o "chapter/"``


-i and -o are parameters specifying the input and output folder. Here I use the same folder named 'chapter'

4a. run treemix without migration, with BDO as an ougroup

``
treemix -i chapter/treemix_input.table.gz -root BDO -o chapter/subs_mig0_boot0 -k 25
``

4b. run treemix for multiple migration events (in case of 4 pop incl. outgroup max 1 migration)

``
treemix -i chapter/treemix_input.table.gz -root BDO -m 1 -o chapter/subs_mig1_boot0 -k 25``

``treemix -i chapter/treemix_input.table.gz -root BDO -m 2 -o chapter/subs_mig2_boot0 -k 25``

``treemix -i chapter/treemix_input.table.gz -root BDO -m 3 -o chapter/subs_mig3_boot0 -k 25
``


5. find optimal n. of migrations, visualize the tree. You may find the script in the folder PartC.

treemix.R 




