**********************************************************
Chemistry specific modifications 
**********************************************************

Several standard chemistry mechanisms are supported for CAM, CAM-chem, and
WACCM.  Here, we describe details on how the chemical mechanism is compiled
and how to perform modifications of chemistry in the model, including
adding or removing chemical and aerosol species, which requires changing
the chemical mechanism and if applicable changes to wet and dry deposition.
Additional changes may be required in the namelist, e.g., adding or
removing output, changing deposition species etc.  Furthermore, code
changes may be required, depending of the specifics of the changes.

.. _ug70-chemical-mechanisms:

----------------------------------------------------------------
Chemical mechanisms
----------------------------------------------------------------

Some supported chemical mechanism are listed in the table below. The
chemical mechanism is a set used to calculate chemical reactions using the
`Chemical Preprocessor
<http://www.cesm.ucar.edu/working_groups/Chemistry/chemistry.preprocessor.pdf>`__.
For chemistry schemes that may be specified by using the ``-chem <scheme>``
argument to ``configure``, the preprocessor has been used to generate the
fortran routines required to run the model.  This preprocessor output is
located in directories ``$COMP_ROOT_DIR_ATM/src/chemistry/pp_scheme/``,
where ``scheme`` is the argument supplied to the ``-chem`` option.

+--------------------------+-----------------------------+---------------+-----------------+
|| Mechanism               || Model:                     || #Species     || #Reactions     | 
|| (pre-processor code)    || Chemistry Description      |               |                 |
+==========================+=============================+===============+=================+
|| TSMLT1                  || WACCM: Troposphere,        || 231 solution,|| 583            |
|| (pp_waccm_tsmlt_mam4)   || stratosphere, mesosphere,  || 2 invariant  || (433 kinetic,  |
|                          || and lower thermosphere     |               || 150 photolysis)|
+--------------------------+-----------------------------+---------------+-----------------+
|| TS1                     || CAM-chem: Troposphere and  || 221 solution,|| 528            |
|| (pp_trop_strat_mam4_vbs)|| stratosphere               || 3 invariant  || (405 kinetic,  |
|                          |                             |               || 123 photolysis)|
+--------------------------+-----------------------------+---------------+-----------------+
|| MA                      || WACCM: Middle atmosphere   || 98 solution, || 298            |
|| (pp_waccm_ma_mam4)      || (stratosphere, mesosphere, || 2 invariant  || (207 kinetic,  |
|                          || and lower thermosphere)    |               || 91 photolysis) |
+--------------------------+-----------------------------+---------------+-----------------+
|| MAD                     || WACCM: Middle atmosphere   || 135 solution,|| 593            | 
|| (pp_waccm_mad_mam4)     || plus D-region ion chemistry|| 2 invariant  || (489 kinetic,  |
|                          |                             |               || 104 photolysis)|
+--------------------------+-----------------------------+---------------+-----------------+
|| SC                      | WACCM: Specified chemistry  || 29 solution, || 12             | 
|| (pp_waccm_sc_mam4)      |                             || 8 invariant  || (11 kinetic,   |
|                          |                             |               || 1 photolysis)  |
+--------------------------+-----------------------------+---------------+-----------------+
|| CAM                     || CAM: Aerosol chemistry,    || 31 solution, || 15 (12 kinetic,|
|| (pp_ghg_mam4)           || simple GHG chemistry       || 8 invariant  || 3 photolysis)  |
+--------------------------+-----------------------------+---------------+-----------------+

----------------------------------------------------------------
Modifications of the Chemical Mechanisms
----------------------------------------------------------------

To modify the chemical mechanism, including changing reaction rates
requires the following steps:

* Check out an existing compset that you would like to modify and compile
  and build your case

* Copy the existing chemical mechanism in ``$CASEROOT/CaseDocs/chem_mech.in``
  to a location (e.g., ``/my_dir/chem_mech_changed.in``)

* Alter your mechanism as desired (see details in `CAMchem Wiki page
  <https://wiki.ucar.edu/spaces/camchem/pages/358318629/Altering+the+Chemical+Mechanism+Input+File>`__)

* Point to the new mechanism file by modifying ``CAM_CONFIG_OPTS``, for
  example from the case directory issue the command::

    ./xmlchange --append CAM_CONFIG_OPTS='-usr_mech_infile /my_dir/chem_mech_changed.in'

* Changing the chemical mechanism requires rebuilding the case, i.e.::

    ./case.build --clean
    ./case.build

----------------------------------------------------------------
Adding emissions and lower boundary conditions
----------------------------------------------------------------

Adding new chemical or aerosol species requires to include their sources
(emissions) and sinks (deposition, see below).  Sources can be either
emissions (surface or vertical) or concentrations in form of lower boundary
conditions.  To add new emissions you have to copy the existing list of
emisisons (set by ``ext_frc_specifier`` and ``srf_frc_specifier``) to the
``user_nl_cam`` file and add the additional species.

To add new lower boundary conditions via namelist, you have to add the
addition species to the ``flbc_list`` and modify the ``flbc_file``::

  flbc_file =
  '/glade/p/cesmdata/cseg/inputdata/atm/waccm/lb/LBC_17500116-20150116_CMIP6_0p5degLat_c180227.nc'
  flbc_list =
  'CCL4', 'CF2CLBR', 'CF3BR', 'CFC11', 'CFC113', 'CFC12', 'CH3BR',
  'CH3CCL3', 'CH3CL', 'CH4', 'CO2', 'H2', 'HCFC22', 'N2O', 'CFC114',
  'CFC115', 'HCFC141B', 'HCFC142B', 'CH2BR2', 'CHBR3', 'H2402',
  'OCS', 'SF6', 'CFC11eq'

----------------------------------------------------------------
Adding species and changing the mechanism
----------------------------------------------------------------

The addition of species with dry and wet deposition requires code
changes. This requires to add information of the Henry's law coefficient:

.. attention::

   The following instructions need updating.

- Copy $CCSMROOT/cime/src/drivers/mct/shr/seq_drydep_mod.F90 in to your
  $CASEROOTSourceMods/src.share directory and modify the following. You can
  also map the new new species to deposit with the same rates as a species
  already undergoing wet deposition and therefore skip this step.

    - In this code, there are several arrays containing: 1) species
      names, 2) reactivity factors (f0), 3) henry's law constants,
      and 4) molecular weights. Add your new species characteristics
      at the end of each of these arrays.

    - Update the variable "maxspc" to be the total number of species
      you are dry depositing.

    - Update the variable "n_species_table" to the total number of
      species listed in these arrays.

- Additional routines may have to be modified: 
    - $COMP_ROOT_DIR_ATM/src/chemistry/mozart/mo_neu_wetdep.F90 
    - $COMP_ROOT_DIR_ATM/src/chemistry/mo_drydep.F90 (subroutine drydep_xactive) 
    - $COMP_ROOT_DIR_LND/src/biogeochem/DryDepVelocity.F90

- Add new species to the masterlist (to be automatically included in your
  namelists). If you don’t include your species to the mastlist you have to
  include those in your user_nl_cam namelist.

    - $COMP_ROOT_DIR_ATM/bld/namelist_files including
      master_drydep_list.xml, master_gas_wetdep_list.xml,
      master_aer_drydep_list.xml, master_aer_wetdep_list.xml


.. _ug70-interactive-prescribed-biogenic-emissions:

----------------------------------------------------------------
Running with interactive / prescribed biogenic emissions
----------------------------------------------------------------

Running with interactive biogenic emissions:

- The default setting in CESM2 CAM-chem and WACCM configuration is to run with interactive biogenic emissions, while CAM6 and WACCM SC do not use biogenic emissions. To run with interactive biogenic emissions, this file needs to be specified::

    megan_factors_file = '/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart/emis/megan21_emis_factors_78pft_c20161108.nc'

- This file contains the emission factors at standard temperature and pressure for each compound for each plant functional type, as well as the other model parameters. The compound names are given in the variable “Comp_Name”. The default file works with 78 plant function types (PFTs). 

- CLM/MEGAN-v2.1 includes an option for using a map of emission factors for isoprene. The map in the current release is out of date and SHOULD NOT BE USED.  Under megan_emis_nl, in drv_flds_on or user_nl_cam: megan_mapped_emisfctrs = .false.

Running with prescribed biogenic emissions:

To turn run with prescribed biogenic emissions requires including those emissions in the namelist for surface emission files that are not indluced in the namelist by default. Additionally, one needs to turn off interactive biogenic emissions, if using a CAMchem or WACCM TSML compset::

 &megan_emis_nl
  megan_factors_file = ' '
  megan_specifier = ' '
 &
 
History output:

- To save the MEGAN emissions in the CAM history files, include the desired MEG_{species} variables in the fincl* fields of user_nml_cam. The SF{species} variables are the total emissions fluxes for each species, so will include all sources if an emissions file was also read for other sources (such as bb).


