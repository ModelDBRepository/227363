// parameters prototype granule cell 
float Ca_tab_max = 0.050
float tab_xdivs = 299
float tab_xfills = tab_xdivs
float tab_xmin = -0.10
float tab_xmax = 0.05
// only used for proto channels
float GNa = 1
float GCa = 1
float GK = 1
float Gh = 1
/* cable parameters */
float CM = 0.01
float RMs =  3.0300
float RA = 1.0 
// CAVE : the values of CM, RMs and RA are overwritten by the cell
// description file 
/* preset constants */
// Ek value used for the leak conductance
float EREST_ACT = -0.0650
// !!Change!!Ek value used for the RESET
float RESET_ACT = -0.0650
float ELEAK = -0.07 // -0.0650
/* concentrations */
//external Ca as in normal slice Ringer
float CCaO = 2.4000
//internal Ca in mM
float CCaI = 75.5e-6
//diameter of Ca_shells
float Shell_thick =  0.6e-6
// Ca_concen tau
float CaTau = 0.01 
float Temp = 37

float scaling_f = 314.15 / 2012.67 // surface soma over surface full Gabbiani model,
// scaling needed because active channels only on soma in Gabbiani model

float ENa = 0.055
float EK = -0.090
float ECa = 0.080
float EH = -0.042

float GInNas = 2.5       \  //   correction for 10 mV shift of (in-)activation rates
             * 2         \  //   correction for 37 deg. Celsius
             * scaling_f \  //   conversion to single compartment
             * 10        \  //   conversion to SI units (S/m^2)
             * 70           //   the Gabbiani value
float GKDrs   = 1.5  * 2 * scaling_f * 10 * 19
float GKAs    = 1.0  * 2 * scaling_f * 10 * 3.67
float GCaHVAs = 1.0  * 2 * scaling_f * 10 * 2.91
float GHs     = 1.1  * 2 * scaling_f * 10 * 0.09
float GMocs   = 0.72 * 2 * scaling_f * 10 * 80

/* Synapses */
float E_GABAA = -0.070
float G_GABAA = 1.0  
float E_NMDA = 0.0
float G_NMDA =  1200.0e-12 / 2012.67e-12   // the Gabbiani value expressed as conductance density
float E_AMPA = 0.0
float G_AMPA = 720.0e-12 / 2012.67e-12  // the Gabbiani value expressed as conductance density
float E_GABAB = -0.070
float G_GABAB = 1.0 

float G_GABAAs = G_GABAA
float GNMDAs = G_NMDA
float GAMPAs = G_AMPA
float G_GABABs = G_GABAB




