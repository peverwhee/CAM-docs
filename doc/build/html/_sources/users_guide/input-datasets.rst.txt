.. _input-datasets:

***************************
Input Datasets
***************************

Input datasets are required to run the model and differ depending on the configuration 
used. All CAM, CAM-chem and WACCM configurations require surface emissions and external 
forcings (vertically distributed emissions). 

------------------------------
Emissions
------------------------------
================================================
List of species with emissions (CAM)
================================================

================================================
List of species with emissions (CAMchem/WACCM)
================================================

================================================
List of available emissions datasets
================================================

================================================
WACCM
================================================

================================================
WACCM-X
================================================
WACCM-X uses emissions relevant to middle atmosphere (MA) chemistry, consistent with those 
provided for the REF-C1 experiment of the `IGAC/SPARC Chemistry-Climate Model Initiative 
(CCMI) <http://www.sparc-climate.org/fileadmin/customer/6_Publications/Newsletter_PDF/40_SPARCnewsletter_Jan2013_web.pdf>`_ 
Community Simulations.

------------------------------
Lower boundary data sets
------------------------------
**NOTE TO AUTHOR** Include different concentration pathways

------------------------------
Soil erodibility files
------------------------------

------------------------------
Topography files
------------------------------

------------------------------
Meteorological data sets
------------------------------

------------------------------
Solar input files
------------------------------
CESM2 uses `CMIP6 solar input files <http://solarisheppa.geomar.de/cmip6>`_:

**solar_irrad_data_file**: provides spectral solar irradiance (SSI)

WACCM and WACCM-X use 2 additional solar input files for upper-atmosphere processes:

**solar_parms_data_file**: geomagnetic parameters

**epp_all_filepath**: Provides *epp_ion_rates* variable with ion pair production rate from
energetic particle precipitation, including solar protons, cosmic rays, and
medium energy electrons.

The data for all three inputs have been combined into a single file for each time period,
so that WACCM points to the same file for each.

piControl:
 solar_irrad_data_file = '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'
 
 solar_parms_data_file = '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'
 
 epp_all_filepath      = '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6piControl_c160921.nc'

Historical:
 solar_irrad_data_file = '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-22991231_c171031.nc'
 
 solar_parms_data_file = '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-22991231_c171031.nc'

 epp_all_filepath      = '$DIN_LOC_ROOT/atm/cam/solar/SolarForcingCMIP6_18491230-22991231_c171031.nc'


WACCM-X uses the Naval Research Laboratory (NRL) Version 1 reconstruction for solar 
irradiance (Lean, ref), rather than CMIP6. Instead of the *epp_all_filepath*, WACCM-X uses
the *epp_spe_filepath*, which provides ion pair production rates just for solar proton 
events.

Historical:
 solar_irrad_data_file = '$DIN_LOC_ROOT/atm/cam/solar/spectral_irradiance_Lean_1950-2014_daily_GOME-Mg_Leap_c150623.nc'
 
 epp_spe_filepath      = '$DIN_LOC_ROOT/atm/waccm/solar/spes_1963-2014_c150717.nc'
 
 solar_parms_data_file = '$DIN_LOC_ROOT/atm/waccm/solar/waxsolar_3hr_c170504.nc'
 
Constant year 2000:
 solar_irrad_data_file = '$DIN_LOC_ROOT/atm/cam/solar/spectral_irradiance_Lean_1950-2014_daily_GOME-Mg_Leap_c150623.nc'
 
 epp_spe_filepath      = '$DIN_LOC_ROOT/atm/waccm/solar/spes_1963-2014_c150717.nc'
 
 solar_parms_data_file = '$DIN_LOC_ROOT/atm/waccm/solar/wa_avg_c20170519.nc'
 

------------------------------
WACCM
------------------------------

------------------------------
WACCM-X
------------------------------


