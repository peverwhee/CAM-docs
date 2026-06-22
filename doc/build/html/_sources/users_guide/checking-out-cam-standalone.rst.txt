***********************************
 Downloading CAM standalone
***********************************

-------------------------------------
Downloading the CAM standalone code 
-------------------------------------

.. important::

  The fully coupled model can not be run from a CAM standalone tag.  These
  tags can only be used to run F, Q, or P compsets.  The entire CESM model
  should be used (`see downloading CESM
  <http://escomp.github.io/CESM/versions/cesm2.2/html/downloading_cesm.html>`__)
  for other compsets.  Also for scientific studies it is strongly advised
  to use a released version of CESM and not use a CAM standalone checkout.
  The directions in this section are provided for users who are
  collaborating on CAM development.

CAM development tags are available through `CAM's github
repository <https://github.com/ESCOMP/CAM>`_.

The first step in downloading standalone CAM is clone the CAM git repository:
::

     % git clone https://github.com/ESCOMP/CAM
     % cd CAM

At this point you will see just one file: README.md.

The README.md file lists the current branches that the CAM repository
contains along with some basic information.

The following example shows how to checkout CAM standalone tag cam6_3_000:
::

    % git checkout cam6_3_000

If a user wishes to get the most recent CAM development code, they can
checkout the head of the cam_development branch.  Please note that this
code is the most recently committed code and while basic testing has
occurred, its use for scientific studies is not recommended.

--------------------------------
Checkout out the externals          
--------------------------------

Once the CAM code has been checked out, but before it can be used, the
external libraries that CAM uses must be checked out.

To get the externals, users need to cd to the main CAM directory and run:
::

     % bin/git-fleximod update

This will create and populate all of the external directories.

--------------------------------
Useful git commands
--------------------------------

For a listing of files that have changed since checkout...
::

    % git status 

For a description of the changes made to the working copy...
::

    % git diff  -- or -- git difftool


------------------------------------------------------------
Useful documentation about CAM development and git resources
------------------------------------------------------------

The `wiki page for CAM development <http://github.com/ESCOMP/CAM/wiki>`_
contains more detailed information.


