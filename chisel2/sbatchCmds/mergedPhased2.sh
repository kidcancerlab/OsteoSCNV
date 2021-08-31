#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_mergePhased_%j.txt
#SBATCH --output=slurmOut/slurm_mergePhased_%j.txt
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --job-name mergePhased
#SBATCH --wait
#SBATCH --array=0-2
#SBATCH --time=3-00:00:00

module load GCC/9.3.0 \
      GCCcore/9.3.0 \
      BCFtools/1.11

fileArray=(SJOS030645_G1 SJOS031478_G1 SJOS046149_Gx)
folderArray=(J45 J49 J78)

for i in "${!fileArray[@]}"
do
  fileArray[$i]="${fileArray[$i]##*/}"
  fileArray[$i]="${fileArray[$i]%.bcf}"
done

bcftools concat \
  --threads 10 \
  -O b \
  output/vcfs/phased/topmed/${folderArray[${SLURM_ARRAY_TASK_ID}]}/*vcf.gz \
  > output/vcfs/phased/merged2/${fileArray[${SLURM_ARRAY_TASK_ID}]}.bcf

