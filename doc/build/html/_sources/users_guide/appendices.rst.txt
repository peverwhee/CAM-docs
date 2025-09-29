***************
Appendices
***************

.. _ug70-configure-utility:

======================
The configure utility
======================

All CAM specific build time configuration options are specified using
command-line arguments to CAM's ``configure`` script (a Perl script).  The
expert knowledge to determine what parameterizations are run by the
specified physics package is hardcoded in the ``configure`` script's logic.
Optional arguments not specified on the command-line may be set to
hard-coded default values which come from the definition file
(``$COMP_ROOT_DIR_ATM/bld/config_files/definition.xml``) or from the script
itself.  ``configure`` contains logic to check for consistency among the
many options, and will fail with an informative message when a check fails.

The output from ``configure`` is written to
``$CASEROOT/Buildconf/camconf/`` and includes the following:

* ``CESM_cppdefs`` -- Preprocessor macros to be included in the CESM Makefile.
* ``Filepath`` -- Filepaths for all source code to be compiled.
* ``config_cache.xml`` -- Storage of all configuration parameters.  This
  file is read by ``build-namelist`` to obtain the build configuration.

Some components of CAM may be built as separate libraries, for example the
MPAS and FV3 dynamical cores and the COSP diagnostic package.  If CAM is
configured to use any of those packages then ``configure`` writes Makefiles
for them and the main CESM Makefile (``$SRCROOT/cime/CIME/Tools/Makefile``)
will issue sub-make commands to build the libraries.

--------------------------------------------
Arguments to configure
--------------------------------------------

The options may all be specified with either one or two leading dashes,
e.g., ``-help`` or ``--help``.  A consequence of allowing long names with
single leading dashes is that the few options that can be expressed as
single letter switches may **not** be bundled, e.g., ``-h -s -v`` may NOT
be expressed as ``-hsv``.

User supplied values in the description below are denoted in angle brackets
"<>".  Any value that contains white-space must be quoted.  For options
that can be set from small set of legal values, those values are given as a
vertical bar separated list. ::

  -[no]age_of_air_trcs
                     Switch on [off] age of air tracers. Default: on for
                     waccm_phys, otherwise off. 

  -analytic_ic       Enables generating initial conditions using analytic expressions
                     which are determined by the namelist variable "analytic_ic_type".
                     Default: off.

  -aquaplanet        Switch for aqua-planet mode.  Default: off.

  -build_chem_proc   Switch forces the build of the chemistry preprocessor
                     (primarily for testing).  Default: off.

  -camiop            Configure CAM to generate an IOP file that can be used
                     to drive SCAM. This switch only works with the
                     Spectral Element dycore.
                     Default: off.

  -carma <name>      Build CAM with specified CARMA microphysics model
                     [ none | bc_strat | cirrus | cirrus_dust | dust |
                       meteor_impact | meteor_smoke | mixed_sulfate | pmc |
                       pmc_sulfate | sea_salt | sulfate | tholin |
                       test_detrain | test_growth | test_passive |
                       test_radiative | test_swelling | test_tracers |
                       test_tracers2 | trop_strat_soa1 | trop_strat_soa5 ]
                     Default: none.

  -chem <name>       Build CAM with specified prognostic chemistry package
                     [ none | ghg_mam4 | terminator | trop_mam3 | trop_mam4 |
                       trop_mam7 | trop_mozart | trop_strat_mam4_ts2 |
                       trop_strat_mam4_vbs | trop_strat_mam4_vbsext |
                       trop_strat_mam5_ts2 | trop_strat_mam5_ts4 |
                       trop_strat_mam5_vbs | trop_strat_mam5_vbsext |
                       trop_strat_noaero | waccm_ma | waccm_mad |
                       waccm_ma_sulfur | waccm_sc | waccm_sc_mam4 |
                       waccm_mad_mam4 | waccm_ma_mam4 | waccm_tsmlt_mam4 |
                       waccm_tsmlt_mam4_vbsext | waccm_mad_mam5 |
                       waccm_ma_mam5 | waccm_tsmlt_mam5 |
                       waccm_tsmlt_mam5_vbsext | waccm_t4ma_mam5 |
                       waccm_ma_noaero | geoschem_mam4 ]
                     Defaults: ghg_mam4 for cam7, trop_mam4 for cam6, and
                               trop_mam3 for cam5.  Otherwise none.

  -[no]clubb_sgs     Switch on [off] CLUBB_SGS.
                     Defaults: on for cam7 and cam6, otherwise off.

  -clubb_opts <list> Comma separated list of CLUBB options to turn on.
                     [clubb_do_adv (Advect CLUBB moments)]
                     Default: none.

  -co2_cycle         Turn on the CO2 cycle code for biogeochemistry.  Adds the
                     advected constituents CO2_OCN, CO2_FFF, CO2_LND, CO2.
                     Default: off.

  -cosp              Enable the COSP satellite simulator diagnostics.
                     Default: off.

  -dyn <name>        Dynamical core option.  This is set using the value of
                     the "--res" argument from "create_newcase".  Do
                     not change this setting via "CAM_CONFIG_OPTS".
                     [ se (Spectral Element) | fv (Finite Volume) |
                       mpas (MPAS-ATM) | fv3 (FV3 -- FV on cubed sphere)]
                     Default: none.

  -edit_chem_mech    Invokes CAMCHEM_EDITOR to allow the user to edit the
                     chemistry mechanism file. 

  -help [or -h]      Print usage to STDOUT.

  -hgrid <name>      Specify horizontal grid.  This is set using the value of
                     the "--res" argument from "create_newcase".  The
                     valid grid specifiers are located in the file
                     $SRCROOT/ccs_config/component_grids_nuopc.xml.  Do
                     not change this setting via "CAM_CONFIG_OPTS".
                     Default: none.

  -ionosphere        Ionophere module used in WACCMX [ none | wxie ].
                     Default: none.

  -macrophys <name>  Set the macrophysics package.
                     [rk | park | clubb_sgs | none ]
                     Defaults: clubb_sgs for cam6 or cam7; park for cam5;
                     rk for cam4.

  -max_n_rad_cnst <n> Maximum number of constituents that are either radiatively
                     active, or in any single diagnostic list for the radiation.
                     Default: 80.

  -microphys <name>  Set the microphysics package.
                     [ rk | mg1 | mg2 | mg3 | pumas | none ].
                     Defaults: mg3 for cam7; mg2 for cam6; mg1 for cam5;
                     rk for cam4.

  -model_top <name>  Specify the model_top option for cam7.  This is set
                     using the value of the "--compset" argument for
                     "create_newcase".    Do not change this setting
                     via "CAM_CONFIG_OPTS". 
                     [ lt | mt | ht | xt ].
                     Default: none.

  -nadv <N>          Set the total number of advected species to N.
                     Default: set by configure depending on the specified
                     physics and chemistry packages.

  -nadv_tt <N>       Set number of advected test tracers to N.
                     Default: 0

  -nlev <N>          Set the number of vertical levels to N.
                     Defaults: 58 for cam7-lt or simple physics;
                       93 for cam7-mt; 135 for cam7-ht; 189 for cam7-xt;
                       32 for cam6; 30 for cam5; 26 for cam4;
                       66 for waccm w/ cam4; 70 for waccm w/ cam5 or cam6;
                       126 for waccmx w/ cam4 or cam5;
                       130 for waccmx w/ cam6.

  -offline_drv <name> Specify offline unit driver.
                      [rad (PORT) | aur (aurora) | stub]
                      Default: stub

  -offline_dyn       Enable offline driver for FV dycore.
                     Default: off.

  -pbl <name>        Set the PBL scheme.
                     [ clubb_sgs | uw | hb | none ].
                     Default PBL schemes: clubb_sgs for cam6 and cam7;
                       uw for cam5; hb for cam4.

  -pcols <n>         Maximum number of columns in a chunk.
                     Default: 16, or if SCAM mode then 1.

  -pergro            Switch enables building CAM for perturbation growth tests.
                     Only valid with cam4 physics.

  -phys <name>       Physics option.  This is set using the value of the
                     "--compset" argument for "create_newcase".  Do not
                     change this setting via "CAM_CONFIG_OPTS".
                     [ cam4 | cam5 | cam6 | cam7 | held_suarez | adiabatic | kessler | 
                       tj2016 | grayrad].
                     Default: none.

  -prog_species <list>
                     Comma-separate list of prognostic mozart species packages.
                     Currently available: DST,SSLT,SO4,GHG,OC,BC,CARBON16
                     Default: none.

  -psubcols <n>      Maximum number of sub-columns in a grid column.
                     Default: 1

  -rad <name>        Set the radiation scheme.
                     [ rrtmgp | rrtmg | camrt | none ].
                     Default: rrtmgp for cam7; rrtmg for cam5 or cam6;
                       camrt for cam4.

  -scam <iop>        Build model in single column (SCAM) mode for the
                     specified IOP.  Only works with Spectral Element dycore.
                     [ arm95 | arm97 | atex | bomex | cgilss11 | cgilss12 |
                       cgilss6 | dycomsrf01 | dycomsrf02 | gateiii | mpace |
                       rico | sas | sparticus | togaii | twp06 | camfrc |
                       none ]
                     Default: none

  -silent [or -s]    Turns on silent mode - only fatal messages issued.
                     Default: off.

  -silhs             Switch on SILHS.
                     Default: off.

  -usr_mech_infile   Absolute pathname of the user supplied chemistry
                     mechanism file.
                     Default: none.

  -usr_src <dir1>[,<dir2>[,<dir3>[...]]]
                     Directories containing user source code.  Note that
                     these directories will also be searched for modified
                     versions of the files needed by the build-namelist
                     script, e.g., the namelist definition, defaults, and
                     use case files.  Set by "buildcpp" to
                     "$CASEROOT/SourceMods/src.cam".  Do not change this
                     setting via "CAM_CONFIG_OPTS".

  -verbose [or -v]   Turn on verbose echoing of settings made by configure.
                     Default: off.

  -version           Echo the tag name of the CAM component.

  -waccm_phys        Switch enables the use of WACCM physics in any
                     chemistry configuration.
                     Default: off unless one of the waccm chemistry options is chosen.

  -waccmx            Build CAM/WACCM with WACCM upper
                     Thermosphere/Ionosphere extended package. 
                     Default: This is set using the value of the
                     "--compset" argument for "create_newcase".  Do not
                     change this setting via "CAM_CONFIG_OPTS".

.. _ug70-build-namelist-utility:

===========================
The build-namelist utility
===========================

The ``build-namelist`` utility produces namelists for the CAM component (in
the file ``atm_in``), and namelists for the control of dry deposition which
is shared by CAM and CLM (in the file ``drv_flds_in``).  These files are
written in the directory ``$CASEROOT/Buildconf/camconf/``.

Some of the important features of ``build-namelist`` are:

* All valid namelist variables are defined in the file
  ``$COMP_ROOT_DIR_ATM/bld/namelist_files/namelist_definition.xml``.  An
  invalid variable specified by the user will cause ``build-namelist`` to
  fail with an error message telling which namelist variable is
  invalid. This allows catching errors before they cause a runtime failure
  which is typically harder to track down.  In fact catching namelist
  errors can be done before building the model by running the
  ``preview_namelists`` utility after running ``case.setup`` from the case
  directory.

* In addition to knowing all valid variable names and their types,
  ``build-namelist`` also knows which namelist group each variable belongs
  to. This means that the user only needs to specify variable name and
  value pairs in ``user_nl_cam``, not the group names.

* Since ``build-namelist`` knows all namelist variables specified by
  the user it is able to do consistency checking. In general however,
  ``build-namelist`` assumes that the user is the expert and will not
  override a user specification unless there is a major inconsistency,
  for example if variables have been set to use parameterizations
  which can not be run at the same time.

* All configurations have namelist variables that must be specified,
  and ``build-namelist`` has a mechanism to provide default values for
  these variables. When an appropriate default value cannot be found
  then ``build-namelist`` will fail with an informative message.

* One required input for ``build-namelist`` is a configuration cache
  file produced by a previous invocation of ``configure``
  (``config_cache.xml`` by default). ``build-namelist`` looks at this
  file to determine the features of the CAM executable, such as the
  dynamical core and horizontal resolution, that affect the default
  specifications for namelist variables. The default values themselves
  are specified in the file
  ``$COMP_ROOT_DIR_ATM/bld/namelist_files/namelist_defaults_cam.xml``,
  and in the use case files located in the directory
  ``$COMP_ROOT_DIR_ATM/bld/namelist_files/use_cases/``.

* The other required input for ``build-namelist`` is the root directory for
  the input datasets. This is required since nearly all input files must be
  specified using absolute filepaths, but the *defaults* are stored as
  filepaths which are relative to the root directory. It is expected that
  the actual location of the root directory is something that will be
  resolved at the time the ``atm_in`` file is produced.  This information
  is provided by the CIME interface code in ``buildnml`` and is contained
  in ``$DIN_LOC_ROOT``.  Note that this variable may be used in pathnames
  provided by the user in the ``user_nl_cam`` file.

* When running a configuration for the first time there are often many
  input datasets that may not be in the local input data directory. In
  order to facilitate getting the required datasets, the ``build-namelist``
  option ``-inputdata`` is set by ``buildnml`` to to produce a complete
  list of required datasets in the file
  ``$CASEROOT/Buildconf/cam.input_data_list``.  The ``case.submit`` script
  runs the ``check_input_data`` script to check whether input datasets are
  present on local disk (in directory ``$DIN_LOC_ROOT``) and will attempt
  to download any missing files from the CESM SVN input data repository.
  The ``check_input_data`` script may also be run by the user from the case
  directory before issuing the ``case.submit`` command.

The methods for setting the values of namelist variables, listed from
highest to lowest precedence, are:

#. Using the ``-namelist`` option.  ``buildnml`` sets the values in
   ``CAM_NAMELIST_OPTS`` with this option.  ``CAM_NAMELIST_OPTS`` is set
   from the compset definition.

#. Setting values in a file specified by ``-infile``.  ``buildnml`` sets
   the values from the ``user_nl_cam`` file using this option.

#. Specifying a ``-use_case`` option.  ``buildnml`` gets the use case name
   from the variable ``CAM_NML_USE_CASE`` which is set from the compset
   definition.  The user may customize a use case file and add it to the
   directory for source code modifications,
   ``$CASEROOT/SourceMods/src.cam``

#. Setting values in the namelist defaults file.  This requires source code
   modifications to the file 
   ``$COMP_ROOT_DIR_ATM/bld/namelist_files/namelist_defaults_cam.xml``.

----------------------------------------------
Arguments to build-namelist
----------------------------------------------

The options may all be specified with either one or two leading dashes,
e.g., ``-help`` or ``--help``.  A consequence of allowing long names with
single leading dashes is that the few options that can be expressed as
single letter switches may **not** be bundled, e.g., ``-h -s -v`` may NOT
be expressed as ``-hsv``.

.. note::

   ``buildnml`` does not provide a way to supply ``build-namelist`` options
   directly.  It only allows setting namelist variable and value pairs.
   However, developers may find it convenient to execute ``build-namelist``
   directly when implementing changes or new namelists.  The ``configure``
   script needs to be executed prior to ``build-namelist`` in this
   scenario.

User supplied values in the description below are denoted in angle brackets
"<>".  Any value that contains white-space must be quoted.  For options
that can be set from small set of legal values, those values are given as a
vertical bar separated list.  ::

     -config <filepath>    Read the given configuration cache file to
                           determine the configuration of the CAM
                           executable.
                           Default: "$CASEROOT/Buildconf/camconf/config_cache.xml".

     -csmdata <dir>        Root directory of CESM input data.
                           Default: "$DIN_LOC_ROOT".

     -dir <directory>      Directory where output namelist files will be written,
                           Default: "$CASEROOT/Buildconf/camconf".

     -help [or -h]         Print usage to STDOUT.

     -ignore_ic_date       Ignore the "ic_ymd" attribute of the initial
                           condition files when searching for matches in
                           defaults file.  "buildnml" sets this option
                           unless the "RUN_STARTDATE" is Jan 1 or Sep 1.

     -ignore_ic_year       Ignore just the year part of the "ic_ymd"
                           attribute of the initial condition files when
                           searching for matches in the defaults file.
                           "buildnml" sets this option when the
                           "RUN_STARTDATE" is Jan 1 or Sep 1.

     -infile <filepath>    Specify a file containing namelists to read
                           values from.  "buildnml" uses this option for
                           the values set in "user_nl_cam".

     -inputdata <filepath> Writes out a list containing pathnames for
                           required input datasets to the specified
                           filepath.
                           Default: "$CASEROOT/Buildconf/cam.input_data_list"

     -namelist <namelist>  Specify namelist settings directly on the
                           command-line by supplying a string containing
                           namelist syntax.
                           Default: "&atmexp $CAM_NAMELIST_OPTS /"

     -ntasks <n>           Specify the number of MPI tasks being used by the run.
                           This is used to set a default decomposition for
                           the FV dycore only (npr_yz).
                           Default: $NTASKS_PER_INST_ATM

     -silent [-s]          Turns on silent mode - only fatal messages
                           issued.  Default: off.

     -test                 Enable checking that input datasets exist on
                           local filesystem.
                           Default: off.

     -use_case             Specify a use case file for setting defaults.
                           Default: "$CAM_NML_USE_CASE"

     -verbose [or -v]      Turn on verbose echoing of informational
                           messages.  Default: off.

     -version              Echo the tag name of the CAM component.

   
----------------------------------------------
CAM Namelist variables
----------------------------------------------

Follow link for a searchable (or browsable) page containing all 
`CAM namelist variables
<http://www.cesm.ucar.edu/models/cesm2/settings/2.2.0/cam_nml.html>`__.

