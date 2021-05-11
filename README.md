QIIME2 pipeline
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

> In order to extract and wrangle sequence data, please follow the
> following procedures.

#### 1. Clone QIIME2 pipeline

``` shell
git clone https://github.com/TracyRage/qiime_pipeline.git
```

Make all the `.sh` files executable

``` shell
cmod +x *.sh 
```

#### 2. Extract barcodes from raw sequences

In order to proceed with QIIME2 analysis, you need to create a metadata
`tsv` file with barcodes attributed to each sample. Given the fact, that
there’s already a `metadata.tsv` example in this repo, feel free to
modify it, and add there your sample abbreviations and barcodes.

-   Create a temporary directory in `seqs/` and decompress raw
    `*fastq.gz` files

``` shell
cd seqs/ && mkdir temporary_dir && gunzip *gz && cp *fastq temporary_dir && gzip *fastq && cd temporary_dir
```

-   [Install USEARCH](https://drive5.com/usearch/download.html)

-   Extract barcodes with USEARCH

``` shell
# Do it for each sample
touch labels.txt && usearch -fastx_getlabels YOUR_SAMPLE_NAME.fastq -output labels.txt | head -n 3 labels.txt
```

> In order to avoid redundance, extract barcodes from FORWARD sequences
> (i.e. R1)

-   Change sample names and add barcodes in `metadata.tsv`. Optionally,
    change the other metadata entries.

-   Don’t forget to properly rename your sequence files. Otherwise,
    QIIME2 won’t see them. Please, see example files in `seqs/`.

-   Rename sample, barcode and forward (R1) / reverse (R2) fields:
    <sample>\_<barcode>*L001*{R1 or R2}\_001.fastq.gz

-   If you done, please, delete example files.

#### 3. Import data in QIIME2

``` shell
bash import.sh
```

#### 4. Process data

Go to [QIIME View](https://view.qiime2.org/) and check your `demuz.qzv`
file, and decide what portion of sequnce to trim (median &gt;= 28).
Usually, default settings in `process.sh` are good enough. So, you may
ignore this step.

``` shell
bash process.sh
```

#### 5. Train sequence model

This pipeline uses GTDB database.

If you have any other primers to work with, open `training.sh` and
modify FORWARD and REVERSE variables. If not, just run the script.

``` shell
bash training.sh
```

#### Analyze your dataset

Go to [QIIME View](https://view.qiime2.org/) and check your
`feature_table.qzv` file, write down `median frequency` and
`feature count` of the sample with the fewest count number. Please open
`analyze.sh` and modify SAMPLING\_DEPTH and MEDIAN variables.

``` shell
bash analyze.sh
```

#### Conclusion

To see the bacterial distrbution, go to [QIIME
View](https://view.qiime2.org/) and check your `tax_bar_plots.qzv` file.

For further statistics / graphics generation consult
`sping_analysis.Rmd` (which is optional).
