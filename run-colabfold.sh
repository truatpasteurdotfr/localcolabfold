#!/bin/bash
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
echo running python3.7 "$@" from conda  ${COLABFOLDDIR}/colabfold-conda env
python3.7 "$@"
else
echo "usage: singularity run --nv $0 modified-runner.py"
echo "usage: singularity run --nv $0 runner_af2advanced.py --help "
echo "wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/runner_.py"
echo "wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/runner_af2advanced.py"
fi
