#!/bin/bash
# Header
set -e
set -u
set -o pipefail

# Path to raw sequences
FASTQ=seqs/

# DO NOT MODIFY VARIABLES BELOW
# Path to demux.qza
DEMUX_QZA=output/qza/demux.qza
# Path to demux.qzv
DEMUX_QZV=output/qzv/demux.qzv

# Import fastq files
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path "$FASTQ" \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path "$DEMUX_QZA"

# Summary of demultiplexing results (sequences per sample and sequence quality)
qiime demux summarize \
  --i-data "$DEMUX_QZA" \
  --o-visualization "$DEMUX_QZV"
