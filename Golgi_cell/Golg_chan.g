// genesis

// 16Mar2005 The UCL (UK) discovered a bug in the code of the Ih channel, 
// caused by inappropriate placement of the brackets in the argument of the exp function.


/*********************************************************************
**               The current equations themselves 
*********************************************************************/

/* First include Gran_chan_KCa.g for non-inactivating BK-type 
** Ca-dependent K current.
*/

 include ../Golgi_cell/Golg_chan_KCa.g
 include ../Golgi_cell/Golg_chan_KA.g

 float offset = 0.00

function make_Golgi_chans

    float temperature = 5
    int i, cdivs
    float zinf, ztau, c, dc, cmin, cmax
    float x, dx, y
    float a, b
    /* The folowing variables are temporary (not temperature) variables
	used to speed up computations */
    float mintau
    float tau
    float temp1
    float temp2

    /* Equations specific to the Granule cell, made by CP */
    /* Inactivating Na current */

	create tabchannel Gran_InNa
	setfield Gran_InNa Ek {ENa} Gbar 70 Ik 0 Gk 0 Xpower 3 Ypower 1  \
	    Zpower 0

	call Gran_InNa TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

	x = {tab_xmin} - {offset}
	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}
	mintau = (1e-3*0.05)
	temp1 = (1e3*1.5)

        openfile InNa_a_max_37.test w
        openfile InNa_a_tau_37.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		temp2 = ((x) + 39e-3) // instead of ((x) + 39e-3)
		a = (temp1)*({exp {0.081e3*(temp2)}})
		b = (temp1)*({exp {-0.066e3*(temp2)}})
		tau = 1/(a + b)

		if (tau  < (mintau))		// tau_min is 0.05*5e-3 

			setfield Gran_InNa X_A->table[{i}] {mintau / temperature}
		else
			setfield Gran_InNa X_A->table[{i}] {tau / temperature}
		end
		//Xinf
		setfield Gran_InNa X_B->table[{i}] {a*tau}

                writefile InNa_a_max_37.test {x} {getfield Gran_InNa X_B->table[{i}]}
                writefile InNa_a_tau_37.test {x} {getfield Gran_InNa X_A->table[{i}]}

		x = x + dx
	end
	tweaktau Gran_InNa X
	setfield Gran_InNa X_A->calc_mode 1 X_B->calc_mode 1

        closefile InNa_a_max_37.test
        closefile InNa_a_tau_37.test

	call Gran_InNa TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}
	mintau = (1e-3*0.225)
	temp1 = (1e3*0.12)

        openfile InNa_i_max_37.test w
        openfile InNa_i_tau_37.test w

// trying to increase threshold

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		temp2 = (0.089e3)*(((x) + 50e-3)) // instead of (0.089e3)*(((x) + 50e-3))
		a = (temp1)*({exp {-(temp2)}})
		b = (temp1)*({exp {temp2}})
		tau = 1/(a + b)

		if (tau < mintau)		// tau_min is 0.225*5e-3 

			setfield Gran_InNa Y_A->table[{i}] {mintau / temperature}
		else
			//Xinf
			setfield Gran_InNa Y_A->table[{i}] {tau / temperature}
		end
		setfield Gran_InNa Y_B->table[{i}] {a*tau}

                writefile InNa_i_max_37.test {x} {getfield Gran_InNa Y_B->table[{i}]}
                writefile InNa_i_tau_37.test {x} {getfield Gran_InNa Y_A->table[{i}]}

		x = x + dx

	end
	tweaktau Gran_InNa Y
	setfield Gran_InNa Y_A->calc_mode 1 Y_B->calc_mode 1

        closefile InNa_i_max_37.test
        closefile InNa_i_tau_37.test

// Delayed Rectifier K current 

	create tabchannel Gran_KDr
	setfield Gran_KDr Ek {EK} Gbar 19 Ik 0 Gk 0 Xpower 4 Ypower 1  \
	    Zpower 0

	call Gran_KDr TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}
	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}
	temp1 = 1e3*0.17

        openfile Kdr_a_max_37.test w
        openfile Kdr_a_tau_37.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		temp2 = x + 38e-3
		a = temp1*({exp {0.073e3*(temp2)}})
		b = temp1*({exp {-0.018e3*(temp2)}})

		setfield Gran_KDr X_A->table[{i}] {temperature * a}
		setfield Gran_KDr X_B->table[{i}] {temperature * (a + b)}

                writefile Kdr_a_tau_37.test {x} {1 / (temperature * (a + b))}
                writefile Kdr_a_max_37.test {x} {a / (a + b)}

		x = x + dx
	end
	setfield Gran_KDr X_A->calc_mode 1 X_B->calc_mode 1

        closefile Kdr_a_max_37.test
        closefile Kdr_a_tau_37.test

	call Gran_KDr TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}

        openfile Kdr_i_max_37.test w
        openfile Kdr_i_tau_37.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		if (x > -0.046)  
                          a = 0.76
                else      a = 1e3*(0.0007 + 0.000065*({exp {-0.08e3*(x + 46e-3)}}))
	        end
        	b = 1e3*(110e-5)/(1 + ({exp {-0.0807e3*(x + 44e-3)}}))

		setfield Gran_KDr Y_A->table[{i}] {temperature * a}
		setfield Gran_KDr Y_B->table[{i}] {temperature * (a + b)}

		writefile Kdr_i_tau_37.test {x} {1 / (temperature * (a + b))}
                writefile Kdr_i_max_37.test {x} {a / (a + b)}

                x = x + dx
	end
	setfield Gran_KDr Y_A->calc_mode 1 Y_B->calc_mode 1

        closefile Kdr_i_tau_37.test
        closefile Kdr_i_max_37.test

//  K A-current  fast transient potassium channel (see Gran_chan_KA.g)

    make_Golgi_KA

// High Voltage Activated HVA Ca current 

	create tabchannel Gran_CaHVA
	setfield Gran_CaHVA Ek {ECa} Gbar 2.91 Ik 0 Gk 0 Xpower 2  \
	    Ypower 1 Zpower 0

	call Gran_CaHVA TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}
	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

        openfile CaHVA_a_max_37.test w
        openfile CaHVA_a_tau_37.test w
        
// corrigenda Gabbiani et al. 1994, JNP february 1996

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		temp2 = x - 8.9e-3 // instead of x - 8.9e-3
		a = 1e3*(1.6/(1 + ({exp {-0.072e3*(x - 5e-3)}})))
		b = -(1e3*0.02e3*(temp2))/(1 - ({exp {0.2e3*(temp2)}}))

		setfield Gran_CaHVA X_A->table[{i}] {temperature * a}
		setfield Gran_CaHVA X_B->table[{i}] {temperature * (a + b)}

                writefile CaHVA_a_tau_37.test {x} {1 / (temperature * (a + b))}
                writefile CaHVA_a_max_37.test {x} {a / (a + b)}

		x = x + dx
	end
	setfield Gran_CaHVA X_A->calc_mode 1 X_B->calc_mode 1

        closefile CaHVA_a_max_37.test
        closefile CaHVA_a_tau_37.test

	call Gran_CaHVA TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}

        openfile CaHVA_i_max_37.test w
        openfile CaHVA_i_tau_37.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		if (x < -0.060)
                                a = 5.0
                else            a = 1e3*0.005*({exp {-0.05e3*(x + 60e-3)}})
		end
                if (x < -0.060)
                                b = 0.0
                else            b = (1e3*0.005) - (a)
                end

		setfield Gran_CaHVA Y_A->table[{i}] {temperature * a}

		setfield Gran_CaHVA Y_B->table[{i}] {temperature * (a + b)}

                writefile CaHVA_i_tau_37.test {x} {1 / (temperature * (a + b))}
                writefile CaHVA_i_max_37.test {x} {a / (a + b)}

		x = x + dx
	end
	setfield Gran_CaHVA Y_A->calc_mode 1 Y_B->calc_mode 1

        closefile CaHVA_i_max_37.test
        closefile CaHVA_i_tau_37.test

// Slowly relaxing, mixed Na/K current H 
// Gabbiani et al. used this to model sag in membrane potential during
// hyperpolarizing current pulses 
//

	create tabchannel Gran_H
	setfield Gran_H Ek {EH} Gbar 0.09 Ik 0 Gk 0 Xpower 1 Ypower 0  \
	    Zpower 0

	call Gran_H TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}
	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

        openfile H_a_max_37.test w
        openfile H_a_tau_37.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		temp2 = 0.0909e3*(x + 75e-3)
		a = 1e3*0.0008*({exp {-{temp2}}})
		b = 1e3*(0.0008*({exp {temp2}}))

		setfield Gran_H X_A->table[{i}] {temperature * a}
		setfield Gran_H X_B->table[{i}] {temperature * (a + b)}

                writefile H_a_tau_37.test {x} {1 / (temperature * (a + b))}
                writefile H_a_max_37.test {x} {a / (a + b)}

		x = x + dx
	end
	setfield Gran_H X_A->calc_mode 1 X_B->calc_mode 1

        closefile H_a_max_37.test
        closefile H_a_tau_37.test

// non-inactivating BK-type Ca-dependent K current 
//   see Gran_chan_KCa.g

   make_Moczyd_KC

end
