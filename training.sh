#!/bin/bash
# Header
set -e
set -u
set -o pipefail

# Forward primer
FORWARD=CAGCMGCCGCGGTAA
# Reverse primer
REVERSE=TACNVGGGTATCTAATCC

# DO NOT MODIFY VARIABLES BELOW
# Path to clean GTDB sequences
GTDB_DB=training/raw_db/clean_seqs_filt.qza
# Path to reference GTDB taxonomy
REF_TAX=training/raw_db/gtdb_tax.qza
# Path to reference sequences
REF_SEQS=training/ref-seqs.qza
# Path to rep-seqs.qza
REP_SEQS=output/qza/rep-seqs.qza
# Path to dereplicated sequences
DEREP_SEQS=training/dereplicated-seqs.qza
# Path to dereplicated taxa
DEREP_TAXA=training/dereplicated-taxa.qza
# Path to classifier
CLASSIFIER=training/classifier.qza
# Path to taxonomy.qza
TAX_QZA=training/taxonomy.qza
# Path to taxonomy.qzv
TAX_QZV=training/taxonomy.qzv

# Extract the sequence of interest (run In-Silico PCR)
qiime feature-classifier extract-reads \
   --i-sequences "$GTDB_DB" \
   --p-f-primer "$FORWARD" \
   --p-r-primer "$REVERSE" \
   --p-max-length 400 \
   --p-trunc-len 300 \
   --p-min-length 200 \
   --o-reads "$REF_SEQS"

# Dereplicate extracted region
qiime rescript dereplicate \
  --i-sequences "$REF_SEQS" \
  --i-taxa "$REF_TAX" \
  --p-rank-handles 'gtdb' \
  --p-mode 'uniq' \
  --o-dereplicated-sequences "$DEREP_SEQS" \
  --o-dereplicated-taxa "$DEREP_TAXA"

# Train the classifier
qiime feature-classifier fit-classifier-naive-bayes \
   --i-reference-reads "$DEREP_SEQS" \
   --i-reference-taxonomy "$DEREP_TAXA" \
   --o-classifier "$CLASSIFIER"

# Test the classifier
qiime feature-classifier classify-sklearn \
  --i-classifier "$CLASSIFIER" \
  --i-reads "$REP_SEQS" \
  --o-classification "$TAX_QZA"

qiime metadata tabulate \
 --m-input-file "$TAX_QZA" \
 --o-visualization "$TAX_QZV"

# Archaea primers
# --p-f-primer CAGYMGCCRCGGKAAHACC \
# --p-r-primer GGACTACNNGGGTATCTAAT \
