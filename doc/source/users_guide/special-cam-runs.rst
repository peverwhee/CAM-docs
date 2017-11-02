.. _special-cam-runs:

************************************
Special CAM configurations
************************************

There are several special configurations in which CAM can be run.  These include:
 - SCAM - single column model (FSCAM compset)
 - Aquaplanet (QP and QS compsets)
 - PORT - Parallel Offline Radiation Tool (P compsets)

-------------------------------------------------------------------------------
CAM single column (FSCAM compset)
-------------------------------------------------------------------------------

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

====================================================================================
Example:  Setting up a SCAM run
====================================================================================
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
 
====================================================================================
Example:  Efficient way to cycle over several SCAM IOP locations
====================================================================================
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

-------------------------------------------------------------------------------
CAM aquaplanet (QP and QS compsets)
-------------------------------------------------------------------------------

(Describe what aquaplanet is and why it is useful)

====================================================================================
Example:  Running an aquaplanet run
====================================================================================
====================================================================================
Example:  Modifying an aquaplanet run
====================================================================================
-------------------------------------------------------------------------------
CAM Parallel Offline Radiation Tool (PORT - P compsets)
-------------------------------------------------------------------------------

(Describe what PORT is and why it is useful)

====================================================================================
Example:  Running PORT
====================================================================================
