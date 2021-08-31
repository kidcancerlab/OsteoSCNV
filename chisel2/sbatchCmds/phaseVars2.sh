#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_phaseVars_%j.txt
#SBATCH --output=slurmOut/slurm_phaseVars_%j.txt
#SBATCH --mem=1G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --job-name phaseVars
#SBATCH --wait
#SBATCH --array=0-65%20
#SBATCH --time=3-00:00:00
#SBATCH --mail-user=matthew.cannon@nationwidechildrens.org
#SBATCH --mail-type=FAIL,REQUEUE,TIME_LIMIT_80

set -e ### stops bash script if line ends with error

module load GCC/9.3.0 \
            GCCcore/9.3.0 \
            BCFtools/1.11

fileArray=(output/vcfsCombined/*.bcf)

chrArray=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 \
  chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22)

combinedArray=()

for i in "${!fileArray[@]}"
do
  for j in "${!chrArray[@]}"
  do
    combinedArray+=("${fileArray[i]}@${chrArray[j]}")
  done
done

combination=${combinedArray[${SLURM_ARRAY_TASK_ID}]}

chr=${combination##*@}
fileName=${combination%@*}
fileStub=${fileName##*/}
fileStub=${fileStub%.bcf}

echo "start: " ${chr} ${fileName} ${HOSTNAME}

bcftools view \
  -O z \
  -i '%QUAL>=20' \
  --regions ${chr} \
  --threads 5 \
  --max-alleles 2 \
  ${fileName} > output/vcfs/splitByChr/${fileStub}_${chr}.vcf.gz
  
