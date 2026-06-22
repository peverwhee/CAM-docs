***************************
Input Datasets
***************************

Input datasets are required to run the model and differ depending on the
configuration used.  Required datasets include initial conditions,
topography, emissions, lower boundary conditions, soil erodibility data for
dust emissions, and solar input files.  In addition, meteorological data
are required to run the model in specified dynamics mode. Furthermore, CAM
and WACCM SC (specified chemistry), and simulations with prescribed
stratospheric aerosols require prescribed input datasets that are derived
from full chemistry simulations. Additional datasets include sea-surface
temperatures, and prescribed land data.

The CIME infrastructure has utilities to help obtain this data on a local
filesystem.  The place where CIME looks for input data is specified by the
variable ``DIN_LOC_ROOT``.  The datasets needed for CAM configurations are
stored in namelist default files with pathnames that are relative to
``$DIN_LOC_ROOT``.  When ``build-namelist`` writes the namelist files,
dataset filenames are resolved to have absolute filepaths.
``build-namelist`` also produces a file,
``$CASEROOT/Buildconf/cam.input_data_list``, that contains all the names of
the required input datasets.  The ``case.submit`` script runs a CIME
command ::

  ./check_input_data --download

which checks whether the required datasets exist in ``$DIN_LOC_ROOT``, and
if they do not it tries to download them from the CESM SVN input data
repository.  The ``check_input_data`` command may also be invoked by the
user from the ``$CASEROOT`` directory.  See the `check_input_data
<https://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/check_input_data.html>`__
documentation for more information.

This chapter presents some additional information about the required input
datasets.

=========
Emissions
=========

All CAM, CAM-chem and WACCM configurations require surface emissions and,
in most cases, external forcings (vertically distributed emissions). In the
standard compsets all biomass burning emissions are at the surface.
Anthropogenic emissions are mostly released at the surface, but some
sectors of sulfate emissions are injected vertically. Aircraft and volcanic
emissions are distributed with altitude.  The standard emission files are
provided separately for each sector: anthropogenic (anthro), biomass
burning (bb), biogenic (bg), volcanic source and others (soil, ocean etc.),
for convenience and clarity.  CAM will read multiple emissions files for
each compound (specified in the namelist) and sum them in the model.  There
are no restrictions on the filenames or the variable names within the
files.

------------------
Emissions datasets
------------------

* The default emissions for CESM2 are based on the CMIP6 inventories for
  anthropogenic and biomass burning emissions, provided by the Community
  Emissions Data System (CEDS,
  http://www.globalchange.umd.edu/ceds/ceds-cmip6-data/), original files
  are available at: https://esgf-node.llnl.gov/search/input4mips/.

* Additional emissions (soil, ocean) are from the `POET inventory
  <http://eccad.aeris-data.fr/>`__.

* Continuous volcanic out‐gassing emissions of SO2, with 2.5% emitted as
  sulfate aerosols, are from the GEIA inventory, see `Andres &
  Kasgnoc (1998) <https://doi.org/10.1029/98JD02091>`__.

* SO2 from eruptive volcanoes is specified as well, based on the database
  of Volcanic Emissions for Earth System Models, version 3.11 `VolcanEESM;
  Neely & Schmidt (2016)
  <https://doi.org/10.5285/76ebdc0b-0eed-4f70-b89e-55e606bcd568>`__.

It is straightforward to use different emissions inventories in CAM,
CAM-chem or WACCM simulations by specifying different files (in the proper
format) in the namelist.  A list of emissions inventories that have been
used by CESM are `here
<https://wiki.ucar.edu/display/camchem/Emission+Inventories>`__.

----------------------------
Species with emissions (CAM)
----------------------------

* Surface (anthro, bb)::

    bc_a4 , pom_a4 , num_a4 (for bc_a4 and pom_a4), SO2 

* Surface (anthro, bb, biogenic)::

    SOAG 

* Vertical (extfrc)::

    SO2 (aircraft, contvolcano), so4_a1 (anthro-ene, contvolcano), 
    so4_a2 (contvolcano), bc_a4 (aircraft), num_a1, num_a2, num_a4

-----------------------------------------
Species with dry and wet deposition (CAM) 
-----------------------------------------

* Aerosols::

    bc_a1, bc_a4, dst_a1, dst_a2, dst_a3, ncl_a1, ncl_a2, ncl_a3, num_a1,
    num_a2, num_a3, num_a4, pom_a1, pom_a4, so4_a1, so4_a2, so4_a3, soa_a1,
    soa_a2

* Gas-phase::

    H2O2, H2SO4, SO2

--------------------------------------
Species with emissions (CAMchem/WACCM)
--------------------------------------

* Surface (anthro, bb, other)::

    NO, NH3, CO, C2H4, C2H6, C3H6, C3H8

* Surface (anthro, bb)::

    bc_a4, pom_a4, num_a4, SO2, C2H2, BIGALK, BIGENE, BENZENE, TOLUENE,
    XYLENES, CH3OH, C2H5OH, CH2O, CH3CHO, CH3COCH3, MEK, HCOOH, CH3COOH,
    HCN, CH3CN, IVOC, SVOC

* Vertical::

    NO2 (aircraft), SO2 (aircraft, contvolcano, erupting volcanoes), so4_a1
    (anthro-ene, contvolcano), so4_a2 (contvolcano), bc_a4 (aircraft),
    num_a1, num_a2, num_a4

---------------------------------------------------
Species with dry and wet deposition (CAMChem/WACCM) 
---------------------------------------------------

**Species with dry deposition**

* Aerosols::

    bc_a1, bc_a4, dst_a1, dst_a2, dst_a3, ncl_a1, ncl_a2, ncl_a3, num_a1,
    num_a2, num_a3, num_a4, pom_a1, pom_a4, so4_a1, so4_a2, so4_a3,
    soa1_a1, soa1_a2, soa2_a1, soa2_a2, soa3_a1, soa3_a2, soa4_a1, soa4_a2,
    soa5_a1, soa5_a2

* Gas-phase::

    ALKNIT, ALKOOH, BENZOOH, BZOOH, C2H5OH, C2H5OOH, C3H7OOH, C6H5OOH,
    CH2O, CH3CHO, CH3CN, CH3COCH3, CH3COCHO, CH3COOH, CH3COOOH, CH3OH,
    CH3OOH, CO, EOOH, GLYALD, H2O2, H2SO4, HCN, HCOOH, HNO3, HO2NO2,
    HONITR, HPALD, HYAC, HYDRALD, IEPOX, ISOPNITA, ISOPNITB, ISOPNO3,
    ISOPNOOH, ISOPOOH, IVOC, MACROOH, MEKOOH, MPAN, NC4CH2OH, NC4CHO, NH3,
    NH4, NO, NO2, NOA, NTERPOOH, O3, ONITR, PAN, PHENOOH, POOH, ROOH, SO2,
    SOAG0, SOAG1, SOAG2, SOAG3, SOAG4, SVOC, TERP2OOH, TERPNIT, TERPOOH,
    TERPROD1, TERPROD2, TOLOOH, XOOH, XYLENOOH, XYLOLOOH

**Species with wet deposition**

* Aerosols::

    bc_a1, bc_a4, dst_a1, dst_a2, dst_a3, ncl_a1, ncl_a2, ncl_a3, num_a1,
    num_a2, num_a3, num_a4, pom_a1, pom_a4, so4_a1, so4_a2, so4_a3,
    soa1_a1, soa1_a2, soa2_a1, soa2_a2, soa3_a1, soa3_a2, soa4_a1, soa4_a2,
    soa5_a1, soa5_a2

* Gas-phase::

    ALKNIT, ALKOOH, BENZOOH, BRONO2, BZOOH, C2H5OH, C2H5OOH, C3H7OOH,
    C6H5OOH, CH2O, CH3CHO, CH3CN, CH3COCH3, CH3COCHO, CH3COOH, CH3COOOH,
    CH3OH, CH3OOH, CLONO2, COF2, COFCL, EOOH, GLYALD, H2O2, H2SO4, HBR,
    HCL, HCN, HCOOH, HF, HNO3, HO2NO2, HOBR, HOCL, HONITR, HPALD, HYAC,
    HYDRALD, IEPOX, ISOPNITA, ISOPNITB, ISOPNO3, ISOPNOOH, ISOPOOH, IVOC,
    MACR, MACROOH, MEKOOH, MVK, NC4CH2OH, NC4CHO, NDEP, NH3, NH4, NHDEP,
    NOA, NTERPOOH, ONITR, PHENOOH, POOH, ROOH, SO2, SOAG0, SOAG1, SOAG2,
    SOAG3, SOAG4, SVOC, TERP2OOH, TERPNIT, TERPOOH, TERPROD1, TERPROD2,
    TOLOOH, XOOH, XYLENOOH, XYLOLOOH

-----------------------------------------------
Species with biogenic emissions (CAMChem/WACCM) 
-----------------------------------------------

Species with MEGAN emissions (CAM-chem (TS1) and WACCM (TSMLT)) are listed
in ``drv_flds_in``, and can be modified in ``user_nl_cam``::

  megan_specifier = 'ISOP = isoprene',
      'MTERP = pinene_a + carene_3 + thujene_a + 2met_styrene + cymene_p +
               cymene_o + terpinolene + bornene + fenchene_a + ocimene_al +
               pinene_b + sabinene + camphene + limonene + phellandrene_a +
               terpinene_g + terpinene_a + phellandrene_b + myrcene +
               ocimene_t_b + ocimene_c_b', 
      'BCARY = caryophyllene_b + bergamotene_a + bisabolene_b +
               farnescene_b + humulene_a', 
      'CH3OH = methanol', 
      'C2H5OH = ethanol', 
      'CH2O = formaldehyde',
      'CH3CHO = acetaldehyde', 
      'CH3COOH = acetic_acid', 
      'CH3COCH3 = acetone',
      'HCOOH = formic_acid', 
      'HCN = hydrogen_cyanide', 
      'CO = carbon_monoxide',
      'C2H6 = ethane', 
      'C2H4 = ethene', 
      'C3H8 = propane', 
      'C3H6 = propene',
      'BIGALK = pentane + hexane + heptane + tricyclene', 
      'BIGENE = butene',
      'TOLUENE = toluene'

.. note::

  Modifications may be required for other mechanisms, see :ref:`Running
  with interactive / prescribed biogenic emissions
  <ug70-interactive-prescribed-biogenic-emissions>`.

-----------------
WACCM-X emissions
-----------------

WACCM-X uses emissions relevant to middle atmosphere (MA) chemistry,
consistent with those provided for the REF-C1 experiment of the `IGAC/SPARC
Chemistry-Climate Model Initiative (CCMI)
<http://www.sparc-climate.org/fileadmin/customer/6_Publications/Newsletter_PDF/40_SPARCnewsletter_Jan2013_web.pdf>`__
Community Simulations.

=======================
Lower boundary datasets
=======================

A number of very long-lived chemical species have their mixing
ratios specified at the surface (e.g., CO2, CH4, CFCs).  The standard lower
boundary condition file is provided for 1750 to 2015, and is suitable for
various horizontal resolutions.  This file works for all atmospheric
configurations::

  flbc_file =
  ‘$DIN_LOC_ROOT/atm/waccm/lb/LBC_17500116-20150116_CMIP6_0p5degLat_c180227.nc’

Additional files are available for the SSP scenarios.

=========================
Soil erodibility datasets
=========================

Soil erodibility maps provide a proxy for the relative ability of the soils
in different regions to generate dust.  The maps are input as a netcdf
file, with no time dependence, and are a unitles factor for each grid box,
and are interpolated to the resolution of the model within the model.  They
are input in the CAM, although the rest of the dust generation itself is
included in CLM.  The idea of the soil erodibility map comes from Ginoux
et al., 2001, and the specific maps used is the geomorphic map from Zender
et al., 2003a and are used in combination with the Dust Entrainment and
Deposition scheme from Zender et la., 2003b, as described in Mahowald et
al., 2006.  The regional distribution of these values are tuned to generate
a good distribution as described in Albani et al., 2014.

The file used::
  
  soil_erod_file = '$DIN_LOC_ROOT/atm/cam/dst/dst_source2x2tunedcam6-2x2-04062017.nc’

===================
Topography datasets
===================

Topography files are generated with the NCAR Global Model Topography
Generation Software for Unstructured Grids.  See the `User's Guide
<https://github.com/NCAR/Topo/wiki/User's-Guide>`__ for more information.

.. _ug70-meteorological-datasets:

=======================
Meteorological datasets
=======================

For specified dynamics model simulations, meteorolocial analysis from the
Goddard Earth Observing System Model, Version 5 (GEOS5) and the Modern-Era
Retrospective analysis for Research and Applications, Version 2 (MERRA2)
data have been prepared to run CESM and WRF simulations and are available
in 3 resolutions from the Research Data Archive.

*  `GEOS5 2005-present
   <https://rda.ucar.edu/datasets/ds313.0/>`__
   (currently only 1.9x2.5 degree horizontal resolution).
 
*  `MERRA2 1980-close to present
   <https://rda.ucar.edu/datasets/ds313.3/>`__
   (1.9x2.5, 0.9x1.25, and 0.5x0.63 degrees horizontal resolution).

These datasets and additional resolutions for GEOS5, MERRA, and MERRA2 can
be found on repository, and on HSI.

==============
Solar datasets
==============

----------------
Solar irradiance
----------------

CESM2 uses solar input files provided by `CMIP6
<http://solarisheppa.geomar.de/cmip6>`__.  All versions of CESM2 use the
``solar_irrad_data_file``, which provides the reconstructed spectral solar
irradiance at 1 AU as the variable ``ssi``, with units of mW m
:superscript:`-2` nm :superscript:`-1`.

piControl::

 solar_irrad_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'

Historical::

 solar_irrad_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-23000102_c20200615.nc'

------------------
WACCM solar inputs
------------------

WACCM uses 2 additional solar input files for upper-atmosphere processes:

* ``solar_parms_data_file``: geomagnetic parameters, including daily
  planetary Ap and Kp indices, and F10.7 solar radio flux.

* ``epp_all_filepath``: Provides ``epp_ion_rates`` variable with ion pair
  production rate from energetic particle precipitation, including solar
  protons, cosmic rays, and medium energy electrons.

The data for all three solar inputs have been combined into a single file
for each time period, so that WACCM points to the same file for each.

piControl::

 solar_irrad_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'
 solar_parms_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'
 epp_all_filepath =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'

Historical::

 solar_irrad_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-23000102_c20200615.nc'
 solar_parms_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-23000102_c20200615.nc'
 epp_all_filepath =
  '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-23000102_c20200615.nc'

--------------------
WACCM-X solar inputs
--------------------

WACCM-X uses the Naval Research Laboratory (NRL) Version 1
reconstruction for solar irradiance (Lean, ref), rather than CMIP6. Instead
of the ``epp_all_filepath``, WACCM-X uses the ``epp_spe_filepath``, which
provides ion pair production rates just for solar proton events (neglecting
cosmic rays and MEE). For historical simulations, WACCM-X uses a
``solar_parms_data_file`` with 3-hour time resolution, spanning the dates April
10, 1947 to July 23, 2016.

Historical::

 solar_irrad_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/spectral_irradiance_Lean_1950-2014_daily_GOME-Mg_Leap_c150623.nc'
 epp_spe_filepath =
  '$DIN_LOC_ROOT/atm/waccm/solar/spes_1963-2014_c150717.nc'
 solar_parms_data_file =
  '$DIN_LOC_ROOT/atm/waccm/solar/waxsolar_3hr_c170504.nc'
 
Constant year 2000::

 solar_irrad_data_file =
  '$DIN_LOC_ROOT/atm/cam/solar/spectral_irradiance_Lean_1950-2014_daily_GOME-Mg_Leap_c150623.nc'
 epp_spe_filepath =
  '$DIN_LOC_ROOT/atm/waccm/solar/spes_1963-2014_c150717.nc'
 solar_parms_data_file =
  '$DIN_LOC_ROOT/atm/waccm/phot/wa_avg_c20170519.nc'
 
