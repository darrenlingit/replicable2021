# replicable2021

Before running any of the files, download the data files from [this link](https://drive.google.com/drive/folders/1ocS_OZR1DQAM88rMR6QTN8UfvqMTGRwJ?usp=sharing). Place the folders (along with their files) into the `main_files` folder.

## Workflow
The general workflow is given below.

1. Run `.R` files in `main_files/data` to generate data based on MAMBA package. It is best if you run them as jobs in the background.

   The data files are placed into `main_files/data/mamba_data` and `main_files/data/prp_data`. It takes time to run these files so it is recommended you download them from the link above.

2. Run the `.Rmd` files located in `main_files` folder. The knitted PDFs are also included for reference.
