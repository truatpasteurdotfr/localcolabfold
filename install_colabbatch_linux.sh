#!/bin/bash

type wget || { echo "wget command is not installed. Please install it at first using apt or yum." ; exit 1 ; }
type curl || { echo "curl command is not installed. Please install it at first using apt or yum. " ; exit 1 ; }

CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/localcolabfold"

mkdir -p ${COLABFOLDDIR}
cd ${COLABFOLDDIR}
wget -q -P . https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p ${COLABFOLDDIR}/conda
rm Miniconda3-latest-Linux-x86_64.sh
. "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda create -p $COLABFOLDDIR/colabfold-conda python=3.9 -y
conda activate $COLABFOLDDIR/colabfold-conda
conda update -n base conda -y
conda install -c conda-forge python=3.9 cudnn==8.2.1.32 cudatoolkit==11.1.1 openmm==7.5.1 pdbfixer -y
# Download the updater
wget -qnc https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_linux.sh --no-check-certificate
chmod +x update_linux.sh
# install alignment tools

conda install -c conda-forge -c bioconda kalign3=3.2.2 hhsuite=3.3.0 -y
# Tru: possible missing chardet 2022/03/07 (place holder from previous version)
# conda install chardet  -y
# cleanup
conda clean --all --yes

# install ColabFold and Jaxlib
# colabfold-conda/bin/python3.9 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
colabfold-conda/bin/python3.9 -m pip install --upgrade pip
colabfold-conda/bin/python3.9 -m pip install --no-warn-conflicts "colabfold[alphafold-minus-jax] @ git+https://github.com/sokrypton/ColabFold"
colabfold-conda/bin/python3.9 -m pip install https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.3.25+cuda11.cudnn82-cp39-cp39-manylinux2014_x86_64.whl
colabfold-conda/bin/python3.9 -m pip install jax==0.3.25 biopython==1.79


# bin directory to run
mkdir -p $COLABFOLDDIR/bin
cd $COLABFOLDDIR/bin
cat << EOF > colabfold_batch
#!/bin/bash
export TF_FORCE_UNIFIED_MEMORY="1"
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"
export COLABFOLDDIR=$COLABFOLDDIR
export PATH="\${COLABFOLDDIR}/colabfold-conda/bin:\$PATH"
\$COLABFOLDDIR/colabfold-conda/bin/colabfold_batch \$@
EOF
chmod +x colabfold_batch

# Use 'Agg' for non-GUI backend
cd ${COLABFOLDDIR}/colabfold-conda/lib/python3.9/site-packages/colabfold
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
# modify the default params directory
sed -i -e "s#appdirs.user_cache_dir(__package__ or \"colabfold\")#\"${COLABFOLDDIR}/colabfold\"#g" download.py
# remove cache directory
rm -rf __pycache__

# start downloading weights
cd ${COLABFOLDDIR}
colabfold-conda/bin/python3.9 -m colabfold.download
cd ${CURRENTPATH}

echo "Download of alphafold2 weights finished."
echo "-----------------------------------------"
echo "Installation of colabfold_batch finished."
echo "Add ${COLABFOLDDIR}/colabfold-conda/bin to your environment variable PATH to run 'colabfold_batch'."
echo "i.e. For Bash, export PATH=\"${COLABFOLDDIR}/colabfold-conda/bin:\$PATH\""
echo "For more details, please type 'colabfold_batch --help'."

