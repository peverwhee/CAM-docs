.. _ug70-model-output:

**************************
Model Output:
**************************

CAM produces a series of NetCDF format history files containing atmospheric
gridpoint data generated during the course of a run. It also produces a
series of NetCDF format restart files necessary to continue a run once it
has terminated successfully and a series of initial conditions files that
may be used to initialize new simulations.  See the `NetCDF Users Guide
<https://docs.unidata.ucar.edu/nug/current/index.html>`__ for more
information.

History files contain model data values written at specified frequencies
during a run.  These files contain metadata which conforms to the `CF
metadata conventions <http://cfconventions.org/>`__ to facilitate
post-processing and sharing of the data.  Options are available to record
averaged, instantaneous, maximum, minimum, or local time values on a
field-by-field basis. If the user wishes to see a field written at more
than one time frequency (e.g. daily, hourly), that field may be written to
multiple history streams with the desired sample frequencies.  This
functionality is available via setting namelist variables as described in
detail below.

Initial condition files contain an instantaneous snapshot of only the
variables required by the prognostic model to do a cold start.  These files
also contain metadata that conforms to the CF Conventions.  The included
fields, however, are not customizable.  They are set in the model logic as
determined by the model configuration.  The frequency with which inital
files are written is customizable via the namelist variable ``inithist``.
By default initial files are written yearly on Jan 1.

Restart files contain an instantaneous snapshot of the entire model state
which allows a model to be continued exactly as if it had not stopped.
These files do not contain CF conforming metadata and are not meant for
analysis or visualization.  The included fields are not customizable, but
are set by logic determined by the model configuration.  The output
frequency of restart files must be coordinated between all model
components, hence is controlled by the CIME variables ``REST_OPTION`` and
``REST_N``.  By default those variables are set to the values
``$STOP_OPTION`` and ``$STOP_N`` respectively so that restart files are
always written at the end of a run.

==================================
 Customizing output History Fields
==================================

CAM writes a sequence of time samples to each of its specified history
files.  By default, CAM will output a set of fields to a single monthly
average history file.  There are namelist parameters which allow the user
to customize output from their run. Up to ten history streams may be
output, each with its own set of characteristics.  This section will
highlight some of the most commonly used history namelist settings.

The following namelist settings are specified to customize each output
stream desired.  Within the stream, individual fields may be specified to be
instantaneous or averaged along with other settings.  See the `CAM Namelist
Definitions
<http://www.cesm.ucar.edu/models/cesm2/settings/2.2.0/cam_nml.html>`__ page
to review the ``fincl1`` defintion for more options for the fields.

- ``finclX`` - List the fields to include in the output of stream #X (X=1-10)
- ``fexclX`` - List the fields to exclude from the output stream #X (X=1-10)

.. note:: **Confusing file naming convention:**

   The namelist variables ``fincl1`` and ``fexcl1`` affect history stream
   ``1``.  This stream will be written to files whose names include the
   string ``cam.h0``.  Variables ``fincl2`` and ``fexcl2`` affect history
   stream ``2`` which is written to files whose names include the string
   ``cam.h1``.  And similarly, variables ``finclX`` and ``fexclX`` affect
   history stream ``X`` which is written to files whose names include the
   string ``cam.hY`` where ``Y = X-1``.
   
The following three namelist variables are arrays up to length 10 which
specify characteristics for the output streams.

- ``nhtfrq`` - Array of write frequencies for each history file series.  If
  ``nhtfrq(i) = 0``, then stream ``i`` will be a monthly average.  If
  ``nhtfrq(i) > 0``, the frequency of stream ``i`` is specified as number
  of timesteps.  If ``nhtfrq(i) < 0``, frequency of stream ``i`` is
  specified as number of hours, e.g., ``nhtfrq(2)=-24`` sets stream ``2``
  output to be daily.  By default stream ``1`` is monthly and the
  other streams are all daily.

- ``ndens`` - Array of output precision for each stream.  Set to 1 to
  output double precision reals, and 2 to output single precision.  By
  default output of all streams is single precision.

- ``mfilt`` - Array of the maximum number of time samples to output to a
  file for each stream.  By default stream ``1`` contains a single time
  sample (the monthly output) and all other streams contain 30 time
  samples.

There are also namelist settings which control output in a general way.  

- ``empty_htapes`` - turn off all default output and only write out the
  fields explicitly set via ``finclX`` settings.  Setting
  ``empty_htapes=.true.`` is a convenient way to customize the output to
  contain exactly the desired fields without having to list a potentially
  large number of default fields in ``fexclX`` variables.

- ``history_YYY`` - add fields for specific diagnostic purposes to the
  default output.  For the complete listing go to the `namelist page
  <http://www.cesm.ucar.edu/models/cesm2/settings/2.2.0/cam_nml.html>`_ and
  search for namelist variables with the ``history_`` prefix
  (i.e. ``history_amwg``, ``history_clubb``, etc.)

--------------------------------------------------------
Default History Fields and the Master Field List
--------------------------------------------------------

CAM is set up by default to output a set of fields to a single monthly
history stream. There is a much larger set of available fields, known as
the "Master Field List," from which the user can choose fields of interest
to add to a history stream via namelist settings. Both the set of default
fields and the master field list depend on how CAM is configured.

The variables in the Master Field List are written to CAM's log file after
the header line ::

  ******* MASTER FIELD LIST *******

Immediately below that list of variables are lists for the variables that
will be written to each of the history streams.  Those lists are determined
by the default output as modified by user customizations.  The final
history stream (stream 12) are the fields written to the initial conditions
file.  This stream is not customizable via ``fincl`` and ``fexcl``.  The
variable names for this stream appear in the log output with the suffix
"&IC".  This suffix is used internally by CAM and is not part of the name
written to the file, e.g., the field "PS&IC" is written to field "PS" in
the initial conditions file.

.. caution::

  The master field list may contain some fields that are not actually
  available for output.  Fields added to the master field list are
  determined by logic in the source code.  However it's possible that a
  field is added but never computed or written to any history stream (this
  is a bug that should be reported).  When adding non-default fields to the
  history file it's important to check that the fields contain reasonable
  data before doing a long run.

----------------------------------------
General Features of History Files
----------------------------------------

Each time sample in a history file has an associated timestamp which
conforms to the CF metadata conventions for `time coordinates
<https://cfconventions.org/Data/cf-conventions/cf-conventions-1.12/cf-conventions.html#time-coordinate>`__.
The time unit used in CAM's output files is "days since reference date"
where the reference date is passed to CAM by the coupler at initialization.
Date information is handled by the driver since it must be coordinated
between all model components.  The variables relevant to the timestamps are
the following (from the output of the NetCDF ``ncdump`` utility): ::

        double time(time) ;
                time:long_name = "time" ;
                time:units = "days since 0001-01-01 00:00:00" ;
                time:calendar = "noleap" ;
                time:bounds = "time_bnds" ;

        double time_bnds(time, nbnd) ;
                time_bnds:long_name = "time interval endpoints" ;
		time_bounds:units = "days since 0001-01-01 00:00:00" ;
		time_bounds:calendar = "noleap" ;

        int date(time) ;
                date:long_name = "current date (YYYYMMDD)" ;

        int datesec(time) ;
                datesec:long_name = "current seconds of current date" ;


The variable names, ``time``, ``time_bnds``, ``date``, and ``datesec`` are
all local conventions.  The CF conventions identify the values in the
variables ``time`` and ``time_bnds`` as time coordinates by the form of the
units attribute ``days since 0001-01-01 00:00:00``. The reference date is
in the form YYYY-MM-DD HH:MM:SS where YYYY, MM, DD, HH, MM, SS are year,
month, day, hour, minute, second respectively, and a missing timezone
defaults to UTC. The ``calendar`` and ``bounds`` attributes are also part
of CF. The ``calendar`` value ``noleap`` denotes a calendar with no leap
years (every year is 365 days). The attribute ``time:bounds = "time_bnds"``
denotes that the variable with the name ``time_bnds`` contains the
timestamps that bound the time intervals over which an operation such as
computing an averager or a minimum or maximum value has been applied.

Whether or not the interval specified by ``time_bnds`` is relevent depends
on the individual variables, e.g., a single stream can contain both
instantaneous and time averaged fields. The type of the time operation that
has been applied is contained in the ``cell_methods`` attribute of each
variable, e.g., ::

        float T(time, lev, lat, lon) ;
                T:mdims = 1 ;
                T:units = "K" ;
                T:long_name = "Temperature" ;
                T:cell_methods = "time: mean" ;


The ``cell_methods`` attribute for the temperature variable indicates that
it is being output as a time averaged field. If temperature was
instantaneous then the ``cell_methods`` attribute would either not be
present since instantaneous is the default, or it can be present with the
value of ``point``.  `CF cell methods
<https://cfconventions.org/Data/cf-conventions/cf-conventions-1.12/cf-conventions.html#cell-methods>`__
for details on this attribute.

The variables ``date`` and ``datesec`` are for convenience only; they don't
play any role in terms of CF compliance. The ``date`` variable is an
integer which is encoded to contain the digits YYYYMMDD where YYYY, MM, and
DD are the year, month, and day of month respectively. ``datesec`` is the
integer number of seconds past 0Z in the current day. The variables
``date`` and ``datesec`` are redundant in the sense that they can be
recovered from the time variable via a date calculation using the specified
calendar.

-----------------------------
Timestamps and time intervals
-----------------------------

Prior to CAM7 the timestamp associated with each time sample in a history
file was the model time at the end of the timestep during which the model
writes data to the disk.  In the case of instantaneous data the meaning is
clear. However when the data is representative of a time interval, that
timestamp corresponds to the end of the interval.  While this is CF
compliant, was often a point of confusion when looking at history
files. Since the endpoint of one interval is the same as the beginning of
the next interval, when looking at a monthly average for January, which had
timestamp of 0Z on Feb 01, at first glance the timestamp would seem to
correspond to a February average. Hence it was necessary for post
processing tools to make use of the data in the ``time_bnds`` variable so
that the time interval endpoints could be used to compute an interval
midpoint which is the more appropriate timestamp to associate with the
interval.

.. important::

 For convenience, and to enable a larger number of post-processing tools to
 work well with history output, in CAM7 the time coordinate for variables
 that depend on a time interval has been moved to the midpoint of that
 interval.

A consequence of moving the time coordinate to interval midpoints is that
it is no longer possible to have both instantaneous and time averaged data
output in the same file.  Instantaneous data is written at the frequency
specified by ``nhtfrq`` and these times are the endpoints of the intervals
between time samples.  Hence two time coordinate variables would be
required for a file containing both instantaneous and time averaged data.
The time coordinate in a history file is implemented using the unlimited
record dimension, and only one of these is allowed in the NetCDF format
used for history files.  To get around this issue history streams are now
written to two files: one containing instantaneous data and the other
containing all data that depends on the time interval.  These files are
distinquished by modifying the filename.  For example, for stream ``1`` all
averaged and other data that depends on the time interval is written to
file whose name contains the string ``.h0a.``, while all instantaneous data
is written to a file whose name contains the string ``.h0i.``.  Prior to
CAM7 all the data from stream ``1`` was written to a file whose name
contained the string ``.h0.``.

.. note::

 There will be an instantaneous file ``.hXi.`` written for every output
 stream, even if the default and user specified variables in the stream all
 depend on the time interval.  This is because there are a handful of
 instantaneous variables that are added to every stream which are not under
 user control.  These are scalar variables that provide data on GHG and
 Solar forcing.

--------------------------------------
Multiple time samples in a single file
--------------------------------------

CAM's default history output is a sequence of monthly averaged fields,
written with one time sample per file. This restriction is related to the
default file naming scheme which uses the string "YYYY-MM" to indicate the
year and month of the average contained in the file. However in general it
is possible to write multiple time samples in any of the history file
streams that don't contain monthly time intervals.  The timestamp in the
filename for files with multiple time samples is the one corresponding to
the first sample in the file.  This timestamp is not adjusted to the
interval midpoint for time averaged data.

.. note::

 Prior to CAM7 the first time sample in the first file for all streams
 except the one with monthly frequency was an "extra" sample representing the
 initial conditions as modified by the moist physics adjustments.  This
 feature has been turned off by default in CAM7.  That allows all files for
 a stream to contain the same number of valid time samples.

======================================
Analyzing and Visualizing Model Output
======================================

The primary resource for visualizing and analyzing history file data is the
`AMWG Diagnostics Framework (ADF) python package
<https://github.com/NCAR/ADF>`__.  Another good resource for Python based
tools and Jupyter notebooks is the `CESM Tutorial -- Diagnostics
<https://ncar.github.io/CESM-Tutorial/notebooks/diagnostics/diagnostics.html>`__.
To manipulate the data and metadata in history files using the
command-line, the `NCO Operators <https://nco.sourceforge.net/>`__, which
were originally designed to work with CAM's output, are often the tool that
gets the job done most efficiently.  For a comprehensive list of software
tools for interacting with NetCDF files, view the UNIDATA maintained link
`Software for Manipulating or Displaying NetCDF Data
<http://www.unidata.ucar.edu/software/netcdf/software>`__.

.. note::

 By default all output files are written using the NetCDF "64-bit Data
 Format (CDF-5)".  This format requires the NetCDF library to be version
 4.4.0 or later.

