// genesis

float Gbar = 1.0

int tab_ydivs = {tab_xdivs}
float tab_ymin = {CCaI}
float tab_ymax = {Ca_tab_max}
float Temp = 22

/* non-inactivating BK-type Ca-dependent K current
** Moczydlowski and Latorre 1983, J Gen Physiol 82, 511-542.
*/
/* scaled for units: V, sec, mM */
function make_Moczyd_KC
	int i, j
	float ginf, itau, c, dc, cmin, cmax
	float x, dx, y, dy
	float a, b
	float ZFbyRT = 23210/(273.15 + (Temp))

	if (!({exists Moczyd_KC}))
		create tab2Dchannel Moczyd_KC
		setfield Moczyd_KC Ek {EK} Gbar {Gbar}  \
		    Xindex {VOLT_C1_INDEX} Xpower 1 Ypower 0 Zpower 0

		call Moczyd_KC TABCREATE X {tab_xdivs} {tab_xmin}  \
		    {tab_xmax} {tab_ydivs} {tab_ymin} {tab_ymax}
	end
	setfield Moczyd_KC X_A->calc_mode {LIN_INTERP}
	setfield Moczyd_KC X_B->calc_mode {LIN_INTERP}
	call Moczyd_KC TABREAD ../Granule_cell/tabKCa37.data

        if (!{exists comp})
	create neutral comp
	setfield comp x -0.10
	setfield comp y 0.10
	addmsg comp Moczyd_KC VOLTAGE x
	addmsg comp Moczyd_KC CONCEN y
        end
end

