#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N SampleFilter
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/4_SampleFilter

##load modules
module unload python
module load dimspy

echo "Starting Sample Filter"
#Sample Filter:Filter peaks based on certain reproducibility and sample class criteria.

dimspy sample-filter \
--input ../3_BlankFilter/blankFilter.* \
--output sampleFilter.$PBS_JOB \
--min-fraction 0.8

#options to consider: --within, -rsd_threshold

echo "Sample Filter Complete"

dimspy hdf5-pm-to-txt \
--input sampleFilter.$PBS_JOB \
--output pm.sampleFilter.$PBS_JOB \
--delimiter tab  \
--attribute_name intensity \
--representation-samples columns

dimspy hdf5-pm-to-txt \
--input sampleFilter.$PBS_JOB \
--output comp.sampleFilter.$PBS_JOB \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples columns

echo "Conversions Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../5_MissingVals/
qsub RunMissingValsFilter.sh
