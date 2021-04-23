#!/bin/bash

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o ReplicateFilter_%j.log
#SBATCH -e ReplicateFilter_%j.err
#SBATCH --job-name=ReplicateFilter
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mem=100gb
#SBATCH --time=20:00

##Move to correct WD
cd $SLURM_SUBMIT_DIR
source ../samples.conf
cd $MAIN_DIR/1b_RepFilter

##load modules
module unload python
module load dimspy/2.0

echo "Starting filtering"
##Replicate Filter: Filter irreproducible peaks from technical replicate peaklists.

dimspy replicate-filter \
--input ../1a_ProcessScans/process_scans.out \
--output RepFilter.$SLURM_JOB_ID \
--ppm $PPM \
--replicates $REPLICATES \
--min-peak-present 3 \
--report $REPORT_DIR/RepFilterReport.$SLURM_JOB_ID \
--ncpus $NCPUS

#other options to consider: --rsd_threshold, --filelist, --report
echo "Filtering complete, begin conversion of files"

#Create a sample list from a peak matrix object or list of peaklist objects.
dimspy create-sample-list \
--input RepFilter.$SLURM_JOB_ID \
--output SampleList.RepFilter.$SLURM_JOB_ID \
--delimiter tab 

echo "Creation of sample list complete"

#Write HDF5 output (peak lists) to text format.
dimspy hdf5-pls-to-txt \
--input RepFilter.$SLURM_JOB_ID \
--output . \
--delimiter tab 

echo "Peak lists output complete"
echo "Job complete"

echo "Submitting next step"
cd ../2_AlignSamples/
sbatch RunAlignSamples.sh
