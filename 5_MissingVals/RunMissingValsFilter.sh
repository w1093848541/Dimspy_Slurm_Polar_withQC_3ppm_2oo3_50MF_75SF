#!/bin/bash

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o MissingValsFilter_%j.log
#SBATCH -e MissingValsFilter_%j.err
#SBATCH --job-name=MissingVals
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mem=20gb
#SBATCH --time=2:00:00

##Move to correct WD
cd $SLURM_SUBMIT_DIR
source ../samples.conf
cd $MAIN_DIR/5_MissingVals

##load modules
module unload python
module load dimspy

echo "Starting Missing Value Filter"
#Missing Values Sample Filter: Filter samples based on the percentage of missing values.

dimspy mv-sample-filter \
--input ../4_SampleFilter/sampleFilter.* \
--output missingVals.$SLURM_JOB_ID \
--max-fraction 0.2

echo "Missing Values Filter Complete"

dimspy create-sample-list \
--input missingVals.$SLURM_JOB_ID \
--output samplelist.missingVals.$SLURM_JOB_ID \
--delimiter tab

dimspy hdf5-pm-to-txt \
--input missingVals.$SLURM_JOB_ID \
--output pm.missingVals.$SLURM_JOB_ID \
--delimiter tab \
--attribute_name intensity \
--representation-samples rows

dimspy hdf5-pm-to-txt \
--input missingVals.$SLURM_JOB_ID \
--output comp.missingVals.$SLURM_JOB_ID \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples columns

echo "Conversions Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../6_GetPeaksAndConvert/
sbatch RunGetAvgPeaks.sh
sbatch RunConvertToTSV.sh
