#!/bin/bash

set -o pipefail
set -e
set -u

rename_q () {
    mv "$4" "${1}_${2}_L001_${3}_001.fastq.gz"

}


rename_q "$1" "$2" "$3" "$4"
