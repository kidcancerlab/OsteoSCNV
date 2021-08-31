#!/bin/sh
#SBATCH --account=gdrobertslab
#SBATCH --error=slurmOut/slurm_chiselRefine_%j.txt
#SBATCH --output=slurmOut/slurm_chiselRefine_%j.txt
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --job-name chiselRefine
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

sample=${sampleArray[${SLURM_ARRAY_TASK_ID}]}

echo "start: " ${sample}

runPath=$(pwd)

for fCutoff in 0.07 0.1 0.12 0.15 
do

  if [ ! -d output/chisel/refineCloning3/${sample}_f${fCutoff} ]
  then
    mkdir -p output/chisel/refineCloning3/${sample}_f${fCutoff}
    mkdir -p output/chisel/refineCloning3/${sample}_f${fCutoff}_S8
  fi 

  cd output/chisel/refineCloning3/${sample}_f${fCutoff}

  chisel_cloning \
    -f ${fCutoff} \
    -r 0.6 \
    ${runPath}/output/chisel/refineCalling/${sample}_A4_K80/calls/calls.tsv

  cd ${runPath}/output/chisel/refineCloning3/${sample}_f${fCutoff}_S8

  chisel_cloning \
    -f ${fCutoff} \
    -r 0.6 \
    -s 8 \
    ${runPath}/output/chisel/refineCalling/${sample}_A4_K80/calls/calls.tsv

  cd ${runPath}

  cp output/chisel/refineCloning3/${sample}_f${fCutoff}_S8/plots/allelecn.png \
    output/chisel/refineCloning3/allelecn_${sample}_f${fCutoff}_S8.png

  cp output/chisel/refineCloning3/${sample}_f${fCutoff}/plots/allelecn.png \
    output/chisel/refineCloning3/allelecn_${sample}_f${fCutoff}.png
done


