#!/bin/bash
# 2021/11/15 adapted from /app/colabfold/bin/colabfold
# force bash syntax for conda
export CONDA_ROOT=/app/colabfold/conda
eval "$(${CONDA_ROOT}/bin/conda shell.bash hook)"
export COLABFOLDDIR=/app/colabfold
conda activate ${COLABFOLDDIR}/colabfold-conda
export PYTHONPATH=${COLABFOLDDIR}

if [ ! -L alphafold ]; then
echo "making alphafold -> /app/colabfold/alphafold as soft link"
ln -s /app/colabfold/alphafold
fi

if [ $# -ge 1 ]; then
echo running python3.7 ${COLABFOLDDIR}/colabfold_batch "$@" from conda  ${COLABFOLDDIR}/colabfold-conda env
python3.7 ${COLABFOLDDIR}/colabfold_batch "$@"
fi
