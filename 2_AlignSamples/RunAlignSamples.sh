#!/bin/bash

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o AlignSamples_%j.log
#SBATCH -e AlignSamples_%j.err
#SBATCH --job-name=AlignSamples
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mem=20gb
#SBATCH --time=2:00:00

##Move to correct WD
cd $SLURM_SUBMIT_DIR
source ../samples.conf
cd $MAIN_DIR/2_AlignSamples

##load modules
module unload python
module load dimspy/2.0

echo "Starting to Align"
##Align Samples: Align peaklists across samples.

dimspy align-samples \
--input ../1b_RepFilter/RepFilter.* \
--output alignSamples.$SLURM_JOB_ID \
--ppm $PPM \
--ncpus $NCPUS

#options: --filelist, --ncpus

echo "Alignment Complete"

dimspy hdf5-pm-to-txt \
--input alignSamples.$SLURM_JOB_ID \
--output pm.alignSamples.$SLURM_JOB_ID \
--delimiter tab \
--attribute_name intensity \
--representation-samples rows

dimspy hdf5-pm-to-txt \
--input alignSamples.$SLURM_JOB_ID \
--output comp.alignSamples.$SLURM_JOB_ID \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples rows

echo "Conversion Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../3_BlankFilter/
sbatch RunBlankFilter.sh

