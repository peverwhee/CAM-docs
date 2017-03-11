.. _chemistry:

*********
Chemistry
*********

This section contains a description of the neutral constituent chemical
options available CAM and , including different chemical schemes,
emissions, boundary conditions, lightning, dry depositions and wet
removal; 2) the photolysis approach; 3) numerical algorithms used to
solve the corresponding set of ordinary differential equations.; 4)
additions to superfast chemistry.

Chemistry Schemes
-----------------

For CAM-Chem, an extensive tropospheric chemistry option is available
(trop mozart), as well as an extensive tropospheric and stratospheric
chemistry (trop-strat mozart) as discussed in detail in , including a
list of all species and reactions. Furthermore, a superfast chemistry
option is available for CAM, as discussed in
Section [sec:chem\ :sub:`s`\ uperfast]. For each chemical scheme,
CAM-chem uses the same chemical preprocessor as MOZART-4. This
preprocessor generates Fortran code for each specific chemical
mechanism, allowing for an easy update and modification of existing
chemical mechanisms. In particular, the generated code provides two
chemical solvers, one explicit and one semi-implicit, which the user
specifies based on the chemical lifetime of each species. For all
supported compsets, this generated code is available in a sub-directory
of atm/src/chemistry.

The Bulk Aerosol Model
~~~~~~~~~~~~~~~~~~~~~~

CAM4-chem uses the bulk aerosol model discussed in and . This model has
a representation of aerosols based on the work by and , i.e. sulfate
aerosol is formed by the oxidation of SO\ :math:`_{2}` in the gas phase
(by reaction with the hydroxyl radical) and in the aqueous phase (by
reaction with ozone and hydrogen peroxide). Furthermore, the model
includes a representation of ammonium nitrate that is dependent on the
amount of sulfate present in the air mass following the parameterization
of gas/aerosol partitioning by . Because only the bulk mass is
calculated, a lognormal distribution is assumed for all aerosols using
different mean radius and geometric standard deviation . The conversion
of carbonaceous aerosols (organic and black) from hydrophobic to
hydrophilic is assumed to occur within a fixed 1.6 days . Natural
aerosols (desert dust and sea salt) are implemented following and and
the sources of these aerosols are derived based on the model calculated
wind speed and surface conditions. In addition, secondary-organic
aerosols (SOA) are linked to the gas-phase chemistry through the
oxidation of atmospheric non-methane hydrocarbons (NMHCs), as in .

CAM-Chem using the Modal Aerosol Model
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CAM-Chem has the ability to run with two modal aerosols models, the MAM3
and MAM7 . The Modal Aerosols Model, is described in Section 4.8.2. In
CAM5-Chem, the gase-phase chemistry is coupled to Modal Aerosol Model in
chemical species O\ :math:`_{3}`, OH, HO\ :math:`_{2}` and
NO\ :math:`_{3}`, as derived from the chemical mechanism and not from a
climatoloty. The tropospheric gas-phase and heterogeneous reactions as
discribed in Section 4.8.2. are added to the standard MAM chemical
mechanism.

Trop MOZART Chemistry
~~~~~~~~~~~~~~~~~~~~~

The extensive tropospheric chemistry scheme represents a minor update to
the MOZART-4 mechanism, fully described in . In particular, we have
included C\ :math:`_{2}`\ H\ :math:`_{2}`, HCOOH, HCN and
CH\ :math:`_{3}`\ CN. Reaction rates have been updated to JPL-2006 . A
minor update has been made to the isoprene oxidation scheme, including
an increase in the production of glyoxal. This mechanism is mainly of
relevance in the troposphere and is intended for simulations for which
long-term trends in the stratospheric composition are not crucial.
Therefore, in this configuration, the stratospheric distributions of
long-lived species (see discussion below) are specified from previously
performed WACCM simulations ; see Section [sec:boundary]).

Trop-Strat MOZART Chemistry
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The extensive tropospheric and stratospheric chemistry includes the full
stratospheric chemistry from , with an updated enforcement of the
conservation of total chlorine and total bromine under advection to
improve the performance of the model in simulating the ozone hole. In
addition, we have updated the heterogeneous chemistry module to reflect
that the model was underestimating the supercooled ternary solution
(STS) surface area density (SAD), see more detail in
Section [sec:waccm]; , Kinnison et al, 2012, (in prepareation).

SOA calculation in CAM-Chem
~~~~~~~~~~~~~~~~~~~~~~~~~~~

An SOA simulation of intermediate complexity is also available in
CAM-Chem. This is based on the 2-product model scheme of , as
implemented in CAM-Chem by . This treats the products of VOC oxidation
as semi-volatile species, which re-partition every time step based on
the temperature (enthalpy of vaporization of 42 kJmol-1) and organic
aerosol mass available for condensation of vapours . In CAM-Chem we
treat secondary organic aerosol formation from the products of isoprene,
monoterpene and aromatic (benzene, toluene and xylene) oxidation by OH,
O\ :math:`_{3}` and NO\ :math:`_{3}`. The yields and partitioning
coefficients are based on smog chamber studies . The SOA calculation is
setup to run with biogenic emissions calucated by the MEGAN2.1 model
(see Section [sec:Emissions]).

Emissions
---------

Surface emissions are used in as a flux boundary condition for the
diffusion equation of all applicable tracers in the planetary
boundary-layer scheme. The surface flux files used in the released
version are discussed in and conservatively remapped from their original
resolution (monthly data available every decade at 0.5x0.5) to (monthly
data every year at 1.9x2.5). The remapping is made offline to avoid the
internal remapping, which consists of a simple linear interpolation and
therefore does not ensure exact conservation of emissions between
resolutions.

Emissions of Trace Gases
~~~~~~~~~~~~~~~~~~~~~~~~

Emissions for historic and future model simulations are based on ACCMIP
() and different RCP scenarios, which are available for the years
1850-2000, and 2000-2100.

Additional emissions are available for a short period covering
1992-2010, as discussed in . More specifically, for 1992-1996, which is
prior to satellite-based fire inventories, monthly mean averages of the
fire emissions for 1997-2008 from GFED2 are used for each year. For
2009-2010, fire emissions are from FINN (Fire INventory from NCAR) . If
running with FINN fire emissions, additional species are availabel:
NO\ :math:`_{2}`, BIGALD, CH\ :math:`_{3}`\ COCHO,
CH\ :math:`_{3}`\ COOH, CRESOL, GLYALD, HYAC, MACR, MVK. Most of the
anthropogenic emissions come from the POET (Precursors of Ozone and
their Effects in the Troposphere) database for 2000 . The anthropogenic
emissions (from fossil fuel and biofuel combustion) of black and organic
carbon determined for 1996 are from . For SO\ :math:`_{2}` and
NH\ :math:`_{3}`, anthropogenic emissions are from the EDGAR-FT2000 and
EDGAR-2 databases, respectively (http://www.mnp.nl/edgar/).

For Asia, these inventories have been replaced by the Regional Emission
inventory for Asia (REAS) with the corresponding annual inventory for
each year simulated . Only the Asian emissions from REAS vary each year,
all other emissions are repeated annually for each year of simulation.
The DMS emissions are monthly means from the marine biogeochemistry
model HAMOCC5, representative of the year 2000 .

Additional emissions (volcanoes and aircraft) are included as
three-dimensional arrays, conservatively-remapped to the CAM-chem grid.
The volcanic emission are from and the aircraft (NO:math:`_{2}`)
emissions are from . In the case of volcanic emissions (SO:math:`_{2}`
and SO\ :math:`_{2}`), an assumed 2% of the total sulfur mass is
directly released as SO\ :math:`_{2}`. SO\ :math:`_{2}` emissions from
continuously outgassing volcanoes are from the GEIAv1 inventory (Andres
and Kasgnoc, 1998). Totals for each year and emitted species are listed
in , Table 7. Aerosol Emissions available to be used in CAM5-Chem are
described above (Section 4.8.1.).

Biogenic emissions
~~~~~~~~~~~~~~~~~~

Biogenic emissions can be calculated by the Model of Emissions of Gases
and Aerosols from Nature version 2.1 (MEGAN2.1) . In this case, MEGAN2.1
is coupled to the CESM atmosphere and land model. Biogenic emissions of
volatile organic compounds (i.e. isoprene and monoterpenes) are
calculated based upon emission factors, land cover (LAI and PFT), and
driving meteorological variables. CO\ :math:`_{2}` effect on isoprene
emission is also included . Emission factors of different MEGAN
compounds can be specified from mapped files or based on PFTs. These are
made available for atmospheric chemistry, unless the user decides to
explicitly set those emissions using pre-defined (i.e. contained in a
file) gridded values. Details of this implementation in the CLM3 are
discussed in and : Vegetation in the CLM model is described by 17 plant
function types (PFTs, see ). Present-day land cover data such as leaf
area index are consistent with MODIS land surface data sets . Alternate
land cover and density can be either specified or interactively
simulated with the dynamic vegetation model (CLMCNDV) or the carbon
nitrogen model (CLMCN) of the CLM for any time period of interest.
Additional namelist parameters have been included to facilitate the
mapping between the emissions in MEGAN2.1 (147 species) and the chemical
mechanism. Surface emissions without biogenic emissions have to be used
if the MEGAN2.1 model produces biogenic emissions to prevent double
counting.

Boundary conditions
-------------------

Lower boundary conditions
~~~~~~~~~~~~~~~~~~~~~~~~~

For all long-lived species (methane and longer lifetimes, in addition to
hydrogen and methyl bromide) , the surface concentrations are specified
using the historical reconstruction from . In addition, for
CO\ :math:`_{2}` and CH\ :math:`_{4}`, an observationally-based seasonal
cycle and latitudinal gradient are imposed on the annual average values
provided by . These values are used in the model by overwriting at each
time step the corresponding model mixing ratio in the lowest model level
with the time (and latitude, if applicable) interpolated specified
mixing ratio.

Specified stratospheric distributions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For the trop-mozart chemistry, no stratospheric chemistry is explicitly
represented in the model. Therefore, it is necessary to ensure a proper
distribution of some chemically-active stratospheric (namely
O\ :math:`_{3}`, NO, NO\ :math:`_{2}`, HNO\ :math:`_{3}`, CO,
CH\ :math:`_{4}`, N\ :math:`_{2}`\ O, and
N\ :math:`_{2}`\ O\ :math:`_{5}`) species, as is the case for MOZART-4.
This monthly-mean climatological distribution is obtained from WACCM
simulations covering 1950-2005 . Because of the vast changes that occur
over that time period, our data distribution provides files for three
separate periods: 1950-1959, 1980-1989 and 1996-2005. This ensure that
users can perform simulations with a stratospheric climatology
representative of the pre-CFC era, as well as during the high CFC and
post-Pinatubo era. Additional datasets for different RCP runs are also
available or can easily be constructed if necessary.

Upper boundary condition
~~~~~~~~~~~~~~~~~~~~~~~~

The model top at about 40km is considered a rigid lid (no flux across
that boundary) for all chemical species. For trop-mozart

Lightning
---------

The emissions of NO from lightning are included as in , i.e. using the
Price parameterization (, scaled to provide a global annual emission of
3-4 Tg(N)/year. The vertical distribution follows as in . In addition,
the strength of intra-cloud (IC) lightning strikes is assumed to be
equal to cloud-to-ground strikes, as recommended by .

Lightning NOx can be modifid in the namelist. For CAM5-Chem, lightning
NOx is increased by a factor of 3 to reach the same emissions of 3-4
Tg(N)/year.

Dry deposition
--------------

Dry deposition is represented following the resistance approach
originally described in , as discussed in , this earlier paper was
subsequently updated and we have included all updates . Following this
approach, all deposited chemical species (the specific list of deposited
species is defined along with the chemical mechanisms, see section 4)
are mapped to a weighted-combination of ozone and sulfur dioxide
depositions; this combination represents a definition of the ability of
each considered species to oxidize or to be taken up by water. In
particular, the latter is dependent on the effective Henry’s law
coefficient. While this weighting is applicable to many species, we have
included specific representations for CO/H\ :math:`_{2}` and
peroxyacetylnitrate (PAN) . Furthermore, it is assumed that the surface
resistance for SO\ :math:`_{2}` can be neglected . Finally, following ,
the deposition velocities of black and organic carbonaceous aerosols are
specified to be 0.1 cm/s over all surfaces. Dust and sea-salt are
represented following and .

The computation of deposition velocities in CAM-chem takes advantage of
its coupling to the Community Land Model (CLM; http://www.cesm.ucar.edu/
models/cesm1.0/ clm/index.shtml). In particular, the computation of
surface resistances in CLM leads to a representation at the level of
each plant functional type (Table 1) of the various drivers for
deposition velocities. The grid-averaged velocity is computed as the
weighted-mean over all land cover types available at each grid point.
This ensures that the impact on deposition velocities from changes in
land cover, land use or climate is taken into account. All species in
the mechanism are per default affected by dry deposition if depostion
velocities are defined in the model.

Wet removal
-----------

Wet removal of soluble gas-phase species is the combination of two
processes: in-cloud, or nucleation scavenging (rainout), which is the
local uptake of soluble gases and aerosols by the formation of initial
cloud droplets and their conversion to precipitation, and below-cloud,
or impaction scavenging (washout), which is the collection of soluble
species from the interstitial air by falling droplets or from the liquid
phase via accretion processes .

Removal is modeled as a simple first-order loss process
X\ :math:`_{iscav}`
=X\ :math:`_{i} \cdot `\ F\ :math:`\cdot (1- exp(- \lambda ~ \Delta`\ t)).
In this formula, X\ :math:`_{iscav}` is the species mass (in kg) and
X\ :math:`_{i}` scavenged in time step :math:`\Delta`\ t , F is the
fraction of the grid box from which tracer is being removed, and
:math:`\lambda` is the loss rate. In-cloud scavenging is proportional to
the amount of condensate converted to precipitation, and the loss rate
depends on the amount of cloud water, the rate of precipitation
formation, and the rate of tracer uptake by the liquid phase.
Below-cloud scavenging is proportional to the precipitation flux in each
layer and the loss rate depends on the precipitation rate and either the
rate of tracer uptake by the liquid phase (for accretion processes), the
mass-transfer rate (for highly soluble gases and small aerosols), or the
collision rate (for larger aerosols).

In CAM-chem two separate parameterizations are available: from MOZART-2
and . The distinguishing features of the Neu and Prather scheme are
related to three aspects of the parameterization: 1) the partitioning
between in-cloud and below cloud scavenging, 2) the treatment of soluble
gas uptake by ice and 3) the Neu and Prather scheme uniquely accounts
for the spatial distribution of clouds in a column and the overlap of
condensate and precipitation. Given a cloud fraction and precipitation
rate in each layer, the scheme determines the fraction of the gridbox
exposed to precipitation from above and that exposed to new
precipitation formation under the assumption of maximum overlap of the
precipitating fraction. Each model level is partitioned into as many as
four sections, each with a gridbox fraction, precipitation rate, and
precipitation diameter: 1) Cloudy with precipitation falling through
from above; 2) Cloudy with no precipitation falling through from above;
3) Clear sky with precipitation falling through from above; 4) Clear sky
with no precipitation falling from above. Any new precipitation
formation is spread evenly between the cloudy fractions (1 and 2). In
region 3, we assume a constant rate of evaporation that reduces both the
precipitation area and amount so that the rain rate remains constant.
Between levels, we average the properties of the precipitation and
retain only two categories, precipitation falling into cloud and
precipitation falling into ambient air, at the top boundary of each
level. If the precipitation rate drops to zero, we assume full
evaporation and random overlap with any precipitating levels below. Our
partitioning of each level and overlap assumptions are in many ways
similar to those used for the moist physics in the ECMWF model .

The transfer of soluble gases into liquid condensate is calculated using
Henry’s Law, assuming equilibrium between the gas and liquid phase.
Nucleation scavenging by ice, however, is treated as a burial process in
which trace gas species deposit on the surface along with water vapor
and are buried as the ice crystal grows. have found that the burial
model successfully reproduces the molar ratio of HNO\ :math:`_{3}` to
H\ :math:`_{2}`\ O on ice crystals as a function of temperature for a
large number of aircraft campaigns spanning a wide variety of
meteorological conditions. We use the empirical relationship between the
HNO\ :math:`_{3}`:H:math:`_{2}`\ O molar ratio and temperature given by
to determine in-cloud scavenging during ice particle formation, which is
applied to nitric acid only. Below-cloud scavenging by ice is calculated
using a rough representation of the riming process modeled as a
collision-limited first order loss process. provide a full description
of the scavenging algorithm.

On the other hand, the Horowitz approach uses the rain generation
diagnostics from the large-scale and convection precipitation
parameterizations in CAM; equilibrium between gas-phase and liquid phase
is then assumed based on the effective Henry’s law.

Photolytic Approach (Neutral Species)
=====================================

The calculation of the photolysis coefficients is divided into two
regions: (1) 120 nm to 200 nm (33 wavelength intervals); (2) 200 nm to
750 nm (67 wavelength intervals). The total photolytic rate constant (J)
for each absorbing species is derived during model execution by
integrating the product of the wavelength dependent exo-atmospheric flux
(F:math:`_{exo}`); the atmospheric transmission function (or normalized
actinic flux) (N:math:`_A`), which is unity at the top of atmosphere in
most wavelength regions; the molecular absorption cross-section
(:math:`\sigma`); and the quantum yield (:math:`\phi`). The
exo-atmospheric flux over these wavelength intervals can be specified
from observations and varied over the 11-year solar sunspot cycle (see
section [sec:short\ :sub:`w`\ ave]).

The wavelength-dependent transmission function is derived as a function
of the model abundance of ozone and molecular oxygen. For wavelengths
greater than 200 nm a normalized flux lookup table (LUT) approach is
used, based on the 4-stream version of the Stratosphere, Troposphere,
Ultraviolet (STUV) radiative transfer model (S. Madronich, personal
communication), . The transmission function is interpolated from the LUT
as a function of altitude, column ozone, surface albedo, and zenith
angle. The temperature and pressure dependences of the molecular cross
sections and quantum yields for each photolytic process are also
represented by a LUT in this wavelength region. At wavelengths less than
200 nm, the wavelength-dependent cross section and quantum yields for
each species are specified and the transmission function is calculated
explicitly for each wavelength interval. There are two exceptions to
this approach. In the case of J(NO) and J(O\ :math:`_2`), detailed
photolysis parameterizations are included inline. In the Schumann-Runge
Band region (SRBs), the parameterization of NO photolysis in the
:math:`\delta`-bands is based on . This parameterization includes the
effect of self-absorption and subsequent attenuation of atmospheric
transmission by the model-derived NO concentration. For
J(O\ :math:`_2`), the SRB and Lyman-alpha parameterizations are based on
and , respectively.

While the lookup table provides explicit quantum yields and
cross-sections for a large number of photolysis rate determinations,
additional ones are available by scaling of any of the explicitly
defined rates. This process is available in the definition of the
chemical preprocessor input files (see for a complete list of the
photolysis rates available). The impact of clouds on photolysis rates is
parameterized following . However, because we use a lookup table
approach, the impact of aerosols (tropospheric or stratospheric) on
photolysis rates cannot be represented.

As an extension of MOZART-4 and to provide the ability to seamlessly
perform tropospheric and stratospheric chemistry simulations, the
calculation of photolysis rates for wavelengths shorter than 200 nm is
included; this was shown to be important for ozone chemistry in the
tropical upper troposphere . In addition, because the standard
configuration of CAM only extends into the lower stratosphere (model top
is usually around 40 km), an additional layer of ozone and oxygen above
the model top is included to provide a very accurate representation of
photolysis rates in the upper portion of the model as compared to the
equivalent calculation using a fully-resolved stratospheric
distribution.

In addition, tropospheric photolysis rates can be computed
interactively. Users interested in using this capability have to contact
the Chemistry-CLimate Working Group Liaison as this is an unsupported
option.

Numerical Solution Approach
===========================

Chemical and photochemical processes are expressed by a system of
time-dependent ordinary differential equations at each point in the
spatial grid, of the following form:

.. math::
   :label: solver1

   \frac{d\vec{y}}{dt} = \vec{P}(\vec{y}, t) - \vec{L}(\vec{y}, t) \cdot \vec{y}

.. math:: \vec y(t) = \{y_i(t)\} \quad i = 1, 2, \ldots, N

 where :math:`\vec y` is the vector of all solution variables (chemical
species), :math:`N` is the number of variables in the system, and
:math:`y_i` represents the :math:`i^{th}` variable. :math:`\vec P` and
:math:`\vec L` represent the production and loss rates, which are, in
general, non-linear functions of the :math:`y_i`. This system of
equations is solved via two algorithms: an explicit forward Euler
method:

.. math::
   :label: solver2

   y_i^{n+1} = y_i^n + \Delta t \cdot f_i(t_{n}, y^{n})

in the case of species with long lifetimes and weak forcing terms
(e.g., N\ :math:`_2`\ O), and a more robust implicit backward Euler
method:

.. math::
   :label: solver3

   y_i^{n+1} = y_i^n + \Delta t\cdot f_i(t_{n+1}, y^{n+1})

for species that comprise a\`\`stiff system" with short lifetimes and
strong forcings (e.g., OH). Here :math:`n` represents the time step
index. Each method is first order accurate in time and conservative. The
overall chemistry time step, :math:`\Delta t = t_{n+1}-t_n`, is fixed at
30 minutes. Preprocessing software requires the user to assign each
solution variable, :math:`y_i`, to one of the solution schemes. The
discrete analogue for methods ([solver2]) and ([solver3]) above results
in two systems of algebraic equations at each grid point. The solution
to these algebraic systems for equation ([solver2]) is straightforward
(i.e., explicit). The algebraic system from the implicit method
([solver3]) is quadratically non-linear. This system can be written as:

.. math::
   :label: solver4

   \vec{G}(\vec{y}^{\,\, n+1})=\vec{y}^{\,\, n+1}-\vec{y}^{\,\, n}- \Delta t\cdot\vec{f}(t_{n+1},\vec{y}^{\,\, n+1})=0

Here :math:`G` is an :math:`N`-valued, non-linear vector function,
where :math:`N` equals the number of species solved via the implicit
method. The solution to equation ([solver4]) is solved with a Newton-
Raphson iteration approach as shown below:

.. math::
   :label: solver6

   \vec{y}^{\,\, n+1}_{m+1} = \vec{y}^{\,\, n+1}_m - \vec{J} \cdot \vec{G}(\vec{y}^{\,\, n+1}_m);  \; m=0,1,\ldots, M    

Where :math:`m` is the iteration index and has a maximum value of ten.
The elements of the Jacobian matrix :math:`\vec J` are given by:

.. math:: 
   :label:

   J_{ij}=\frac{\partial G_i}{\partial y_j}

The iteration and solution of equation ([solver5]) is carried out with
a sparse matrix solution algorithm. This process is terminated when the
given solution variable changes in a relative measure by less than a
prescribed fractional amount. This relative error criterion is set on a
species by species basis, and is typically 0.001; however, for some
species (e.g., O\ :math:`_3`), where a tighter error criterion is
desired, it is set to 0.0001. If the iteration maximum is reached (for
any species) before the error criterion is met, the time step is cut in
half and the solution to equation ([solver5]) is iterated again. The
time step can be reduced five times before the solution is accepted.
This approach is based on the work of and ; see also .

Superfast Chemistry
===================

Chemical mechanism
------------------

The super-fast mechanism was developed for long coupled
chemistry-climate simulations, and is based on an updated version of the
full non-methane hydrocarbon effects (NMHC) chemical mechanism for the
troposphere and stratosphere used in the Lawrence Livermore National
Laboratory off-line 3D global chemistry-transport model (IMPACT)
citep[]rotman:04. The super-fast mechanism includes 15 photochemically
active trace species (O:math:`_{3}`, OH, HO\ :math:`_{2}`,
H\ :math:`_{2}`\ O\ :math:`_{2}`, NO, NO\ :math:`_{2}`,
HNO\ :math:`_{3}`, CO, CH\ :math:`_{2}`\ O,
CH\ :math:`_{3}`\ O\ :math:`_{2}`, CH\ :math:`_{3}`\ OOH, DMS,
SO\ :math:`_{2}`, SO\ :math:`_{4}`, and
C\ :math:`_{5}`\ H\ :math:`_{8}`) that allow us to calculate the major
terms by which global change operates in tropospheric ozone and sulfate
photochemistry. The families selected are Ox, HOx, NOy, the
CH\ :math:`_{4}` oxidation suite plus isoprene (to capture the main NMHC
effects), and a group of sulfur species to simulate natural and
anthropogenic sources leading to sulfate aerosol. Sulfate aerosols is
handled following . In this scheme, CH4 concentrations are read in from
a file and uses CAM3.5 simulations . The super-fast mechanism was
validated by comparing the super-fast and full mechanisms in
side-by-side simulations.

Emissions for CAM4 superfast chemistry
--------------------------------------

| \|lccc\| & Anthro. &Natural & Interactive
| CH\ :math:`_{2}`\ O & x & x &
| CO & x & x &
| DMS & & x &
| ISOP & & & x
| NO & x & &
| SO\ :math:`_{2}` & x & &

LINOZ
-----

Linoz is linearized ozone chemistry for stratospheric modeling . It
calculates the net production of ozone (i.e., production minus loss) as
a function of only three independent variables: local ozone
concentration, temperature, and overhead column ozone). A zonal mean
climatology for these three variables as well as the other key chemical
variables such a total odd-nitrogen methane abundance is developed from
satellite and other in situ observations. A relatively complete
photochemical box model is used to integrate the radicals to a steady
state balance and then compute the net production of ozone. Small
perturbations about the chemical climatology are used to calculate the
coefficients of the first-order Taylor series expansion of the net
production in terms of local ozone mixing ratio (f), temperature (T),
and overhead column ozone (c).

.. math::

   \frac{df}{df} & = (P - L)^o + \left.{\frac{\delta (P - L)}{\delta f}}\right|_o(f - f^o) + \left.\frac{\delta (P - L)}{\delta T}\right|_o (T - T^o) \\ 
   \nonumber & + \left.\frac{\delta (P - L)}{\delta c}\right|_o(c - c^o) 

The photochemical tendency for the climatology is denoted by
:math:`(P-L)_o`, and the climatology values for the independent
variables are denoted by :math:`f_o`, :math:`c_o`, and :math:`T_o`,
respectively. Including these four climatology values and the three
partial derivatives, Linoz is defined by seven tables. Each table is
specified by 216 atmospheric profiles: 12 months by 18 latitudes
(85:math:`^o`\ S to 85\ :math:`^o`\ N). For each profile, quantities are
evaluated at every 2 km in pressure altitude from :math:`z^*` = 10 to 58
km (:math:`z^*` = 16 km log\ :math:`_10` (1000/p)). These tables
(calculated for each decade, 1850-2000 to take into account changes in
CH4 and N2O) are automatically remapped onto the CAM-chem grid with the
mean vertical properties for each CAM-chem level calculated as the
mass-weighted average of the interpolated Linoz profiles. Equation (1)
is implemented for the chemical tendency of ozone in CAM-chem.

Parameterized PSC ozone loss
----------------------------

In the superfast chemistry, we incorporate the PSCs parameterization
scheme of when the temperature falls below 195 K and the sun is above
the horizon at stratospheric altitudes. The O\ :math:`_3` loss scales as
the squared stratospheric chlorine loading (normalized by the 1980 level
threshold). In this formulation PSC activation invokes a rapid e-fold of
O\ :math:`_3` based on a photochemical model, but only when t he
temperature stays below the PSC threshold. The stratospheric chlorine
loading (1850-2005) is input in the model using equivalent effective
stratospheric chlorine (EESC) table based on observed mixing ratios at
the surface.

This can be used instead of the more explicit representation available
from WACCM in the strat-trop configuration.
