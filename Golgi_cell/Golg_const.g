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
float EREST_ACT = -0.065
// !!Change!!Ek value used for the RESET
float RESET_ACT = -0.065
float ELEAK = -0.055
/* concentrations */
//external Ca as in normal slice Ringer
float CCaO = 2.4000
//internal Ca in mM
float CCaI =   75.5e-6
//diameter of Ca_shells
float Shell_thick = 0.6e-6
// Ca_concen tau
float CaTau =  0.2 
float Temp = 37

float ENa = 0.055
float EK = -0.090
float ECa = 0.080
float EH = -0.042


// We refer to the ../Granule_cell/Gran_const.g script for the origin 
// of the following  peak conductance values. The scaling factors arose 
// during the tuning process and have been inherited here, although they should 
// for consistency better be replaced by the same unique scaling factor as used for the 
// granule cell model (actually scaling_f1 * scaling_f2 = 0.143, while scaling_f = 0.156).

// Two further remarks :
// 1) These values represent conductance densities, as they are in Golg_comp.g multiplied
//    by the surface area of the prototype cell. Hence the neuron dynamics will be independent
//    of the diameter of the compartment specified in the cell description file Golg1M0.p.
// 2) To know the actual conductances, use the showfield command from the genesis command line and look
//    at the Gbar field of the neuron's channel.


float scaling_f1 = 314.15 / 31000.0 
float scaling_f2 = 1.1e9 / 78e6 


float GInNas  = 2       * 2 * scaling_f1 * scaling_f2 * 10 * 70
float GKDrs   = 1.25    * 2 * scaling_f1 * scaling_f2 * 10 * 19
float GKAs    = 0.5     * 2 * scaling_f1 * scaling_f2 * 10 * 3.67
float GCaHVAs = 1       * 2 * scaling_f1 * scaling_f2 * 10 * 2.91
float GHs     = 20.0/3  * 2 * scaling_f1 * scaling_f2 * 10 * 0.09
float GMocs   = 0.025   * 2 * scaling_f1 * scaling_f2 * 10 * 80

// the low value of GMocs should be interpreted in the light of the slow time constant
// of the calcium pool 


/* Synapses */
float E_GABAA = -0.070
float G_GABAA = 1.0 
float E_NMDA = 0.0
float G_NMDA =  1200.0e-12 / 2012.67e-12  
float E_AMPA = 0.0
float G_AMPA = 720.0e-12 / 2012.67e-12  
float E_GABAB = -0.090
float G_GABAB = 1.0 

float G_GABAAs = G_GABAA
float GNMDAs = G_NMDA
float GAMPAs = G_AMPA
float G_GABABs = G_GABAB




