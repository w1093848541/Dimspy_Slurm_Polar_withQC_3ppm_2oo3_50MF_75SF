#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N MissingVals
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/5_MissingVals

##load modules
module unload python
module load dimspy

echo "Starting Missing Value Filter"
#Missing Values Sample Filter: Filter samples based on the percentage of missing values.

dimspy mv-sample-filter \
--input ../4_SampleFilter/sampleFilter.* \
--output missingVals.$PBS_JOB \
--max-fraction 0.8

echo "Missing Values Filter Complete"

dimspy create-sample-list \
--input missingVals.$PBS_JOB \
--output samplelist.missingVals.$PBS_JOB \
--delimiter tab

dimspy hdf5-pm-to-txt \
--input missingVals.$PBS_JOB \
--output pm.missingVals.$PBS_JOB \
--delimiter tab \
--attribute_name intensity \
--representation-samples columns

dimspy hdf5-pm-to-txt \
--input missingVals.$PBS_JOB \
--output comp.missingVals.$PBS_JOB \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples columns

echo "Conversions Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../6_GetPeaksAndConvert/
qsub RunGetAvgPeaks.sh
qsub RunConvertToTSV.sh
