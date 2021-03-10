#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N ConvertToTSV
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/6_GetPeaksAndConvert

##load modules
module unload python
module load dimspy

echo "Starting Conversion"
#Covert to TSV: Align peaklists across samples.

dimspy hdf5-pm-to-txt \
--input ../5_MissingVals/missingVals.* \
--output convert2TSV.$PBS_JOB \
--delimiter tab \
--comprehensive \
--attribute_name 'intensity' \
--representation-samples columns

echo "Complete!"
