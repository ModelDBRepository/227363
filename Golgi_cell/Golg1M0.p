// Morphology file for Golgi cell
// A single compartment neuron with a spherical soma yielding
// an Rin (78 MegaOhm) and a time-constant (24 msec) as tabulated in Midtgaard (1992).
// The resulting Cm is 0.31 nF, assuming a specific membrane capacitance of 0.01 (F/m^2).
// The resulting surface area is 0.31e5 um^2.
// Written by RM (27/11/95).
// changed /library/soma to /library/interneuron/soma on 16/4/96 MAEX

   
*relative

*set_compt_param ELEAK {ELEAK}
*set_compt_param EREST_ACT {EREST_ACT}
   *set_compt_param RM	3.03 // 2.4000	// 24 000 ohm.cm^2
*set_compt_param RA	1.0000 	// 
*set_compt_param CM	0.0100	// 1microF/cm^2

*compt /library/interneuron/soma
   soma		none		0.000	0.000	0.000	30.0 // 99.33

