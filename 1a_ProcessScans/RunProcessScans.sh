#!/bin/bash

#SBATCH -J ProcessScans
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=youremailhere@gmail.com
#SBATCH -p general
#SBATCH -o ProcessScans_%j.log
#SBATCH -e ProcessScans_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mem=20gb
#SBATCH --time=2:00:00

##Move to correct WD
cd $SLURM_SUBMIT_DIR
pwd
source ../samples.conf
cd $MAIN_DIR/1a_ProcessScans

##load modules
module unload python
module load dimspy/2.0

##Process Scans: Process scans and/or stitch SIM windows.

dimspy process-scans \
--input $INPUT_DIR \
--output process_scans.out \
--filelist $FILE_LIST \
--function-noise noise_packets \
--snr-threshold $SNR_THRESH \
--ppm $PPM \
--min_scans 3 \
--min-fraction 0.5 \
--exclude-scan-events 50.0 620.0 full \
--report $REPORT_DIR/process_scan_report.$SLURM_JOB_ID \
--ncpus $NCPUS

#optional parameters: --rds-threshold, --skip-stitching, --ncpus

echo "Processing Complete.  Converting Scans"

dimspy hdf5-pls-to-txt \
--input process_scans.out \
--output 1_ProcessScans/ \
--delimiter tab

echo "Conversion Complete"

echo "Submitting next job"
cd ../1b_RepFilter/
sbatch RunReplicateFilter.sh
