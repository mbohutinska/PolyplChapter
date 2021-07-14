#!/bin/bash -e
#PBS -N 4d_Chapter
#PBS -l walltime=00:50:00
#PBS -l select=1:ncpus=4:mem=4gb:scratch_local=2gb
#PBS -m abe
#PBS -j oe

module add gatk-3.7 
#module add parallel-20160622
trap 'clean_scratch' TERM EXIT
if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch not created!" 1>&2; exit 1; fi 
DATADIR="/storage/pruhonice1-ibot/home/holcovam/ScanTools/polyplChapter"
cp /storage/plzen1/home/holcovam/references/lyrataV2/alygenomes* $SCRATCHDIR || exit 1
cp /storage/brno3-cerit/home/filip_kolar/600_genomes/mapped_to_lyrata/vcf_arenosa/vcf_november2019/final.filter/forscantools/fourfold/scaffold_1scaffold_1arenosa_snp_raw.fourfold.filtered.vcf.gz* $SCRATCHDIR || exit 1
cp $DATADIR/scaff $SCRATCHDIR || exit 1

cd $SCRATCHDIR || exit 2
echo data loaded at `date`

#cat scaff | time parallel -j+0 'echo {} > {.}.txt'

# -j = ncpus-1
# RAM = mem/ncpus-1


java -Xmx4g -jar $GATK/GenomeAnalysisTK.jar -T SelectVariants -R alygenomes.fasta -V scaffold_1scaffold_1arenosa_snp_raw.fourfold.filtered.vcf.gz -o arenosa_snp_raw.fourfold.filtered.PolyplChapter.vcf.gz -env -sn BDO_01da -sn BDO_02da -sn BDO_03da -sn BDO_04da -sn BDO_05da -sn BDO_06da -sn BDO_07da -sn BDO_08da -sn SUB_02da -sn SUB_03da -sn SUB_04da -sn SUB_05da -sn SUB_06da -sn SUB_07da -sn SUB_08da -sn VEL_01da -sn VEL_02da -sn VEL_03da -sn VEL_04da -sn VEL_05da -sn VEL_06da -sn VEL_07da -sn VEL_08da -sn VEL_09da -sn BAL_01ta -sn BAL_02ta -sn BAL_03ta -sn BAL_04ta -sn BAL_05ta -sn BAL_06ta -sn BAL_07ta -sn BAL_08ta -sn TIS_01ta -sn TIS_02ta -sn TIS_03ta -sn TIS_04ta -sn TIS_05ta -sn TIS_06ta -sn TIS_07ta -sn TIS_08ta --maxNOCALLnumber 22 


rm alygenomes*
rm scaffold_1scaffold_1arenosa_snp_raw.fourfold.filtered.vcf.gz*
cp $SCRATCHDIR/* $DATADIR/ || export CLEAN_SCRATCH=false
printf "\nFinished\n\n"


