#!/bin/bash -e
#PBS -N 4dVariable
#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=7:mem=16gb:scratch_local=10gb
#PBS -m abe
#PBS -j oe

module add gatk-3.7 
module add parallel-20160622
trap 'clean_scratch' TERM EXIT
if [ ! -d "$SCRATCHDIR" ] ; then echo "Scratch not created!" 1>&2; exit 1; fi 
DATADIR="/storage/pruhonice1-ibot/home/holcovam/ScanTools/polyplChapter"
cp /storage/plzen1/home/holcovam/references/lyrataV2/alygenomes* $SCRATCHDIR || exit 1
cp /storage/brno3-cerit/home/filip_kolar/600_genomes/mapped_to_lyrata/vcf_arenosa/vcf_november2019/final.filter/forscantools/fourfold/*arenosa_snp_raw.fourfold.filtered.vcf.gz* $SCRATCHDIR || exit 1
#cp $DATADIR/zero.fold.degenerate.sites.list1.scaffold_* $SCRATCHDIR || exit 1
cp $DATADIR/scaff $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2
echo data loaded at `date`

# -j = ncpus-1
# RAM = mem/ncpus-1

cat scaff | parallel -j 4 'java -Xmx4g -jar $GATK/GenomeAnalysisTK.jar -T SelectVariants -R alygenomes.fasta -V {}{}arenosa_snp_raw.fourfold.filtered.vcf.gz -o {.}arenosa_spn_raw.fourfold.variable.vcf.gz -env'

rm alygenomes*
rm *arenosa_snp_raw.fourfold.filtered*

rm scaff
cp $SCRATCHDIR/* $DATADIR/ || export CLEAN_SCRATCH=false
printf "\nFinished\n\n"


