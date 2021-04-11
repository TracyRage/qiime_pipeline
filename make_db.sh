#!/bin/bash
# Header
set -e
set -u
set -o pipefail

# Path to GTDB fasta file
GTDB_FA=training/raw_db/bac120_ssu_reps_r95.fna
# Path to GTDB taxonomy table
GTDB_TAX=training/raw_db/bac120_taxonomy.tsv
# Indicate domain of interest (Bacteria or Archaea)
DOMAIN=Bacteria
# Indicate the length of the 16S gene
# Bacteria (1200) and Archaea (900)
LENGTH=1200

# DO NOT MODIFY VARIABLES BELOW
# Path to imported gtdb dababase
RAW_DB=training/raw_db/gtdb_seqs.qza
# Path to imported gtdb database
RAW_TAX=training/raw_db/gtdb_tax.qza
# Path to gtdb high quality seqs database
DB=training/raw_db/clean_seqs.qza
# Path to filtered gtdb database
FILTERED_DB=training/raw_db/clean_seqs_filt.qza
# Path to discarded sequences
DISCARDED=training/raw_db/discarded_seqs.qza

# Import sequence database (GTDB)
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path "$GTDB_FA" \
  --output-path "$RAW_DB"

# Import taxonomy file (GTDB)
qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path "$GTDB_TAX" \
  --output-path "$RAW_TAX"


# Cull low-quality sequences
qiime rescript cull-seqs \
  --i-sequences "$RAW_DB" \
  --o-clean-sequences "$DB"

# Filter sequences by length and taxonomy (change label and min-len)
qiime rescript filter-seqs-length-by-taxon \
  --i-sequences "$DB" \
  --i-taxonomy "$RAW_TAX" \
  --p-labels "$DOMAIN" \
  --p-min-lens "$LENGTH" \
  --o-filtered-seqs "$FILTERED_DB" \
  --o-discarded-seqs "$DISCARDED"
