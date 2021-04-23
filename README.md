## Welcome to the NCGAS workflow conversion for dimspy!

**1. Setting up your email**

Please set up your email address.  You can do this for all jobs at once by running:

`find . -name Run* -exec sed -i 's/youremailhere@gmail.com/EMAIL/g' {} \;`

where EMAIL is your email address.

what this command means:
* find		software to find files matching a pattern
* .		search within this entire folder and all subfolders
* -name Run*	search for files with names that begin with "Run", which is what I name 
		all the job scripts.
* -exec		run this command for each file found
* sed -i		sed is a program to find and replace text, -i makes it write in place
* 's/A/B/g'	substitute A for B throughout the file
* {} \;		the found file names will be replaced here

So, this line is replacing all instances of "youremailhere@gmail.com" with your actual email!

**2. Please link your input file directory**

`ln -s /location/of/your/data input_data`

where /location/of/your/data is the location of your data.  This can be found by navigating to the 
folder with your data, and typing pwd, then enter.  Then navigate back to the dimspy directory and run the ln.
You MUST be in the dimspy folder when you run this command!

This will create a shortcut to your raw files in a directory that the workflow will find.  Make sure
you have a file named filename.txt in this folder that describes the files as before.

**3. Check the samples.conf file!**

This is the set up file for the jobs.  The first couple lines require full paths - please update these
to match where you are running the data.  Running the command "pwd" in the same directory as samples.conf
will give you the full path for your current location.

This file also allows you to edit different parameters that are used across the jobs at once. So if 
you have more replicates, make sure to change that line.  If you want to adjust the ppm setting,
change that line.  These will be referenced by each job, so changes here will change across the full
workflow.

**4. Run it!**

After your email is entered, your input data is linked in, and you have set up the config file, 
you are ready to run! Simply do the following:

`cd 1a_ProcessScans`

`sbatch RunProcessScans.sh`

This will output a report to the reports folder, and automatically launch subsequent jobs.  You can 
restart the pipeline at any point by going to the desired step's directory and submitting the job in 
that folder.  It will then re-run all steps starting at that point automatically.

If you have questions, please feel free to email help@ncgas.org!




---
WRITTEN 2021 by Sheri Sanders

