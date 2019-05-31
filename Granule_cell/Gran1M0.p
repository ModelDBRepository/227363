// Morphology file for Granule cell
// A single compartment neuron with a spherical soma representing
// the morphology used in Gabbiani et al. (1994)
// This is a copy of
// /bbf/haddock/carl/Genesis/Granule/True_sa_1_compt_L37/Gran1M0.p
// changed /library/soma to /library/granule/soma on 16/4/96 MAEX
   
*relative

*set_compt_param ELEAK {ELEAK}
*set_compt_param EREST_ACT {EREST_ACT}
*set_compt_param RM	3.0300	// 30 300 ohm.cm^2
*set_compt_param RA	1.0000 	// 
*set_compt_param CM	0.0100	// 1microF/cm^2

*compt /library/granule/soma
   soma		none		0.000	0.000	0.000	10.0 // 25.32

