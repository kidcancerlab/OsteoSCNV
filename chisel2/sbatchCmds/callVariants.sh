#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_callVars_%j.txt
#SBATCH --output=slurmOut/slurm_callVars_%j.txt
#SBATCH --mem=30G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --job-name callVars
#SBATCH --wait
#SBATCH --array=0-12
#SBATCH --time=3-00:00:00

module load GCC/9.3.0 \
            GCCcore/9.3.0 \
            BCFtools/1.11

fileArray=(rawData/*.bam)

for i in "${!fileArray[@]}"
do
  stubArray[$i]="${fileArray[$i]##*/}"
  stubArray[$i]="${stubArray[$i]%.WholeGenome.bam}"
done


bcftools mpileup \
  --threads 10 \
  --max-depth 2000 \
  -Ou \
  -f /reference/homo_sapiens/hg38/ucsc_assembly/illumina_download/Sequence/WholeGenomeFasta/genome.fa \
  ${fileArray[${SLURM_ARRAY_TASK_ID}]} | \
bcftools call \
  --threads 10 \
  --ploidy GRCh38 \
  -mv \
  -Ob \
  -o output/vcfs/${stubArray[${SLURM_ARRAY_TASK_ID}]}.bcf

