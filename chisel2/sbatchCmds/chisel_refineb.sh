#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_chiselRefine_%j.txt
#SBATCH --output=slurmOut/slurm_chiselRefine_%j.txt
#SBATCH --mem=1G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --job-name chiselRefine
#SBATCH --wait
#SBATCH --array=0-2
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=matthew.cannon@nationwidechildrens.org
#SBATCH --mail-type=FAIL,REQUEUE,TIME_LIMIT_80

set -e ### stops bash script if line ends with error

echo ${HOSTNAME}

module load GCC/9.3.0 \
            GCCcore/9.3.0 \
            BCFtools/1.11

source ~/bin/chisel/conda/bin/activate chisel

sampleArray=(S0113 S0114 S0116)

sample=${sampleArray[${SLURM_ARRAY_TASK_ID}]}

echo "start: " ${sample}

runPath=$(pwd)

for aCutoff in 4 6
do

  if [ ! -d output/chisel/refineCalling/${sample}_A${aCutoff} ]
  then
    mkdir -p output/chisel/refineCalling/${sample}_A${aCutoff}
    mkdir -p output/chisel/refineCalling/${sample}_A${aCutoff}_K80
  fi

  cd output/chisel/refineCalling/${sample}_A${aCutoff}

  chisel_calling \
    -A ${aCutoff} \
    -j 20 \
    ${runPath}/output/chisel/try2/${sample}/combo/combo.tsv

  cd ../${sample}_A${aCutoff}_K80

  chisel_calling \
    -A ${aCutoff} \
    -j 20 \
    -K 80 \
    ${runPath}/output/chisel/try2/${sample}/combo/combo.tsv

  cd ${runPath}
  
  cp output/chisel/refineCalling/${sample}_A${aCutoff}_K80/plots/allelecn.png \
    output/chisel/refineCalling/allelecn_${sample}_f${aCutoff}_K80.png

  cp output/chisel/refineCalling/${sample}_A${aCutoff}/plots/allelecn.png \
    output/chisel/refineCalling/allelecn_${sample}_f${aCutoff}.png

done
