//genesis
/**********************************************************************
** Sets up active membrane Granule cell compartment prototypes 
**  and dendritic spine prototypes.
** Carl Piaf 7th December 1994
** Uses Granule1M.p data file
** Synapses: NONE
** This is a copy of
** /bbf/haddock/carl/Genesis/Granule/True_sa_1_compt_L37/Gran_comp1.g, 
** converted to Genesis 2 by RM
** changed soma to granule/soma on 16/4/96
** Modified bt Reinoud Maex 10/95-4/96
********************************************************************/

/*********************************************************************/
/*function make_Granule_comps 					     */
/*********************************************************************/

function make_Granule_comps 


/* separate function so we can have local variables */

	float len, dia, surf, shell_vol, shell_dia

	/* make spherical soma prototype with sodium currents*/
	len = 0.00e-6
	dia = 1
	surf = dia*dia*{PI}
	shell_dia = dia - 2*{Shell_thick}
	shell_vol = (dia*dia*dia - shell_dia*shell_dia*shell_dia)*{PI}/6.0
//        create neutral granule
	if (!({exists soma}))
		create compartment soma
	end
	// F
	// ohm, correct for sphere
	// V
	// V
	// ohm


	setfield soma Cm {{CM}*surf} Ra {8.0*{RA}/(dia*{PI})}  \
	    Em {EREST_ACT} Vm {RESET_ACT} Rm {{RMs}/surf} inject 0.0  \
	    dia {dia} len {len}

	// Now copy the channels and set maximal conductances */


	copy Gran_InNa soma/InNa
	addmsg soma soma/InNa VOLTAGE Vm
	addmsg soma/InNa soma CHANNEL Gk Ek
	setfield soma/InNa Gbar {{GInNas}*surf}
	copy Gran_KDr soma/KDr
	addmsg soma soma/KDr VOLTAGE Vm
	addmsg soma/KDr soma CHANNEL Gk Ek
	setfield soma/KDr Gbar {{GKDrs}*surf}
	copy Gran_KA soma/KA
	addmsg soma soma/KA VOLTAGE Vm
	addmsg soma/KA soma CHANNEL Gk Ek
	setfield soma/KA Gbar {{GKAs}*surf}
	copy Gran_CaHVA soma/CaHVA
	addmsg soma soma/CaHVA VOLTAGE Vm
	addmsg soma/CaHVA soma CHANNEL Gk Ek
	setfield soma/CaHVA Gbar {{GCaHVAs}*surf}
	copy Gran_H soma/H
	addmsg soma soma/H VOLTAGE Vm
	addmsg soma/H soma CHANNEL Gk Ek
	setfield soma/H Gbar {{GHs}*surf}

	copy Moczyd_KC soma/Moczyd_KC
	addmsg soma soma/Moczyd_KC VOLTAGE Vm
	addmsg soma/Moczyd_KC soma CHANNEL Gk Ek
	setfield soma/Moczyd_KC Gbar {{GMocs}*surf}

	copy AMPA soma/mf_AMPA
	setfield soma/mf_AMPA \
		gmax    {{getfield soma/mf_AMPA gmax} * surf}
	addmsg  soma/mf_AMPA  soma CHANNEL Gk  Ek
	addmsg  soma soma/mf_AMPA  VOLTAGE Vm

	copy NMDA soma/mf_NMDA
	setfield soma/mf_NMDA \
		gmax    {{getfield soma/mf_NMDA gmax} * surf}
	addmsg  soma/mf_NMDA soma/mf_NMDA/Mg_BLOCK CHANNEL Gk Ek
	addmsg  soma/mf_NMDA/Mg_BLOCK soma CHANNEL Gk Ek
	addmsg  soma soma/mf_NMDA/Mg_BLOCK VOLTAGE Vm
	addmsg  soma soma/mf_NMDA VOLTAGE Vm

        copy GABAA soma/GABAA
        setfield soma/GABAA gmax {{getfield soma/GABAA gmax} * surf}
        addmsg  soma/GABAA soma CHANNEL Gk Ek
        addmsg  soma soma/GABAA VOLTAGE Vm

        copy GABAB soma/GABAB
        setfield soma/GABAB gmax {{getfield soma/GABAB gmax} * surf}
        addmsg soma/GABAB soma CHANNEL Gk Ek
        addmsg soma soma/GABAB VOLTAGE Vm

	//lets keep it simple for now

        if (!{exists soma/Ca_pool})
              create Ca_concen soma/Ca_pool
        end
	setfield soma/Ca_pool tau {CaTau} \
                              B {1.0/(2.0*96494*shell_vol*{PI}*100/2012.67)} \
                       	    Ca_base {CCaI} thick {Shell_thick}
// the volume of the Ca-pool may not change in this 1C model

	addmsg soma/Ca_pool soma/Moczyd_KC CONCEN Ca
	addmsg soma/CaHVA soma/Ca_pool I_Ca Ik
	// Possibility of modelling NMDA Ca influx (not done in Gabbiani et al.)
	// Probably not worth the effort (yet).

end

