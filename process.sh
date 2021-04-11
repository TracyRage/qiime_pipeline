#!/bin/bash
# Header
set -e
set -u
set -o pipefail

# DO NOT MODIFY VARIABLES BELOW
# Path to demux.qza
DEMUX=output/qza/demux.qza
# Path to table.qza
TABLE_QZA=output/qza/table.qza
# Path to representative sequences
REP_SEQS=output/qza/rep-seqs.qza
# Path to denoising statistics
DENOISE_STAT=output/qza/denoising-stats.qza
# Path to feature table
FEATURE_TAB=output/qzv/feature_table.qzv
# Path to metadata file
METADATA=metadata.tsv
# Path to feature representative seqs
FEATURE_SEQS=output/qzv/feature_rep-seqs.qzv
# Path to denoising stats qzv
DENOISE_QZV=output/qzv/denoising-stats.qzv

# Based on the quality of sequences modify trim/trunc arguments
# Filtering and ASV generation
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs "$DEMUX" \
  --p-trim-left-f 15 \
  --p-trim-left-r 5 \
  --p-trunc-len-f 250 \
  --p-trunc-len-r 213 \
  --o-table "$TABLE_QZA" \
  --o-representative-sequences "$REP_SEQS" \
  --o-denoising-stats "$DENOISE_STAT"

# FeatureTable[Frequency] summarized
qiime feature-table summarize \
  --i-table "$TABLE_QZA" \
  --o-visualization "$FEATURE_TAB" \
  --m-sample-metadata-file "$METADATA"

# FeatureData[Sequence] summarized
qiime feature-table tabulate-seqs \
  --i-data "$REP_SEQS" \
  --o-visualization "$FEATURE_SEQS"

# Denoising stats
qiime metadata tabulate \
  --m-input-file "$DENOISE_STAT" \
  --o-visualization "$DENOISE_QZV"
