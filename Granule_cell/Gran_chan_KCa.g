// genesis

//float EK=-0.085
float Gbar = 1.0

float offset = 0.01

int tab_ydivs = {tab_xdivs}
float tab_ymin = {CCaI}
float tab_ymax = {Ca_tab_max}
float Temp = 22
float temperature = 5

/* non-inactivating BK-type Ca-dependent K current
** Moczydlowski and Latorre 1983, J Gen Physiol 82, 511-542.
** Uses original parameters. 
** Includes Paul Smolen's bug fix. 
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
echo diag Moczyd_KC 1
	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}
	dy = (tab_ymax - tab_ymin)/tab_ydivs
	x = {tab_xmin} - {offset}
	for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		y = tab_ymin
		for (j = 0; j <= (tab_ydivs); j = j + 1)
			/* \
			     Must check that the following are scaled correctly!!  \
			    */
			a = 2.5e3/(1 + ((1.5e-3*{exp {-0.085e3*x}})/y))
			b = 1.5e3/(1 + (y/(150e-6*{exp {-0.077e3*x}})))
			itau = a + b
			ginf = a/itau
			setfield Moczyd_KC X_A->table[{i}][{j}] {temperature * a}
			setfield Moczyd_KC X_B->table[{i}][{j}] {temperature * itau}
			y = y + dy
		end
		x = x + dx
	end
    setfield Moczyd_KC X_A->calc_mode {LIN_INTERP}
    setfield Moczyd_KC X_B->calc_mode {LIN_INTERP}
echo diag Moczyd_KC 3
create neutral comp
setfield comp x -0.10
setfield comp y 0.10
addmsg comp Moczyd_KC VOLTAGE x
addmsg comp Moczyd_KC CONCEN y
echo diag Moczyd_KC 4
end

