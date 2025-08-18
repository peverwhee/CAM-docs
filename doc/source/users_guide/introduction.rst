**************************
Introduction 
**************************

The Community Atmosphere Model version 7.0 (CAM7.0) is released as the
active atmosphere component of the Community Earth System Model version
CESM-3.0.  It is the latest in a series of global atmosphere models whose
development is guided by the `Atmosphere Model Working Group (AMWG)
<http://www.cesm.ucar.edu/working_groups/Atmosphere/>`__ of the `Community
Earth System Model (CESM) <http://www.cesm.ucar.edu/>`__ project.  CAM can
be run in many configurations within the CESM; it is the atmosphere
component in the `B, E, F, Q, and P compsets
<https://escomp.github.io/CESM/versions/cesm2.2/html/cesm_configurations.html#cesm2-component-sets>`__.
The term "standalone CAM" is
often used to refer to a compset which does not include prognostic ocean
and sea ice models.  When one speaks of "doing CAM simulations" the
implication is that it's a standalone configuration that is being used.
When CAM is coupled to prognostic land, ocean, and sea ice models then we
refer to it as a "fully coupled CESM simulation" which are implemented in
the B compsets.

Scientific studies with CAM should always be done via a released CESM version.
To get started running CAM refer to the `CESM2 Quick Start Guide
<https://escomp.github.io/CESM/versions/cesm2.2/html/quickstart.html>`__
and the :ref:`Building and Running CAM within CESM
<ug70-building-and-running-cam>` section of this User's Guide.  Running CAM
using the CIME scripts provides a high level of support for doing
production runs of predefined experiments on supported platforms.
Scientific studies with CAM should always be done via a released version of
the CESM.  

CAM development takes place in the `ESCOMP/CAM
<https://github.com/ESCOMP/CAM>`__ github repository.  Standalone CAM
development versions are available from github, see :doc:`Downloading CAM standalone
<checking-out-cam-standalone>`.

CAM provides the basic atmospheric physics for several other models included in this release:

 - CAM-chem: Community Atmosphere Model with Chemistry
 - WACCM: Whole Atmosphere Community Climate Model
 - WACCM-X: Whole Atmosphere Community Climate Model with thermosphere and ionosphere extension

Throughout this document, we will use the name CAM in a generic sense and
directions provided will be useful for CAM-chem, WACCM and WACCM-X also.

.. note::

  To facilitate research on the effects of physical and chemical
  parameterizations on model simulations, it is possible to configure
  CAM7 to use the physics and chemistry packages used in the earlier CAM
  versions 4, 5, and 6.  It is not, however, possible to reproduce the
  climates obtained from those earlier CAM versions as released in earlier
  CESM versions.  This is due to many factors including code changes in
  CAM's parameterizations and dynamical cores, as well as changes in the
  other CESM system components.  If users wish to reproduce a climate from
  earlier CAM runs, they should use the CESM version corresponding to that
  CAM version release.


---------------------------------
What's new in the CAM7.0 release?
---------------------------------

New dycore/physics features:

 - The Spectral-Element (SE) dynamical core replaces the Finite Volume (FV)
   dycore used in CAM4,5,6.  This provides:

   - Better scalability (strong scaling) needed for variable and high
     resolution grids.

   - More accurate transport.

   - More advanced thermodynamics.

   - Horizontal molecular diffusion and thermal conductivity operators for
     WACCM-X.

 - The vertical resolution for the low-top (about 40km) version of CAM has
   increase to 58 levels (from 32).

 - The PUMAS microphysics code base replaces MG.  This adds missing
   processes and hydrometeor types.  PUMAS is GPU-enabled.
     
 - Updated L-scale CLUBB code with prognostic momentum transport.

 - The physics sequence was reordered moving the call to CLUBB to after
   returning from the coupler.  This alleviates spurious surface wind
   oscillations.

 - The `RTE+RRTMGP <https://earth-system-radiation.github.io/rte-rrtmgp>`__ 
   radiation code replaces RRTMG.  The new code has improved
   algorithms and gas optics.

 - GPU support may be enabled via OpenACC directives in the PUMAS, CLUBB, and
   RTE-RRTMGP parameterizations.

 - New gravity wave drag parameterization adds missing sources to improve
   high-top stratospheric wind biases.

 - The topography software was updated to improve the ocean-atmosphere
   coupling.  Ease of using the software has also improved.

 - Add a convective gustiness parameterization.

 - The ZM deep convection scheme has a modified convective parcel
   calculation to adapt to higher boundary layer resolution.

 - The Richardson number based free-atmosphere mixing from CAM4 is used to
   augment mixing in areas where CLUBB is not active.  This improves model
   stability.

 - The physics parameterizations have been modified as necessary to support
   the height based vertical coordinate used by the MPAS dynamical core.
   This supports the SIMA/EarthWorks project.

 - A new simpler models configuration has been added: Moist Held-Suarez.

New chemistry features:

 - The default GHG chemistry now uses a simple prognostic scheme instead of
   being entirely prescribed.  There is improved SOA and aerosol
   descriptions, and coupling with biogenic SOA precurors.

 - OASISS, DMS emissions based on Online Air-Sea Interface for Soluble
   Species.

 - Improved chemical mechanisms TS2,3, SLH chemistry.  Different science
   questions require chemical mechanisms of different complexity.  Air
   quality studies require more tropospheric chemistry, short-lived
   halogens are important for improved climate and ozone.

 - Option to use CARMA, a comprehesive sectional aerosol model as an
   alternative to the default modal aerosol model.

 - GEOS-Chem is an alternative chemistry module.

 - Alternative emissions from HEMCO which allows online regridding and
   incorporating regional inventories into global inventories.

 - The CAMchem MPAS configuration uses a non-hydrostatic dynamical core to
   allow simulations at 5km horizontal resolution.

 - TUV-x improves the representation of photochemical decomposition of
   reactive species generating different radicals (O\ :sup:`1`\ D, OH,
   Cl/Br/I atoms) as well as the penetration of downwelling radiation to
   the lower troposphere.  Also improves treatment of aerosols.
   
New WACCM features:

 - Inline TUV-x to improve representation of photolysis and heating rates.

 - Use SE dynamical core for both WACCM and WACCM-X to maintain consistency
   with CAM and enable high resolution simulations.

------------------------------------------------
Features removed from CAM7.0 code base:
------------------------------------------------

 - The Eulerian spectral dycore.

 - The Super-parameterized CAM (SPCAM).
