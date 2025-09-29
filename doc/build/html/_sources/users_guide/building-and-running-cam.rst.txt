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

CAM runs are setup, built, and executed using functionality of the Common
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

**CIME Variables**: CIME maintains the case control information using a
large number of variables stored in XML format files (the files use a
``.xml`` extension).  CIME denotes these variables using uppercase names,
e.g., ``SRCROOT``, and denotes a variable's value by prefixing the name
with a ``$`` sign.  The value ``$SRCROOT`` is the absolute filepath of the
top level directory for the model source code.  This convention is the same
as the one used for UNIX shell environment variables, but CIME variables
are not environment variables (although there are a few which have the same
names as corresponding environment variables, e.g., ``USER``).

In order to run CAM on any given machine, CIME must be configured to
support that machine.  Documentation on adding new machine support may be
found `here
<https://esmci.github.io/cime/versions/master/html/ccs/model-configuration/support-a-new-machine.html>`__.
One can see a list of supported machines by issuing the following command
(``my_cesm_source`` is the absolute path of the
root directory of the CESM or CAM standalone source code):
::

   % cd my_cesm_source/cime/scripts
   % ./query_config --machines

.. tip::

   The `query_config
   <https://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/query_config.html>`__
   command can also be used to provide detailed information about the
   compsets, components, and grids supported by the model.

The first step to making a run is to create a case using the CIME
``create_newcase`` script, passing it a case directory name, compset, and
model resolution::

   % cd my_cesm_source/cime/scripts
   % ./create_newcase --case casedir --res ne30pg3_ne30pg3_mt232 --compset FHISTC_LTso

Running ``create_newcase`` creates the case directory and populates it with
XML files containing the case control variables, along with soft links for
the CIME commands which point back to the source code locations of those
commands.  Note that ``create_newcase`` will fail if the named case
directory already exists.  After the ``create_newcase`` command has run the
variable ``SRCROOT`` will contain the absolute pathname that was specified
by ``my_cesm_source``.

The argument of the ``--case`` option is the case directory name.  The
directory name can be either an absolute or relative path.  The last
component of the path will serve as the case name of the model run.  In the
example above ``casedir`` is an absolute or relative path.  After
``create_newcase`` has run the absolute path of the case directory is
stored in the variable ``CASEROOT``, and the last component of that path is
stored in the variable ``CASE``.  The case name is used in many places,
including in directory names where the model is built, run, and output
archived, as well as in the model output filenames produced by the model
components.  The value of ``CASEROOT`` will be set to ``casedir`` if
``casedir`` is an absolute path, or will be set to
``my_cesm_source/cime/scripts/casedir`` if ``casedir`` is a relative path
or a plain name.

The argument of the ``--compset`` option is the compset name.  This name
can be an alias (``FHISTC_LTso`` in the example above), or it can be a long
name which explicitly specifies each component of the compset.  The long
name for ``FHISTC_LTso`` is ::

   HIST_CAM70%LT_CLM60%SP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV

CAM provides aliases for supported compsets to allow reproducing well known
intermodel comparison results as well as for unsupported compsets which may
be customized to meet particular needs.  The compset determines the general
type of run to be made and the other elements of the CIME case control
system allow the user to fine-tune the particulars of CAM's physics and
dynamics to meet each user's requirements. Compsets will be described in
more detail in :ref:`Atmospheric configurations
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
``create_newcase`` we have specified that our case will be set up to run a
historical time period (indicated by the leading token, ``HIST``, in the
compset long name), and CAM will use the Spectral Element dynamical core
with CSLAM tracer transport at a nominal 1-degree resolution. A new
directory, ``$CASEROOT``, is created which contains the files and utilities
to fine-tune the CAM configuration and run the experiment.  At this point
the configuration files in the case directory may be modified to implement
desired customizations to the run.  We will first, however, examine the
results of using the default configuration settings and simply call
``case.setup``, ``case.build``, and ``case.submit`` to finalize the case,
build the executable, and run the model.  Change to the ``$CASEROOT``
directory and run the commands::

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
``$DOUT_S_ROOT/logs``.

The default values for the CIME variables that specify filesystem locations
are machine dependent, and come from configuration files that were set up
when CESM was ported to particular machines.  The values of CIME variables
may be obtained using the ``xmlquery`` utility.  To see the values of the
variables mentioned about, from the case directory issue the command::

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

  * `xmlquery <https://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/xmlquery.html>`__.

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
``create_newcase`` command-line via the option ``--output-root``.  A common
use of this feature is to have the model output be written in the case
directory, ``$CASEROOT``.  In the example from the section above let's
assume ``CASEROOT`` is the absolute path ``/scratch/test``.  Then to have
the build objects and output files written in the case directory we could
have issued the following command::

  % ./create_newcase --case /scratch/test --res ne30pg3_ne30pg3_mt232 --compset FHISTC_LTso \
                     --output-root /scratch

After building the above case the build objects will be found in
subdirectories of ``$CASEROOT/bld``.  After running the case the model
output will be found in ``$CASEROOT/run``.  But the component log files
will be missing from ``$CASEROOT/run`` because by default they are moved to
``$DOUT_S_ROOT/logs``.  During model development and testing it is often
convenient to turn off the short term archiving feature and leave all
output in the run directory.  This is done by using the ``xmlchange``
utility to set the value of the CIME variable ``DOUT_S`` to ``FALSE``,
i.e., from the case directory issue the command::

   ./xmlchange DOUT_S=FALSE

.. note::

   ``xmlchange`` is the utility (script) used to change the value of CIME
   variables stored in the env_*xml files in the case directory.  For
   details see the `xmlchange
   <http://esmci.github.io/cime/versions/cesm2.2/html/Tools_user/xmlchange.html>`__
   documentation.  ``xmlchange`` commands are issued from the case
   directory which contains a soft link to its source code location.

==========================
Controlling the run length
==========================

After a successful run completes following the above instructions,
examining the model output directory, ``$CASEROOT/run``, will
reveal that no model output was produced.  This is because the
length of the run, which is determined by the variables ``STOP_OPTION`` and
``STOP_N``, is set to 5 days by default.  Since the default output
frequency for CAM and CLM is monthly, the default run length is too short to
produce any history output.  Restart files are written at the end of the
run so one possibility is to restart the run and extend it out to a month.
Another option is to redo the run by setting the run length to a month and
re-issuing the ``case.submit`` command.  Do this from the case directory as
follows: ::

  ./xmlchange STOP_OPTION=nmonths,STOP_N=1
  ./case.submit

More details about controlling the run length and restarting a run are
presented in the `CESM tutorial materials
<https://ncar.github.io/CESM-Tutorial/notebooks/modifications/xml/run_length.html>`__.

If instead of a longer run the real interest is in seeing the model output
at the end of 5 days, then the default output frequency of CAM
can be changed with simple namelist modifications in ``user_nl_cam``.  This
is discussed in detail in the section :ref:`Model Output
<ug70-model-output>`.


