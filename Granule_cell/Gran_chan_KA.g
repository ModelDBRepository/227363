// genesis


/*********************************************************************
**               The current equations themselves 
*********************************************************************/

float offset = 0.01

function make_Granule_KA

    int i, cdivs
    float zinf, ztau, c, dc, cmin, cmax
    float x, dx, y
    float a, b
    /* The folowing variables are temporary (not temperature) variables
	used to speed up computations */
    float mintau
    float max
    float tau
    float temp1
    float temp2


/*  K A-current  fast transient potassium channel, following Bardoni and Belluzzi 1993 */

	create tabchannel Gran_KA
	setfield Gran_KA Ek {EK} Gbar 3.67 Ik 0 Gk 0 Xpower 3 Ypower 1  \
	    Zpower 0

	call Gran_KA TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}
	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

        openfile KA_a_max.test w
        openfile KA_a_tau.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)

		tau = 0.410 * ({exp {(- (x * 1e3 + 43.5) / 42.8)}}) + 0.167

                max = 1 / (1 + {exp {((-46.7 - x * 1e3) / 19.8)}})

		setfield Gran_KA X_A->table[{i}] {tau * 0.001}    //    0.005}
		setfield Gran_KA X_B->table[{i}] {max}

                writefile KA_a_max.test {x} {getfield Gran_KA X_B->table[{i}]}
                writefile KA_a_tau.test {x} {getfield Gran_KA X_A->table[{i}]}

		x = x + dx
	end
        tweaktau Gran_KA X
	setfield Gran_KA X_A->calc_mode 1 X_B->calc_mode 1

        closefile KA_a_max.test
        closefile KA_a_tau.test

	call Gran_KA TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	x = {tab_xmin} - {offset}

        openfile KA_i_max.test w
        openfile KA_i_tau.test w

	for (i = 0; i <= ({tab_xdivs}); i = i + 1)

                tau = 10.8 + 30 * x  + \
                      1 / (57.9 * {exp {x * 127}} + 134e-6 * {exp {- x * 59}})

                max = 1 / (1 + {exp {((x * 1e3 + 78.8) / 8.4)}})

		setfield Gran_KA Y_A->table[{i}] {tau * 0.001} // 0.0002} // correction for sec and for 37 deg C
		setfield Gran_KA Y_B->table[{i}] {max}

                writefile KA_i_max.test {x} {getfield Gran_KA Y_B->table[{i}]}
                writefile KA_i_tau.test {x} {getfield Gran_KA Y_A->table[{i}]}

		x = x + dx
	end
        tweaktau Gran_KA Y
	setfield Gran_KA Y_A->calc_mode 1 Y_B->calc_mode 1

        closefile KA_i_max.test
        closefile KA_i_tau.test

//        call Gran_KA TABSAVE tabKA37.data
end



