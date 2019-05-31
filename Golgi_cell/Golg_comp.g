//genesis

// modification MAEX 16/4/96
// mf_NMDA synchan removed (not used)
// pf_AMPA synchan added for selective normalization of mossy fiber and
// parallel fiber inputs

/**********************************************************************
This is a copy of the single-compartment Granule cell comp (CP, RM),
except for the inclusion of a nerstpotential object for calcium, which
is copied from the Purkinje cell model (EDS), and for the addition of
a spike generation object
********************************************************************/

/*********************************************************************/
/*function make_interneuron_comps 	(see make_Granule_comps)				     */
/*********************************************************************/

function make_Golgi_comps

/* separate function so we can have local variables */

	float len, dia, surf, shell_vol, shell_dia

	/* make spherical soma prototype with sodium currents*/
	len = 0.00e-6
	dia = 1
	surf = dia*dia*{PI}
	shell_dia = dia - 2*{Shell_thick}
	shell_vol = (dia*dia*dia - shell_dia*shell_dia*shell_dia)*{PI}/6.0
        create neutral interneuron
	if (!({exists interneuron/soma}))
		create compartment interneuron/soma
	end
	// F
	// ohm, correct for sphere
	// V
	// V
	// ohm

        ce /library/interneuron

	setfield soma Cm {{CM}*surf} Ra {8.0*{RA}/(dia*{PI})}  \
	    Em {EREST_ACT} Vm {RESET_ACT} Rm {{RMs}/surf} inject 0.0  \
	    dia {dia} len {len}

	// Now copy the channels and set maximal conductances */


        if (!({exists soma/InNa}))
        	copy ../Gran_InNa soma/InNa
	        addmsg soma soma/InNa VOLTAGE Vm
	        addmsg soma/InNa soma CHANNEL Gk Ek
	end
        setfield soma/InNa Gbar {{GInNas}*surf}

        if (!({exists soma/KDr}))
        	copy ../Gran_KDr soma/KDr
	        addmsg soma soma/KDr VOLTAGE Vm
	        addmsg soma/KDr soma CHANNEL Gk Ek
	end
        setfield soma/KDr Gbar {{GKDrs}*surf}
	
        if (!({exists soma/KA}))
                copy ../Gran_KA soma/KA
	        addmsg soma soma/KA VOLTAGE Vm
	        addmsg soma/KA soma CHANNEL Gk Ek
	end
        setfield soma/KA Gbar {{GKAs}*surf}
	
        if (!({exists soma/CaHVA}))
                copy ../Gran_CaHVA soma/CaHVA
	        addmsg soma soma/CaHVA VOLTAGE Vm
	        addmsg soma/CaHVA soma CHANNEL Gk Ek
	end
        setfield soma/CaHVA Gbar {{GCaHVAs}*surf}
	
        if (!({exists soma/H}))
                copy ../Gran_H soma/H
	        addmsg soma soma/H VOLTAGE Vm
	        addmsg soma/H soma CHANNEL Gk Ek
	end
        setfield soma/H Gbar {{GHs}*surf}

	
        if (!({exists soma/Moczyd_KC}))
                copy ../Moczyd_KC soma/Moczyd_KC
	        addmsg soma soma/Moczyd_KC VOLTAGE Vm
	        addmsg soma/Moczyd_KC soma CHANNEL Gk Ek
	end
        setfield soma/Moczyd_KC Gbar {{GMocs}*surf}


	if (!({exists soma/mf_AMPA}))
                copy ../AMPA soma/mf_AMPA
	        addmsg  soma/mf_AMPA  soma CHANNEL Gk  Ek
	        addmsg  soma soma/mf_AMPA  VOLTAGE Vm
        end
	setfield soma/mf_AMPA 	gmax    {{getfield soma/mf_AMPA gmax} * surf}

	if (!({exists soma/pf_AMPA}))
                copy ../AMPA soma/pf_AMPA
	        addmsg  soma/pf_AMPA  soma CHANNEL Gk  Ek
	        addmsg  soma soma/pf_AMPA  VOLTAGE Vm
        end
	setfield soma/pf_AMPA 	gmax    {{getfield soma/pf_AMPA gmax} * surf}


/*
        if (!({exists soma/mf_NMDA}))
        	copy ../NMDA soma/mf_NMDA
	        addmsg  soma/mf_NMDA soma/mf_NMDA/Mg_BLOCK CHANNEL Gk Ek
	        addmsg  soma/mf_NMDA/Mg_BLOCK soma CHANNEL Gk Ek
	        addmsg  soma soma/mf_NMDA/Mg_BLOCK VOLTAGE Vm
	        addmsg  soma soma/mf_NMDA VOLTAGE Vm
        end
	setfield soma/mf_NMDA 	gmax    {GNMDAs * surf}
*/

        if (!({exists soma/GABAA}))
                copy ../GABAA soma/GABAA
                addmsg  soma/GABAA soma CHANNEL Gk Ek
                addmsg  soma soma/GABAA VOLTAGE Vm
        end
        setfield soma/GABAA gmax {G_GABAAs * surf}


	//lets keep it simple for now

        if (!{exists soma/Ca_pool})
                create Ca_concen soma/Ca_pool
        	addmsg soma/Ca_pool soma/Moczyd_KC CONCEN Ca
	        addmsg soma/CaHVA soma/Ca_pool I_Ca Ik
        end
	setfield soma/Ca_pool tau {CaTau} \
                              B {1.0/(2.0*96494*shell_vol*{PI}*100/2012.67)} \
                    	    Ca_base {CCaI} thick {Shell_thick}
// the volume of the Ca-pool may not change in this 1C model


	// Possibility of modelling NMDA Ca influx (not done in Gabbiani et al.)
	// Probably not worth the effort (yet).

        if (!{exists soma/Ca_nernst})
                create nernst soma/Ca_nernst
	        addmsg soma/Ca_pool soma/Ca_nernst CIN Ca
        	addmsg soma/Ca_nernst soma/CaHVA EK E
        end
	setfield soma/Ca_nernst Cin {CCaI} Cout {CCaO} valency {2} \
	     scale {1.0} T {37}

/*
        create spikegen soma/spike
        setfield soma/spike thresh 0 abs_refract 0.01 output_amp 1
        addmsg soma soma/spike INPUT Vm
*/
end

