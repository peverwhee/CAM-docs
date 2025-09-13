.. _ug70-customizing-compsets:

********************
Customizing CAM runs
********************

Compsets are used to set up standard runs of CAM.  Sometimes though it is
necessary to customize a run.  The most common way to do this is to start
with a compset that provides a configuration which is close to what is
needed, and then apply the appropriate modifications.  It is, however, also
possible to define an entirely new compset.  We won't discuss that expert
option (which requires source code modifications) in this guide, but more
information can be found in the CIME documentation `creating new compsets
<http://esmci.github.io/cime/versions/cesm2.2/html/users_guide/compsets.html#creating-new-compsets>`__.

.. caution::

  Users need to be careful when modifying CAM's configuration and namelists
  as it is very easy to create an invalid run.  There may be dependencies
  between the build configuration and the namelist settings.  An example
  would be with the ``-nlev`` configuration setting.  Input files specified
  in the namelist may dependent on this setting and may not exist for the
  requested dynamics/nlev combination.

=================================
Modifying the build configuration
=================================

CAM build configurations are set up by its ``configure`` utility (see
:ref:`The configure utility <ug70-configure-utility>` for a complete
listing of the command-line arguments).  The CIME interface to CAM's
``configure`` is the ``$COMP_ROOT_DIR_ATM/cime_config/buildcpp`` script
(``COMP_ROOT_DIR_ATM`` contains the root directory of the CAM source code).
``buildcpp`` makes use of the CIME variable ``CAM_CONFIG_OPTS`` to pass
arguments that determine the physics, chemistry, and whether the model is
running in WACCM/X mode to ``configure``.  This variable is initially set
by ``create_newcase`` to contain values determined by the compset
definition.  ``CAM_CONFIG_OPTS`` can be modified by making use of the
``xmlchange`` utility.  ``xmlchange`` can either replace the settings
determined by the compset, or it can supplement them by using its
``--append`` option.  More information can be found in the `xmlchange
<http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/xmlchange.html>`__
documentation.
 
It is advised that before modifying ``CAM_CONFIG_OPTS``, the value set by
the compset should be known, e.g., from the case directory issue the
command:
::

  % ./xmlquery CAM_CONFIG_OPTS

.. attention::

   Changes to ``CAM_CONFIG_OPTS`` must be made before ``case.build`` is
   run.


=============================
Changing CAM namelist options
=============================

CAM's runtime behavior is controlled via reading its namelist.  The
namelist is written by CAM's ``build-namelist`` utility (see :ref:`The
build-namelist utility <ug70-build-namelist-utility>` for details). The
CIME interface to ``build-namelist`` is the
``$COMP_ROOT_DIR_ATM/cime_config/buildnml`` script.  ``buildnml``
constructs the ``build-namelist`` command-line using information from CIME
variables ``CAM_NML_USE_CASE`` and ``CAM_NAMELIST_OPTS`` along with
namelist variable/value pairs that have been set in the file
``user_nl_cam`` in the case directory.  The resulting namelist is written
to the file ``atm_in`` in the run directory.

.. note::

  The task of constructing a correct namelist is extremely complex due to
  the large number of configurations supported by CAM.  **Editing namelists
  by hand is not allowed.** The ``atm_in`` file is created when
  ``case.build`` is run.  In order to allow changes to the namelist after
  the model is built the ``case.submit`` script also runs ``buildnml`` and
  any hand edits to ``atm_in`` will be overwritten.


The variables ``CAM_NML_USE_CASE`` and ``CAM_NAMELIST_OPTS`` are set by
``create_newcase`` based on the compset.  The hook for user modifications
to the namelist is the ``user_nl_cam`` file.  Settings in ``user_nl_cam``
have higher precedence that the settings from the use case file (specified
by ``CAM_NML_USE_CASE``) but lower precedence than the settings in
``CAM_NAMELIST_OPTS``.  To override settings in ``CAM_NAMELIST_OPTS`` use
an ``xmlchange`` command (this is rare).

``user_nl_cam`` is created in the case directory by ``case.setup`` and may
be modified by the user anytime after that command has run.  This file is a
list of variable/value pairs in namelist format.  The namelist groups are
not used in this file; ``build-namelist`` knows the namelist groups of all
CAM variables and adds variables to the correct groups when the ``atm_in``
file is written.

If the run needs to change namelist settings in other components, then
modify the appropriate ``$CASEROOT/user_nl_XXX`` file.

When setting up or customizing a case it is often convenient to examine the
namelist files.  This may be done anytime after ``case.setup`` has run by
running the command ``./preview_namelists`` from the case directory.  All
namelists and other runtime configuration files will be generated and
copied to both the ``$CASEROOT/CaseDocs`` and the ``$CASEROOT/run``
directories. 

CAM namelist variables include settings to tune the model for various
quantities, control over output and many other options.  A complete listing
of all of `CAM's namelist variables
<http://www.cesm.ucar.edu/models/cesm2/settings/2.2.0/cam_nml.html>`__ is
available.

A detailed explanation of controlling CAM's output can be found at
:ref:`Model Output <ug70-model-output>`.

.. note::

  Changes to ``user_nl_cam`` can occur at any time after it has been
  created by ``case.setup``.  Even after ``case.submit`` has been called
  the namelist may be modified for a new run before calling ``case.submit``
  again.

========
Examples
========

----------------------------------
Enable COSP Diagnostics
----------------------------------

One of the most common reasons to modify a configuration is to turn on the
`COSP <https://www.cfmip.org/tools-and-data/cosp>`__ satellite simulator
diagnostics.  This software package is implemented as a build time option,
thus enabling it requires a build configuration modification which is done
with the following command: ::

  % ./xmlchange --append CAM_CONFIG_OPTS='-cosp'

There is default COSP output so no namelist changes are required.  However
the COSP output is extensively customizable via the namelist.

------------------------------
Add passive tracers
------------------------------

Adding passive tracers to the model is a build time option.  The following
command adds N test tracers: ::

  % ./xmlchange --append CAM_CONFIG_OPTS='-nadv_tt N'

Specifying a large number of tracers might be done, for example, to test
the performance of the tracer advection scheme.  In this case no tracer
names would be set in the namelist and instead the names for the of
requested tracers would be generated internally and initialized from a set
of five specific tracer distributions (``TT_LW, TT_MD, TT_HI, TTRMD,
TT_UN``) assigned in round robin fashion.

Alternatively, to explore the shape preserving or mass conservation
properties of the advection scheme, a smaller number of test tracers would
be specified and the tracer names would be given in the namelist.  These
named tracers could be read from the initial file, or there is a set of 14
analytically specified tracer patterns that are supplied internally.  If
``N`` tracers are added, then ``N`` names must be specified.  To use all 14
of the analytic tracers issue the following commands from the case
directory: ::

  % ./xmlchange --append CAM_CONFIG_OPTS='-nadv_tt 14'
  % cat >> user_nl_cam <<EOF
  >  test_tracer_names='TT_SLOT1','TT_SLOT2','TT_SLOT3','TT_SLOT','TT_GBALL',
  >    'TT_TANH','TT_EM8','TT_Y2_2','TT_Y32_16','TT_LATP2','TT_LONP2','TT_COSB',
  >    'TT_CCOSB','TT_lCCOSB'
  > EOF
  
-------------------------------
Use analytic initial conditions
-------------------------------

The ability to generate analytic initial conditions was implemented to
support the ideal physics configurations.  However that capability can also
be used to start a full physics run in instances where a spun-up initial
file is not available.  There are two steps involved.  First the code used
to generate the initial conditions is enabled as a configuration option.
Then the namelist is used to specify the type of the analytic expressions.
For example the following commands may be issued from the case directory:
::

  % ./xmlchange --append CAM_CONFIG_OPTS='-analytic_ic'
  % cat >> user_nl_cam <<EOF
  >  analytic_ic_type='us_standard_atmosphere'
  > EOF
  


--------------------------------
Using CMIP5 emissions
--------------------------------

The following steps illustrate how to change the CMIP emissions back to the
CMIP5 version.  If a user desires to do this, they may cut/paste the
ext_frc_specifier and srf_emis_specifier settings below and put them into
their own user_nl_cam.

First the user must create a case and set it up
::

  % cd $SRCDIR/cime/scripts
  % ./create_newcase --case $CASEDIR/test --res f09_f09_mg17 --compset FHIST
  % cd $CASEDIR/test
  % ./case.setup

To revert to CMIP5 emissions, we only need to change the values of the
files specifed by ``ext_frc_specifier`` and ``srf_frc_specifier``.  With a
large amount of text like this it is often easiest to work with a text
editor to cut and paste the settings below into the ``user_nl_cam`` file.
``DIN_LOC_ROOT`` is the CIME variable containing the root directory of the
input datasets for all components.
::

   ext_frc_specifier  =
   'H2O    -> $DIN_LOC_ROOT/atm/cam/chem/emis/elev/H2O_emission_CH4_oxidationx2_elev_1850-2100_CCMI_RCP6_0_c160219.nc',
   'SO2    -> $DIN_LOC_ROOT/atm/cam/chem/emis/ccmi_1960-2008/IPCC_emissions_volc_SO2_1850-2100_1.9x2.5_c130426cycle.nc',
   'bc_a4  -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_bc_elev_1850-2005_c090804.nc',
   'num_a1 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam4_num_a1_elev_1850-2005_c150205.nc',
   'num_a2 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_num_a2_elev_1850-2005_c090804.nc',
   'num_a4 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam4_num_a4_elev_1850-2005_c150205.nc',
   'pom_a4 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_pom_elev_1850-2005_c130424.nc',
   'so4_a1 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_so4_a1_elev_1850-2005_c090804.nc',
   'so4_a2 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_so4_a2_elev_1850-2005_c090804.nc'

   srf_emis_specifier =
   'DMS    -> $DIN_LOC_ROOT/atm/cam/chem/emis/ccmi_1950_2100_rcp6/IPCC_emissions_DMS_surface_1850-2100_1.9x2.5_c130814.nc',
   'SO2    -> $DIN_LOC_ROOT/atm/cam/chem/emis/ccmi_1950_2100_rcp6/IPCC_emissions_SO2_surface_1850-2100_1.9x2.5_c130814.nc',
   'SOAG   -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_soag_1.5_surf_1850-2005_c130424.nc',
   'bc_a4  -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_bc_surf_1850-2005_c090804.nc',
   'num_a1 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam4_num_a1_surf_1850-2005_c150205.nc',
   'num_a2 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_num_a2_surf_1850-2005_c090804.nc',
   'num_a4 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam4_num_a4_surf_1850-2005_c150205.nc',
   'pom_a4 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_pom_surf_1850-2005_c130424.nc',
   'so4_a1 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_so4_a1_surf_1850-2005_c090804.nc',
   'so4_a2 -> $DIN_LOC_ROOT/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_so4_a2_surf_1850-2005_c090804.nc'

At this point, it is good practice to run preview_namelists and examine the
``atm_in`` file to make sure that the requested changes are correctly included.

-----------------------------
Specified Dynamics
-----------------------------

Specified dynamics compsets are setup to use specified meteorological
analysis (MERRA2 or GEOS5) to nudge the internally derived meteorology from
the model to the analysis fields. Available compsets are only produced for
a specific date and resolution.  Meteorological data sets (dates and
resolutions) can be downloaded from the repository or from the Research
Data Archive.  Information how to download MERRA2 or GEOS5 data sets can be
found in :ref:`Meteorological Datasets <ug70-meteorological-datasets>`.

To change the start data of a specified dynamics simulation, the new start
date and location of the meteorological data have to be adjusted in
``user_nl_cam``, as shown in the following example for Jan 1st 2014 (start
date) and using GEOS5 1 deg meteorological analysis. Also
``met_filenames_list`` needs to be updated if the simulation covers a different
period than included in this file.  One has to make sure to also update
``nc_data`` to the start date, even if a branch or hybrid run is performed: ::

  met_data_file       = '2014/GEOS5_09x125_20140101.nc'
  met_data_path       = '$DIN_LOC_ROOT/inputdata/atm/cam/met/GEOS5/0.9x1.25'
  met_filenames_list  = '$DIN_LOC_ROOT/inputdata/atm/cam/met/GEOS5/0.9x1.25/filenames_list.txt'

The relaxation factor that determines the amount of nudging towards the
meteorological analysis is controlled by the ``user_nl_cam`` namelist variable
``met_rlx_time``. The value can be changed and is often set to 5 for a rather
strong nudging (5 hours) or a looser nudging (every 50 hours).

Changes in specified dynamics simulations may also require to adjust the
``bnd_top`` file, that is specific to the resolution of the run and the
meteorological analysis fields used, e.g., for GEOS5: ::

 bnd_topo = '$DIN_LOC_ROOT/inputdata/atm/cam/topo/fv_0.9x1.25_nc3000_Nsw042_Nrs008_Co060_Fi001_ZR_geos5_c160702.nc'

To create a new ``bnd_topo`` file one has to replace the Surface geopotential
(``PHIS``) from CESM with the one from ``PHIS`` of one of the meteorological
analysis fields.

If the user wants to create a specified dynamics simulation from an F
compset, other changes will be required, including specifying the
``configure`` arguments to set the number of levels
(``-nlev``) and the nudging option (``-offline_dyn``), for example from the
case directory issue the command:
::

 ./xmlchange CAM_CONFIG_OPTS="-phys cam6 -age_of_air_trcs -chem waccm_tsmlt_mam4 -offline_dyn -nlev 88"

Furthermore, if the simulation is meant to include the leap year, one has
to change the calendar option to ``GREGORIAN`` (this command must be issued
before ``case.build``): ::

 ./xmlchange CALENDAR=GREGORIAN

Specified dynamics simulations do not currently run with CISM and
simulations have to be setup with SGLC to run, as the case for existing SD
compsets.

Specified dynamics simulations can also be performed using internally
generated 3 or 6 hour meteorological data produced by CESM. The internal
meteorogical fields can be produced from a free running simulation using an
output stream specified by adding the following variables to ``user_nl_cam``: ::

 fincl2 = 'FSDS', 'ICEFRAC', 'LANDFRAC', 'OCNFRAC', 'PHIS', 'PS', 'Q',
          'QFLX', 'SHFLX', 'T', 'TAUX', 'TAUY', 'TS', 'U', 'V' 
 mfilt  = 1,4
 nhtfrq = 0,-6

From the output a ``met_data_path``, ``met_data_file`` and ``met_filenames_list`` has
to be defined in the specified dynamics simulation.


