#PBS -k oe 
#PBS -m abe
#PBS -M youremailhere@gmail.com
#PBS -N AlignSamples
#PBS -l nodes=1:ppn=3,vmem=20gb,walltime=2:00:00

##Move to correct WD
cd $PBS_O_WORKDIR
source ../samples.conf
cd $MAIN_DIR/2_AlignSamples

##load modules
module unload python
module load dimspy/2.0

echo "Starting to Align"
##Align Samples: Align peaklists across samples.

dimspy align-samples \
--input ../1b_RepFilter/RepFilter.* \
--output alignSamples.$PBS_JOB \
--ppm $PPM \
--ncpus $NCPUS

#options: --filelist, --ncpus

echo "Alignment Complete"

dimspy hdf5-pm-to-txt \
--input alignSamples.$PBS_JOB \
--output pm.alignSamples.$PBS_JOB \
--delimiter tab \
--attribute_name intensity \
--representation-samples columns

dimspy hdf5-pm-to-txt \
--input alignSamples.$PBS_JOB \
--output comp.alignSamples.$PBS_JOB \
--delimiter tab \
--comprehensive \
--attribute_name intensity \
--representation-samples columns

echo "Conversion Complete"
echo "Step Complete"

echo "Submitting Next Step"
cd ../3_BlankFilter/
qsub RunBlankFilter.sh

