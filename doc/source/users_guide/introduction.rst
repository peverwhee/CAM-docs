.. _introduction:

**************************
Introduction 
**************************

The Community Atmosphere Model version CAM6 is released as the atmosphere component of the Community Earth System Model version CESM-2.0. 
It is the latest in a series of global atmosphere models whose development is guided by the `Atmosphere Model Working Group (AMWG) <http://www.cesm.ucar.edu/working_groups/Atmosphere/>`_ of the `Community Earth System Model (CESM) <http://www.cesm.ucar.edu//>`_ project. 
CAM is the atmospheric component of the CESM. 
CAM is a "standalone" configuration in CESM, by which we mean that the atmosphere is coupled to an active land model (CLM), a thermodynamic only sea ice model (a special configuration of CICE), and a data ocean model (DOCN) + ??????????????????????????. 
When one speaks of "doing CAM simulations" the implication is that it's a standalone configuration that is being used. 
When CAM is coupled to CESM active ocean and sea ice models then we refer to it as a "fully coupled CESM simulation".

CAM provides a framework for running the "Whole Atmosphere" configurations; WACCM, and WACCM-X. 
To run CAM in a WACCM or WACCM-X configuration the user is referred to the `?????????????? <http://www.cesm.ucar.edu/models/cesm2.0/>`_.

In versions of CAM before 4.0 the driver for the standalone configuration was completely separate code from what was used to couple the components of the CCSM. 
One of the most significant software changes in CAM-4.0 was a refactoring of how the land, ocean, and sea ice components are called which enabled the use of the CCSM coupler to act as the CAM standalone driver (this also depended on the complete rewritting of the CCSM coupler to support sequential execution of the components). 
Hence, for the CESM1 and CESM2 models, just as for CCSM4 before it, it is accurate to say that a CAM standalone configuration is nothing more than a special configuration of CESM in which the active ocean and sea ice components are replaced by data ocean and thermodynamic sea ice components.

It should be noted that in CAM6, we are unable to support reproducibility of CAM4 and CAM5 numerical results. This is due to many factors including code changes and namelist settings.  While a user is still able to set the "-phys" namelist setting to either cam4 or cam5, the results will differ with what a user would get using those settings in CESM1.2. Due to these changes, a number of compsets specific to CAM4 or CAM5 have been removed.  We recommend that if a user wants a true CAM4 or CAM5 run, that they use CESM1.2 for those runs.

Since the CAM standalone model is just a special configuration of CESM it can be run using the CESM scripts. 
This is done by using one of the "F" compsets and details on using the scripts can be found in the :ref:`Building and Running CAM within CESM <building-and-running-cam>` section of this User's Guide or the `CESM2 Quick Start Guide <http://cesm-development.github.io/cime/doc/build/html/index.html>`_. 
The main advantage of running CAM via the CESM scripts is to leverage the high level of support that those scripts provide for doing production runs of predefined experiments on supported platforms. 
The CESM scripts do things like: setting up reasonable runtime environments; automatically retrieving required input datasets from an SVN server; and archiving output files. 
The ability to customize a CAM build or runtime configuration depends on being able to use the utilities described in this document. 
Any build configuration can be set up via appropriate commandline arguments to CAM's ``configure`` utility, and any runtime configuration can be set up with appropriate arguments to CAM's ``build-namelist`` utility. 
