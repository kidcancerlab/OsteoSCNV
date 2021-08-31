#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_chisel2_%j.txt
#SBATCH --output=slurmOut/slurm_chisel2_%j.txt
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --job-name chisel2
#SBATCH --wait
#SBATCH --array=0-2
#SBATCH --time=3-00:00:00
#SBATCH --mail-user=matthew.cannon@nationwidechildrens.org
#SBATCH --mail-type=FAIL,REQUEUE,TIME_LIMIT_80

set -e ### stops bash script if line ends with error

echo ${HOSTNAME}

module load GCC/9.3.0 \
            GCCcore/9.3.0 \
            BCFtools/1.11

source ~/bin/chisel/conda/bin/activate chisel

sampleArray=(S0113 S0114 S0116)
refArray=(SJOS046149_Gx SJOS031478_G1 SJOS031478_G1)

sample=${sampleArray[${SLURM_ARRAY_TASK_ID}]}
ref=${refArray[${SLURM_ARRAY_TASK_ID}]}

echo "start: " ${sample} ${ref} ${HOSTNAME}

if [ ! -d output/chisel/try2/${sample} ]
then
  mkdir output/chisel/try2/${sample}
else
  rm -r output/chisel/try2/${sample}/*
fi 

cd output/chisel/try2/${sample}/

bcfPath=/home/gdrobertslab/lab/Analysis/Matt/stjude/output/vcfs/phased/merged2

bcfFile=${bcfPath}/${ref}.bcf

bcftools view \
  ${bcfPath}/${ref}.bcf | \
  grep -v "^#" | \
  cut -f 1,2,10 | \
  perl -pe 's/:.+//' | \
  grep -v "1|1" \
    > /gpfs0/scratch/mvc002/testPosHet_${sample}.txt

sampleBam=/home/gdrobertslab/lab/Counts/${sample}/possorted_bam.bam
refBam=/home/gdrobertslab/lab/Analysis/Matt/stjude/rawData/${ref}.WholeGenome.bam

chisel \
  -t ${sampleBam} \
  -n ${refBam} \
  -r /reference/homo_sapiens/hg38/ucsc_assembly/illumina_download/Sequence/WholeGenomeFasta/genome.fa \
  -l /gpfs0/scratch/mvc002/testPosHet_${sample}.txt \
  -j 20

