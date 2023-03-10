#!/bin/bash
# run-localcolabfold.sh
export CONDA_ROOT=/app/localcolabfold/conda
eval "$(${CONDA_ROOT}/bin/conda shell.bash hook)"
export COLABFOLDDIR=/app/localcolabfold
conda activate ${COLABFOLDDIR}/colabfold-conda
export PYTHONPATH=${COLABFOLDDIR}

export TF_FORCE_UNIFIED_MEMORY="1"
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"
export PATH="${COLABFOLDDIR}/colabfold-conda/bin:$PATH"

echo "environment setup completed"
echo "running $@"
"$@"


