#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N BlankFilter
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/3_BlankFilter

##load modules
module unload python
module load dimspy

echo "Starting Blank Filter"
#Blank Filter:
#Filter peaks across samples that are present in the blank samples.

dimspy blank-filter \
--input ../2_AlignSamples/alignSamples.* \
--output blankFilter.$PBS_JOB \
--blank-label 'blank' \
--min-fraction 1.0 \
--function mean \
--min-fold-change 10.0 \
--remove-blank-samples

echo "Blank Filter Complete"

dimspy create-sample-list \
--input blankFilter.$PBS_JOB \
--output  samplelist.blankFilter.$PBS_JOB \
--delimiter tab

dimspy hdf5-pm-to-txt \
--input blankFilter.$PBS_JOB \
--output pm.blankFilter.$PBS_JOB \
--delimiter tab \
--attribute_name intensity \
--representation-samples columns

dimspy hdf5-pm-to-txt \
--input blankFilter.$PBS_JOB \
--output comp.blankFilter.$PBS_JOB \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples columns

echo "Conversion of Files Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../4_SampleFilter/
qsub RunSampleFilter.sh

