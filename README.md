# Single-cell analysis of aneuploidy and CNAs in osteosarcoma patients

Allele- and haplotype-specific CNAs, WGD status, and related single-cell clones have been inferred using [CHISEL](https://github.com/raphael-group/chisel) and the inferred results for all analyzed samples are reported here in the folder `chisel`, with a folder for each different osteosarcoma patient.
This repository includes a Jupyter notebook [analysis](./analysis.ipynb) to reproduce all the analyses and figures in the related manuscript:

[To be updated soon]

## Requirements

The Jupyter notebook requires `python3` and the following packages: `numpy`, `pandas`, `matplotlib`, `seaborn`, and `scipy`. Moreover, [jupyter](https://jupyter.org/) is required to read and execute the notebook.
For the sake of space limitations, all the CHISEL processed results that are included in this repository have been zipped using `gzip`.
The execution of the notebook thus requires the user to unpack all files with the following command (executing from this directory):

```shell
find chisel/ -type f -name '*.gz' -exec gzip -d {} +
```

## Installation

The following commands are sufficient to install all the requirements within a [conda](https://docs.conda.io/en/latest/) environment without any requirement in any *nix system (if you are in OSx please substitute the downloading link as appropriate from [miniconda](https://docs.conda.io/en/latest/miniconda.html)) when executed from this directory:

```shell
curl -L https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh > miniconda.sh
rm -rf ./conda/
bash miniconda.sh -b -f -p ./conda/
conda/bin/conda create -n chisel-osteo python=2.7 jupyter numpy pandas matplotlib seaborn scipy -y
source conda/bin/activate chisel-osteo
```

Before any re-execution in a new session, please only run the following command from this folder:

```shell
source conda/bin/activate chisel-osteo
```

Note that if `conda` is already available in your system, only these two commands are needed:
```
conda create -n chisel-osteo python=3 jupyter numpy pandas matplotlib seaborn scipy -y
conda activate chisel-osteo
```

## Results

The notebook to fully replicate all the analysis can be executed with the command `jupyter-notebook` and then opening the file `analysis.ipynb`, or you can simply visualise all the analyses and plots online on GitHub by clicking on [analysis](./analysis.ipynb) without executing the script. When executing the notebook, the resulting plots are generated in this directory as PDF files.

## Contact

Author: Dr Simone Zaccaria\
Old affilliation: Princeton University, NJ (USA)\
New affilliation: UCL Cancer Institute, London (UK)\
Correspondence: s.zaccaria@ucl.ac.uk\
Website: [www.ucl.ac.uk/cancer/zaccaria-lab](https://www.ucl.ac.uk/cancer/zaccaria-lab)
