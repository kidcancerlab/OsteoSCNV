#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_callVarsComb_%j.txt
#SBATCH --output=slurmOut/slurm_callVarsComb_%j.txt
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --job-name callVarsComb
#SBATCH --wait
#SBATCH --time=3-00:00:00

module load GCC/9.3.0 \
            GCCcore/9.3.0 \
            BCFtools/1.11


samtools cat \
   rawData/SJOS046149_G[12].WholeGenome.bam |
    bcftools mpileup \
       --threads 10 \
       --max-depth 10000 \
       -Ou \
       -f /reference/homo_sapiens/hg38/ucsc_assembly/illumina_download/Sequence/WholeGenomeFasta/genome.fa \
       - | \
  bcftools call \
     --threads 10 \
     --ploidy GRCh38 \
     -mv \
     -Ob \
     -o output/vcfsCombined/SJOS046149_Gx.bcf



for inFile in SJOS030645_G1.bcf output/vcfs/SJOS031478_G1.bcf
do
  ln -s output/vcfs/${inFile} output/vcfsCombined/${inFile}
done