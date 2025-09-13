.. _ug70-building-and-running-cam:

************************
Building and Running CAM
************************

CAM can be run from either a CESM release or from a CAM development
version.  As noted previously, scientific work should only be done using a
CESM release.  Both CESM releases and CAM development versions are cloned
from git repositories.  For a CESM release see `Downloading CESM
<http://escomp.github.io/CESM/versions/cesm2.2/html/downloading_cesm.html>`__.
For CAM development versions see :doc:`Downloading CAM standalone
<checking-out-cam-standalone>`.

CAM runs are setup, built, and executed using a feature of the Common
Infrastructure for Modeling the Earth (`CIME
<https://esmci.github.io/cime/versions/master/html/index.html>`__) known as
the Case Control System (`CCS
<https://esmci.github.io/cime/versions/master/html/ccs/index.html>`__).  A
general description of using CIME for a CESM run is found in the
`CESM Quick Start
<https://escomp.github.io/CESM/versions/cesm2.2/html/quickstart.html>`__.
In this section we provide some examples using the CIME scripts to run CAM
standalone configurations.  These directions also apply to the CAM
extension models of CAM-chem, WACCM and WACCM-X.

In order to run CAM on any given machine, CIME must be configured to
support that machine.  Documentation on adding new machine support may be
found `here
<https://esmci.github.io/cime/versions/master/html/ccs/model-configuration/support-a-new-machine.html>`__.
One can see a list of supported machines by issuing the following command
(``SRCDIR`` is an environment variable containing the absolute path of the
root directory of the CESM or CAM standalone source code):
::

   % cd $SRCDIR/cime/scripts
   % ./query_config --machines

.. note::

   The instructions for building and running CAM assume you are working on
   a supported machine.

The first step to making a run is to create a case using the CIME
``create_newcase`` script, passing it a case directory name, compset, and
model resolution.
::

   % cd $SRCDIR/cime/scripts
   % ./create_newcase --case $CASEDIR/test --res ne30pg3_ne30pg3_mt232 --compset FHISTC_LTso

The argument of the ``--case`` option is the case directory name.  The
directory name can be either an absolute or relative path.  The last
component of the path will serve as the case name of the model run.  In the
example above ``CASEDIR`` is an environment variable containing an absolute
or relative pathname and ``test`` is the case name.  ``$CASEDIR/test`` is
the directory where the case configuration files and scripts to build and
run the model will be written.  The case name is used in many places,
including in directory names where the model is built, run, and output
archived, as well as in the model output filenames produced by the model
components.

The argument of the ``--compset`` option is the compset name.  This name
can be an alias (``FHISTC_LTso`` in the example above), or it can be a long
name which explicitly specifies each component of the compset.  The long
name for ``FHISTC_LTso`` is
::

   HIST_CAM70%LT_CLM60%SP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV

CAM provides aliases for supported compsets to allow reproducing well known
intermodel comparison results as well as for unsupported compsets which may
be customized for the user's particular needs.  The compset determines the
general type of run to be made and the other elements of the CIME case
control system allow the user to fine-tune the particulars of CAM's physics
and dynamics to meet each user's requirements. Compsets will be described
in much more detail in :ref:`Atmospheric configurations
<ug70-atmospheric-configurations>`.

The argument of the ``--res`` option is the alias for the horizonal
grid configuration used in the run.  The grid configuration determines
which dynamical core will be used in CAM as well as the spatial resolution
of the grid for each component model participating in the compset.  The
grid alias is an underscore separated list of the grids used by the model
components with the atmosphere grid listed first.  In this example the
atmosphere grid is ``ne30pg3`` which is a shorthand for the ``ne30np4`` SE
grid with physics run on the ``pg3`` grid used by CSLAM.  Grid resolutions
will be discussed in more detail in the section :ref:`Atmospheric
configurations <ug70-atmospheric-configurations>`.

Using the ``--case``, ``--compset``, and ``--res`` parameters of
``create_newcase`` we have specified that our case will be named ``test``,
it will be set up to run a historical time period (indicated by the first
token in the compset long name), and CAM will use the Spectral Element
dynamical core with CSLAM tracer transport at a nominal 1-degree
resolution. A new directory, ``$CASEDIR/test``, is created which contains
the files and utilities to fine-tune the CAM configuration and run the
experiment.  At this point the configuration files in the case directory
may be modified to implement desired customizations to the run.  We will
first, however, examine the results of using the default configuration
settings and simply call ``case.setup``, ``case.build``, and
``case.submit`` to finalize the case, build the executable, and run the
model:
::

  % cd $CASEDIR/test
  % ./case.setup
  % ./case.build
  % ./case.submit

.. note::

  ``case.build`` utilizes parallel compilation and can consume
  much of the node on which it is run.  The default machine configurations
  are typically set to use all the resources of a node.  If running on an
  interactive login node on a machine like NCAR's derecho, this will result
  in being logged off the system partway through the build process.  On
  derecho, if you are executing the commands on a login node, the ``qcmd``
  command can be used as follows to execute the job on a shared batch
  node:
  ::
     
    % qcmd -- ./case.build

The directory where the model build is done is
``$CIME_OUTPUT_ROOT/$CASE/bld`` where ``CIME_OUTPUT_ROOT`` and ``CASE`` are
both CIME variables.  The directory where the model is run is in variable
``RUNDIR`` which is set by default to ``$CIME_OUTPUT_ROOT/$CASE/run``.
After a successful run CAM's history files are copied to
``$DOUT_S_ROOT/atm/hist`` and the CAM log file is moved to
``$DOUT_S_ROOT/logs``

.. note::

  CIME variables are stored in XML files (with a .xml extension) in the
  case directory.  In this guide the value of a CIME variable is denoted by
  using a ``$`` sign prefix with the variable name.  ``$CIME_OUTPUT_ROOT``
  denotes the value of the variable ``CIME_OUTPUT_ROOT``.  This convention
  does not imply that ``CIME_OUTPUT_ROOT`` is an environment variable.

The values of CIME variables may be obtained using the ``xmlquery``
utility.  To see the values of the CIME variables mentioned about, from
the case directory issue the command:
::

  % ./xmlquery CIME_OUTPUT_ROOT,RUNDIR,DOUT_S_ROOT

A useful command for examining all CIME variables is
::

  % ./xmlquery --listall


.. note::

  Further, detailed information for each of the above steps can be found at:

  * `Creating a Case
    <http://esmci.github.io/cime/versions/cesm2.2/html/users_guide/create-a-case.html>`__:
    see also the `create_newcase 
    <http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/create_newcase.html>`__
    documentation. 
  * `Setting up a Case
    <http://esmci.github.io/cime/versions/cesm2.2/html/users_guide/setting-up-a-case.html>`__:
    see also the `case.setup
    <http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/case.setup.html>`__
    documentation.
  * `Building a Case
    <http://esmci.github.io/cime/versions/cesm2.2/html/users_guide/building-a-case.html>`__:
    see also the `case.build
    <http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/case.build.html>`__
    documentation.
  * `Running a Case
    <http://esmci.github.io/cime/versions/cesm2.2/html/users_guide/running-a-case.html>`__:
    see also the `case.submit
    <http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/case.submit.html>`__
    documentation.

Users are encouraged to review these sections of the CIME user's guide as
they fully describe the CIME case control system used to configure and run
CAM.

====================================
Modifying the location of case files
====================================

As described above, the files produced by building and running the model
are not written in the case directory by default.  In order to change the
location of the build objects or the model output one must change the
values of the CIME variables that determine these locations and control the
archiving.

The value of ``CIME_OUTPUT_ROOT`` may be changed from the
``create_newcase`` command-line via the argument ``--output-root OUTPUT_ROOT``.
A common use of this feature is to have the model output be written in the
case directory, e.g.,
::

  % ./create_newcase --case $CASEDIR/test --res ne30pg3_ne30pg3_mt232 --compset FHISTC_LTso \
                     --output-root $CASEDIR

After building the above case the build objects will be found in subdirectories of
``$CASEDIR/test/bld``.  After running the case the model output will be
found in ``$CASEDIR/test/run``.  But the component log files will be
missing from ``$CASEDIR/test/run`` because by default they are moved to
``$DOUT_S_ROOT/logs``.  During model development and testing it is often
convenient to turn off the short term archiving feature and 
leave all output in the run directory.  This is done by using the
``xmlchange`` utility to set the value of the CIME variable ``DOUT_S`` to
``FALSE``, i.e., from the case directory issue the command:
::

   ./xmlchange DOUT_S=FALSE

.. note::

   ``xmlchange`` is the utility (script) used to change the value of CIME
   variables stored in the env_*xml files in the case directory.  For
   details see the `xmlchange
   <http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/xmlchange.html>`__
   documentation.  ``xmlchange`` commands are usually issued from the case
   directory which contains a soft link to its source code location.

