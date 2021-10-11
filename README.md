# replicable2021

## Description
This repository contains exploratory work looking at replicability meta-analysis packages for [Dr. Xiaoquan Wen](https://sph.umich.edu/faculty-profiles/wen-xiaoquan.html). The two packages explored were the [MAMBA package](https://github.com/dan11mcguire/mamba) and the [PRP package](https://github.com/ArtemisZhao/PRP).

## Workflow
The general workflow is given below. Before running any of the files, download the data files from [this link](https://drive.google.com/drive/folders/1ocS_OZR1DQAM88rMR6QTN8UfvqMTGRwJ?usp=sharing). Place the folders (along with their files) into the `main_files` folder. Data was also borrowed from the [GIANT Consortium](https://portals.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files).

1. Run `.R` "job" files in `main_files/data` to generate data based on MAMBA package. It is best if you run them as jobs in the background. Alternatively, you can download the files from the link above to save time.

   The data files are placed into `main_files/data/mamba_data` and `main_files/data/prp_data`.

2. Run the `.Rmd` files located in `main_files` folder. The knitted PDFs are also included for reference. They are dated and included for reference in this repository for reference. The latest and most up-to-date file is `8-25-Notebook.Rmd`.
