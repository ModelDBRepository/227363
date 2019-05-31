//genesis

/*********************************************************************
**               The synaptic conductance equations 
*********************************************************************/

float Q10_synapse =   3.0

function make_Granule_syns

//[Mg] in mM
float CMg = 1.2
// per mM
float eta = 0.2801
// per V
float gamma = 62

float offset = - 0.01

echo eta = {eta}

eta = eta * {exp {- gamma * offset}}

echo new eta = {eta}


echo diag Gran_syn1 0

/* NMDA channel made by CP */
/* From Gabbiani et al. (model) 1994 */

echo diag Gran_syn1 2

	if (!({exists NMDA}))
		create synchan2 NMDA
	end

	setfield NMDA Ek {E_NMDA} tau2 {3e-3  / Q10_synapse} \
                                  tau1 {40e-3 / Q10_synapse} \
                                  gmax {G_NMDA}
// use the following value for synaptic activation when TEST.g is run
//                                  gmax {4.0 * G_NMDA}

        if (! {exists NMDA/Mg_BLOCK})
                create Mg_block NMDA/Mg_BLOCK
	end

        setfield NMDA/Mg_BLOCK CMg {CMg}  \
	    KMg_A {1/eta} \ \\ *({exp {EREST_ACT*gamma}})} \ 
            KMg_B {1.0/gamma}

echo diag Gran_syn1 3

/* AMPA channel, made by CP */
/* Reference: voltage clamp data from
** Gabbiani et al. (model): J.Neurophys. 1994 
** Silver et al.: Nature 1992.
*/

    if (!({exists AMPA}))
		create synchan2 AMPA
    end
    //sec
    //sec
    setfield AMPA Ek {E_AMPA} tau2 {0.09e-3  / Q10_synapse} \
                              tau1 {1.5e-3   / Q10_synapse} \
                              gmax {G_AMPA}
// use the following value for synaptic activation when TEST.g is run
//                              gmax {6.0 * G_AMPA}

    // Incorporate constant of proportionality (1.273) in G_AMPA
echo diag Gran_syn1 4
/* GABAA? channel, made by EDS */
/* Reference: voltage clamp data from 
** Miles R: . J Physiol 1990.
** Tpeak: 3.25 ms, Tdecay = 28 ms 
** Note the high frequency.  This is being used to model tonic
** Golgi cell inhibition to the granule cell. */
    if (!({exists GABAA}))
		create synchan2 GABAA
    end
    //sec
    //sec
    // should be large for tonic inhibition
    setfield GABAA Ek {E_GABAA} tau1 {0.93e-3  / Q10_synapse} \
                                tau2 {26.50e-3 / Q10_synapse} \
                                gmax {G_GABAA} frequency {0.0}
// use the following value for synaptic activation when TEST.g is run
//                                gmax {G_GABAA * 45.0 * 0.6 / 14.14} frequency {0.0}

/* GABA_B channel, using a dual exponential function with time constants of 80
** and 40 msec as in Suarez, Koch and Douglas 1995 (J. Neurosci. 15,
** 6700-1719; cat visual cortex).  
** A more detailed model can be found in Otis, De Koninck and Mody 1993
** (J. Physiol. 463, 391-407; rat hippocampal slices; this model uses 4th 
** power exponential activation and dual exponential inactivation).
** See also Benardo 1994 (J. Physiol. 476.2, 203-215; slice rat neocortex)
** and Connors, Malenka and Silva 1988 (J. Physiol. 406, 443-468; slice
** rat and cat visual cortex.
*/ 
    if (!({exists GABAB}))
                create synchan2 GABAB
    end
    setfield GABAB Ek {E_GABAB} tau1 {0.080 / Q10_synapse} \
                                tau2 {0.040 / Q10_synapse} \
                                gmax {G_GABAB} frequency {0.0}
end






