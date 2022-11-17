#!/bin/bash
# 2022/11/15 adapted from https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_linux.sh
# colabfold_batch
export CONDA_ROOT=/app/colabfold_batch/conda
eval "$(${CONDA_ROOT}/bin/conda shell.bash hook)"
export COLABFOLDDIR=/app/colabfold_batch
conda activate ${COLABFOLDDIR}/colabfold-conda
export PYTHONPATH=${COLABFOLDDIR}

export TF_FORCE_UNIFIED_MEMORY="1"
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"
export PATH="${COLABFOLDDIR}/colabfold-conda/bin:$PATH"

echo running ${COLABFOLDDIR}/colabfold_batch "$@" from conda  ${COLABFOLDDIR}/colabfold-conda env
${COLABFOLDDIR}/bin/colabfold_batch "$@"


