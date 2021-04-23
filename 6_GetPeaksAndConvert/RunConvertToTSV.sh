#!/bin/bash

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o ConvertToTSV_%j.log
#SBATCH -e ConvertToTSV_%j.err
#SBATCH --job-name=ConvertToTSV
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

echo "Starting Conversion"
#Covert to TSV: Align peaklists across samples.

dimspy hdf5-pm-to-txt \
--input ../5_MissingVals/missingVals.* \
--output convert2TSV.$SLURM_JOB_ID \
--delimiter tab \
--comprehensive \
--attribute_name 'intensity' \
--representation-samples rows

echo "Complete!"
