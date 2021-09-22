#!/bin/bash

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o SampleFilter_%j.log
#SBATCH -e SampleFilter_%j.err
#SBATCH --job-name=SampleFilter
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mem=20gb
#SBATCH --time=2:00:00

##Move to correct WD
cd $SLURM_SUBMIT_DIR
source ../samples.conf
cd $MAIN_DIR/4_SampleFilter

##load modules
module unload python
module load dimspy

echo "Starting Sample Filter"
#Sample Filter:Filter peaks based on certain reproducibility and sample class criteria.

dimspy sample-filter \
--input ../3_BlankFilter/blankFilter.* \
--output sampleFilter.$SLURM_JOB_ID \
--min-fraction 0.85

#options to consider: --within, -rsd_threshold

echo "Sample Filter Complete"

dimspy hdf5-pm-to-txt \
--input sampleFilter.$SLURM_JOB_ID \
--output pm.sampleFilter.$SLURM_JOB_ID \
--delimiter tab  \
--attribute_name intensity \
--representation-samples rows

dimspy hdf5-pm-to-txt \
--input sampleFilter.$SLURM_JOB_ID \
--output comp.sampleFilter.$SLURM_JOB_ID \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples rows

echo "Conversions Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../5_MissingVals/
sbatch RunMissingValsFilter.sh
