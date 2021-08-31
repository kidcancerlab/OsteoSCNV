#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_indexRef_%j.txt
#SBATCH --output=slurmOut/slurm_indexRef_%j.txt
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --job-name indexRef
#SBATCH --wait
#SBATCH --array=0-13
#SBATCH --time=3-00:00:00

module load GCC/9.3.0 \
            SAMtools/1.10

fileArray=(rawData/*.bam)

samtools index \
  -@ 10 \
  ${fileArray[${SLURM_ARRAY_TASK_ID}]}

