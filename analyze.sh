#!/bin/bash
# Header
set -e
set -u
set -o pipefail

# Sampling depth (sample with minimum count number; see feature-table.qzv)
SAMPLING_DEPTH=1
# Median count frequency (median count number; see feature-table.qzv)
MEDIAN=144

# DO NOT MODIFY VARIABLES BELOW
# Path to table.qza
TABLE_QZA=output/qza/table.qza
# Path to taxonomy.qza
TAX_QZA=training/taxonomy.qza
# Path to collapsed taxa table
COLLAPSED=output/qza/collapsed-table.qza
# Path to metadata file
METADATA=metadata.tsv
# Path to barplots
BARPLOT=output/qzv/taxa-bar-plots.qzv
# Path rep-seqs.qza
REP_SEQS=output/qza/rep-seqs.qza
# Path to aligned rep-seqs
ALIGN_REP=output/qza/aligned-rep-seqs.qza
# Path to masked alignment
MASKED=output/qza/masked-aligned-rep-seqs.qza
# Path to unrooted tree
UNROOT=output/qza/unrooted-tree.qza
# Path to rooted tree
ROOT=output/qza/rooted-tree.qza
# Path to core metrics
CORE_METRIC=output/core-metrics-results
# Path to rarefaction plot
RAREFACTION=output/qzv/alpha-rarefaction.qzv

# Taxa collapse
qiime taxa collapse \
  --i-table "$TABLE_QZA" \
  --i-taxonomy "$TAX_QZA" \
  --p-level 5 \
  --o-collapsed-table "$COLLAPSED"

# Taxa barplot and heatmap
qiime taxa barplot \
  --i-table "$TABLE_QZA" \
  --i-taxonomy "$TAX_QZA" \
  --m-metadata-file "$METADATA" \
  --o-visualization "$BARPLOT"

# Phylogenetic diversity
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences "$REP_SEQS" \
  --o-alignment "$ALIGN_REP" \
  --o-masked-alignment "$MASKED" \
  --o-tree "$UNROOT" \
  --o-rooted-tree "$ROOT"

# Alpha and beta diversity generation (Sample with minimum sequnce count)
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny "$ROOT" \
  --i-table "$TABLE_QZA" \
  --p-sampling-depth "$SAMPLING_DEPTH" \
  --m-metadata-file "$METADATA" \
  --output-dir "$CORE_METRIC"

# Rarefaction curb generation (Median frequency)
qiime diversity alpha-rarefaction \
  --i-table "$TABLE_QZA" \
  --i-phylogeny "$ROOT" \
  --p-max-depth "$MEDIAN" \
  --m-metadata-file "$METADATA" \
  --o-visualization "$RAREFACTION"
