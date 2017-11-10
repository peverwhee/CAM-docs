.. _atmospheric-configurations:

**************************************
Atmospheric configurations (compsets)
**************************************

There are a number of atmospheric models which can run within CESM.  While CAM is the basic atmospheric model within CESM, there are several models with significant extensions to CAM which may also be run within CESM.  The available atmospheric models in CESM2 are:

- **CAM**:  Community Atmosphere Model
- **CAM-chem**: Community Atmosphere Model with Chemistry  
- **WACCM**: Whole Atmosphere Community Climate Model
- **WACCM-X**: Whole Atmosphere Community Climate Model with thermosphere and ionosphere extension

Each of these models have a number of atmospheric configurations provided to run them.  These component sets known as **compsets** are used to supply both configure and namelist settings for predefined experiments.

The predefined compsets exist with one of three levels of support.

- **Scientifically supported**:  Specific compset/resolution pairs which have had significant, multi-year runs made and have been studied scientifically.  It is important to note that resolutions which are not listed, are not scientifically supported, have not had tunings performed and should not be used for scientific studies without careful examination of the results.
- **Tested**: One or more tests for this compset have been made using at least one resolution.  Extensive scientific study has not been performed.  The designation of "Tested" simply acknowledges that one or more compset/resolution pair(s) have been confirmed to run without crashing.  No attempts have been made to validate the scientific quality of these runs and tunings have NOT been performed on them.
- **Unsupported**:  These compsets are setup as a "convenience" for various reasons and they are not supported for science runs.  If a user decides to use one of these compsets, they must also supply the --run-unsupported flag to create_newcase.  These compsets may not even compile and run successfully as they have not been tested.

A complete listing of all compsets is found `here <http://www.cesm.ucar.edu/models/cesm2.0/cesm/compsets.html>`_

This chapter will only discuss the **scientifically supported** compsets.

-------------------------------------------------------------------------------
CAM compsets
-------------------------------------------------------------------------------
CAM compsets include the F, PORT and Q compsets.

- **F**: CAM standalone runs, using an active Land and everything else is prognostic
- **P**: Parallel offline radiation tool (PORT)
- **Q**: Aquaplanet with either prescribed ocean (QP) or slab ocean(QS)

**Scientifically supported CAM compsets**

+--------------+----------------------+-----------------------------------------+-------------+
| Compset Name | supported resolution |Description                              | Period      |
+==============+======================+=========================================+=============+
| FHIST        | f09_f09_mg17         | Historical current developer            | 1979 to 2015|
|              |                      | setup (CAM6) *[Note - this is similar   |             |
|              |                      | to the obsolete CAM5 FAMIP compset]*    |             |
+--------------+----------------------+-----------------------------------------+-------------+
| F2000climo   | f09_f09_mg17         | Climatological 21st century             | 2000 to 2015|
+--------------+----------------------+-----------------------------------------+-------------+


It should be noted that a number of CAM4 and CAM5-specific compsets have been eliminated from the CAM6 release.  The rationale behind this is that due to changes in code and namelist settings, a user is unable to numerically reproduce CAM4 or CAM5 runs similar to what they would get running CESM1.2. It is recommended that if a user wants to make a true CAM4 or CAM5 run, that they do so using CESM1.2 instead of CESM2.0.


-------------------------------------------------------------------------------
CAM-chem compsets
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
WACCM compsets
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
WACCM-X compsets
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
Simple Models
-------------------------------------------------------------------------------

There are several simpler configurations in which CAM can be run.  These include:
 - Aquaplanet (QP and QS compsets)
 - PORT - Parallel Offline Radiation Tool (P compsets)
 - SCAM - single column model (FSCAM compset)

====================================================================================
CAM aquaplanet (QP and QS compsets)
====================================================================================

(Describe what aquaplanet is and why it is useful)

########################################################################################
Example:  Running an aquaplanet run
########################################################################################

########################################################################################
Example:  Modifying an aquaplanet run
########################################################################################

====================================================================================
CAM Parallel Offline Radiation Tool (PORT - P compsets)
====================================================================================
PORT is used as part of the process for computing radiative forcing and instantaneous radiative forcing.  For effective radiative forcing please see the documentation related to F-case runs.

PORT uses instantaneous samples of the model state to compute the radiative fluxes and heating rates through the atmosphere.  This computation does not include middle and upper atmospheric radiative transfer as implemented in WACCM.  The only prognostic variable is temperature, in the specific PORT configuration to compute radiative forcing that includes the stratospheric adjustment (fixed dynamical heating).

##########################################################################
**STILL BEING EDITED** Example: Verifying a PORT setup
##########################################################################

- Run CESM 9 timesteps outputting in addition to rad, FLNT,FSNT, etc.
- Run PORT using the h1 file - need to output every timestep
- Compare FLNT from step 1 and step 2  (BFB comparison)

##########################################################################
Example: Using PORT to study flux differences due to 4 x CO2
##########################################################################

There are typically three stages to computing radiative forcing

Extracting samples of CESM state

Set up the **user_nl_cam** file
::

 ! Output the radiation data
 rad_data_output=.true.

 ! Specify the radiation data be written to histfile number 2 (rad_data will be in files with cam.h1 in their name)
 rad_data_histfile_num=2
 
 ! Write out the instantaneous rad_data
 rad_data_avgflag='I'
 
 ! Add back in the fields for the output
 fincl1 = 'SOLIN', 'QRS', 'FSNS', 'FSNT','FSNSC', 'FSDSC','FSNR','FLNR',
          'FSNTOA', 'FSUTOA', 'FSNTOAC', 'FSNTC', 'FSDSC', 'FSDS', 'SWCF',
          'QRL', 'FLNS', 'FLDS', 'FLNT', 'LWCF', 'FLUT' ,'FLUTC', 'FLNTC',
          'FLNSC', 'FLDSC'
 
 fincl2 = 'SOLIN', 'QRS', 'FSNS', 'FSNT','FSNSC', 'FSDSC','FSNR','FLNR',
          'FSNTOA', 'FSUTOA', 'FSNTOAC', 'FSNTC', 'FSDSC', 'FSDS', 'SWCF',
          'QRL', 'FLNS', 'FLDS', 'FLNT', 'LWCF', 'FLUT' ,'FLUTC', 'FLNTC',
          'FLNSC', 'FLDSC'
 
 ! Write out every timestep
 nhtfrq=1

:: 

 % ./create_newcase --case test_PORT_setup_orig --res f09_f09_mg17 --compset FHIST_DEV
 % cd test_PORT_setup_orig

 - Using PORT to compute fluxes and heating rates on the extracted samples
 - Using PORT to compute fluxes and heating rates on modifications of the extracted samples

Radiative Forcing is defined as the difference between the top of atmosphere fluxes computed in stages 2 and 3 above.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step 1:  Extracting CESM state for use in PORT.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A user first needs to set up a run from which the radiation data will be extracted.  In this example, we will use the F2000_DEV compset, but any configuration of CAM may be used, dependent on what the user wishes to study.
::

 % ./create_newcase --case test_forPORT --res f09_f09_mg17 --compset F2000_DEV
 % cd test_forPORT
 
To output the radiation data, the **user_nl_cam** needs to contain the following settings.
::

 ! Output the radiation data
 rad_data_output=.true.

 ! Specify the radiation data be written to histfile number 2 (rad_data will be in files with cam.h1 in their name)
 rad_data_histfile_num=2

 ! Write out the instantaneous rad_data
 rad_data_avgflag='I'


For this test, the user needs to complete the setup/build process and run for at least 16 months.  For a simple verification test, the times can be as short as 9 timesteps.
::

 % ./case.setup
 % ./xmlchange STOP_N=16
 % ./xmlchange STOP_OPTION=nmonths
 % ./case.build
 % ./case.submit

After your job completes, you will have a number of files, including ones with filenames containing "cam.h1".  The "cam.h1" files contain the radiation history which was specified by the namelist and will be used in the next step.  

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step 2:  Compile and run PORT on extracted radiation data
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Configure CESM to construct the PORT executable by running the offline radiation tool.  A new case needs to be created for this step and it will use the special CAM6 PORT compset, PC6
::

 % ./create_newcase --case test_PORT_run_orig --res f09_f09_mg17 --compset PC6
 % cd test_PORT_run_orig

Create a file that contains the full filepaths to all of the h1 files created in step 1.  Setup the namelist in **user_nl_cam** and have it use the fileslist
::

 ! Use the radiation with the latest date (has cam.h1 in the name)
 offline_driver_fileslist='/fullpath/fileslist_orig'
 
 ! turn on Fixed Dynamical Heating in the offline radiation tool (PORT)
 rad_data_fdh=.true.

Compile and submit this run of the original data
::

 % ./case.setup
 % ./xmlchange STOP_N=16
 % ./xmlchange STOP_OPTION=nmonths
 % ./case.build
 % ./case.submit

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step 3:  Create file with 4xCO2 and compile and run PORT using this new file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a variation to the input files to study the effects the variation has on radiation.  In this case we are quadrupling the CO2 and modifying this via the netcdf utility, ncap for each file.  Further documentation on ncap can be found in the `NCO User Guide <http://nco.sourceforge.net/nco.html>`_.
::

  %ncap -s "rad_co2=4*rad_co2" extracted_file.nc extracted_file_with_quadrupled_co2.nc

Repeat the same setup that you did in Step 2 with a different case name, creating a new list with the modified files and putting this new fileslist in **user_nl_cam**
::

 % ./create_newcase --case test_PORT_run_4xCO2 --res f09_f09_mg17 --compset PC6
 % cd test_PORT_run_4xCO2
 
Setup the namelist in **user_nl_cam** and have it use the file generated in the previous example
::

 ! Use the radiation with the latest date (has cam.h1 in the name)
 offline_driver_fileslist='/fullpath/fileslist_4XCO2'
 
 ! turn on Fixed Dynamical Heating in the offline radiation tool (PORT)
 rad_data_fdh=.true.

Compile and submit this run with the modified data
::

 % ./case.setup
 % ./xmlchange STOP_N=16
 % ./xmlchange STOP_OPTION=nmonths
 % ./case.build
 % ./case.submit

Differencing the resulting output files with those from Example 2 provides the forcing as well as changes in heating rates.

===============================================================================
CAM single column (FSCAM compset)
===============================================================================

SCAM cases are set up for a small set of different locations/dates, called an Intensive Observing Period (IOP) (see XXXX for more information).  Each of these IOP's have separate preconfigured settings which are referenced by create_new_case using the --user-mods-dir flag. 

The list of the available configurations and the associated usermods_dirs directory are:

 -  **ARM95**: scam_arm95
 -  **ARM97**: scam_arm97 -- *default*
 -  **GATEIII**: scam_gateIII
 -  **MPACE**: scam_mpace
 -  **SPARTICUS**: scam_sparticus
 -  **TOGAII**: scam_togaII
 -  **TWP06**: scam_twp06
 -  Mandatory settings: scam_mandatory (used by all SCAM runs, and not to be modified by the user)

#########################################################################################
Example:  Setting up a SCAM run
#########################################################################################
Users specify the directory containing the specifications for running an IOP using the --user-mods-dir flag.  In this example we are using the MPACE IOP.  Note that the default settings are to run for all of the observations within the IOP, but a user may shorten that by issuing an xmlchange for the STOP_N setting.  In this example we will limit the run to 600 timesteps
::

	% cd cime/scripts
	% ./create_newcase --case test_scam_mpace --compset FSCAM --res T42_T42 --user-mods-dir ../../components/cam/cime_config/usermods_dirs/scam_mpace
	% cd test_scam_mpace
	% ./case.setup
	% ./xmlchange STOP_N=600
	% ./case.build
	% ./case.submit

If user neglects to specify a --use-mods-dir, then it defaults to a shortened run of ARM97.
 
#########################################################################################
Example:  Efficient way to cycle over several SCAM IOP locations
#########################################################################################
While a user can use the above directions for running multiple IOP's, rebuilding the executable for each IOP is time-consuming and unnecessary as the same executable may be used for multiple IOP's.  A more efficient way to run over several IOP's is to use create_newcase using the scam_mandatory setup and then using create_clone for all SCAM IOP's.  This example, will make runs for TWP06 and SPARTICUS by running create_newcase using the setup in scam_mandatory and then using create_clone for test_scam_twp06 and test_scam_sparticus.  Note the addition of the flag --keepexe on the create_clone command to indicate that the executable will be used from the test_scam_mandatory case.
::

        % cd cime/scripts
        % ./create_newcase --case test_scam_mandatory --compset FSCAM --res T42_T42 --user-mods-dir ../../components/cam/cime_config/usermods_dirs/scam_mandatory
        % cd test_scam_mandatory
        % ./case.setup
        % ./case.build

        % cd ..
        % ./create_clone --case test_scam_twp06 --clone test_scam_mandatory --user-mods-dir ../../components/cam/cime_config/usermods_dirs/scam_twp06 --keepexe
        % cd test_scam_twp06
        % ./case.submit

        % cd ..
        % ./create_clone --case test_scam_sparticus --clone test_scam_mandatory --user-mods-dir ../../components/cam/cime_config/usermods_dirs/scam_sparticus --keepexe
        % cd test_scam_sparticus
        % ./case.submit

