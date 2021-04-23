#This file allows you to run this step if it does not launch directly as others.  This is a temporary patch until I can figure out why it is not launching properly.

##Move to correct WD
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
--representation-samples columns

echo "Complete!"
