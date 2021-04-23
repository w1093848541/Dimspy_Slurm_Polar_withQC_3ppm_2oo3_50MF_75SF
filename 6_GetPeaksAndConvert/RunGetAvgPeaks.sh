#!/bin/bash

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o GetAvgPeaks_%j.log
#SBATCH -e GetAvgPeaks_%j.err
#SBATCH --job-name=AvgPeaks
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mem=20gb
#SBATCH --time=2:00:00

##Move to correct WD
cd $SLURM_SUBMIT_DIR
source ../samples.conf
cd $MAIN_DIR/6_GetPeaksAndConvert

##load modules
module unload python
module load dimspy

echo "Getting Average Peaklists"

#Get Average Peaklist: Get an average peaklist from a peak matrix object.
dimspy get-peaklists \
--input ../5_MissingVals/missingVals.* \
--output PeaksList.$SLURM_JOB_ID

dimspy get-average-peaklist \
--name-peaklist 'NAME' \
--input ../5_MissingVals/missingVals.* \
--output Avg.PeaksList.$SLURM_JOB_ID

echo "Peaks and Average Peaks Complete"

dimspy hdf5-pls-to-txt \
--input PeaksList.$SLURM_JOB_ID \
--output ./peakslist \
--delimiter tab

dimspy hdf5-pls-to-txt \
--input Avg.PeaksList.$SLURM_JOB_ID \
--output . \
--delimiter tab

echo "Conversions Complete"
echo "Step Complete"

