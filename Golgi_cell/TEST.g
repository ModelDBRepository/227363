//genesis

float dt = 20e-6

str disk = "results/"

int amp = {1 / dt + 1}
str a = (amp)
int i, k, l
str el, name
float t

/*********************************************************************
** Simple Granule cell model script  (#1)
** Carl Piaf BBF 1994
*********************************************************************/

str filename = (disk) @ "G_soma_test20pA"
/* always include these default definitions! */
include defaults 
str cellpath = "/Golgi"

/* Golgi cell constants */
include Golg_const.g 

/* special scripts  to create the prototypes */
include Golg_chan_tab.g
include Golg_synchan.g 
include Golg_comp.g 


/* Set the clocks */
for (i = 0; i <= 7; i = i + 1)
	setclock {i} {dt}
end
setclock 8 4.0e-5
setclock 9 1

/* To ensure that all subsequent elements are made in the library */
ce /library

/* These make the prototypes of channels and compartments that can be
**  invoked in .p files */

make_Golgi_chans

make_Golgi_syns

make_Golgi_comps
/*
call Gran_InNa TABSAVE tabInNa37.data
call Gran_KDr  TABSAVE tabKDr37.data
call Gran_KA   TABSAVE tabKA37.data
call Gran_CaHVA TABSAVE tabCaHVA37.data
call Gran_H    TABSAVE tabH37.data
call Moczyd_KC TABSAVE tabKCa37.data
*/

//make_Vmgraph

/* create the model and set up the run cell mode */
// read cell data from .p file
echo STARTING READ CELL
readcell Golg1M0.p {cellpath}


create neutral /library/interneuron/soma/mf_presyn
disable /library/interneuron/soma/mf_presyn
setfield /library/interneuron/soma/mf_presyn z 0
// Comment out whichever one to switch it off 
//addmsg /library/interneuron/soma/mf_presyn /Golgi/soma/GABAA ACTIVATION z
//addmsg /library/interneuron/soma/mf_presyn /Golgi/soma/mf_NMDA ACTIVATION z
addmsg /library/interneuron/soma/mf_presyn /Golgi/soma/mf_AMPA ACTIVATION z

//read_hines -vm -method 11 Gran1M0.p {cellpath}

/* Create the output element */
create asc_file /output/plot_out
//create disk_out /output/plot_out
useclock /output/plot_out 8
enable /output
enable /output/plot_out

ce {cellpath}

// setup the hines solver

echo preparing hines solver...


create hsolve solve
// if this is set then reset will NOT change Vm in Hines
ce solve
setfield . path "../##[][TYPE=compartment]" comptmode 1 chanmode 4  
call . SETUP


setmethod 11

/*
el = ({findsolvefield {cellpath}/solve soma/H Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#2

el = ({findsolvefield {cellpath}/solve soma/Ca_pool Ca})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#3
*/
el = ({findsolvefield {cellpath}/solve soma Vm})       //#4
addmsg {cellpath}/solve /output/plot_out SAVE {el}
/*
el = ({findsolvefield {cellpath}/solve soma/Moczyd_KC Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#5

el = ({findsolvefield {cellpath}/solve soma/KDr Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#6

el = ({findsolvefield {cellpath}/solve soma/InNa Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#7

el = ({findsolvefield {cellpath}/solve soma/KA Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#8

el = ({findsolvefield {cellpath}/solve soma/CaHVA Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#9

el = ({findsolvefield {cellpath}/solve soma/Moczyd_KC Gk})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#5

el = ({findsolvefield {cellpath}/solve soma/CaHVA Gk})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#9


el = ({findsolvefield {cellpath}/solve soma/mf_AMPA Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#10


el = ({findsolvefield {cellpath}/solve soma/mf_AMPA Gk})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#10

el = ({findsolvefield {cellpath}/solve soma/mf_NMDA Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#11

el = ({findsolvefield {cellpath}/solve soma/Mg_BLOCK Ik})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#12

el = ({findsolvefield {cellpath}/solve soma/Mg_BLOCK Gk})
addmsg {cellpath}/solve /output/plot_out SAVE {el}    //#13
*/

setfield /output/plot_out filename {filename} initialize 1 leave_open 1  \
    flush 1
echo Output to {filename}

//check
reset

/*
step 0.175 -time



// Synaptic stimulation protocol
 setfield /library/interneuron/soma/mf_presyn z {amp}
 step 1
 setfield /library/interneuron/soma/mf_presyn z 0
 step 325e-3 -time
*/


// Current injection protocol

step 0.5 -time

call {cellpath}/solve HGET {cellpath}/soma
setfield {cellpath}/soma inject 20e-12
call {cellpath}/solve HPUT {cellpath}/soma

step 0.5 -time

call {cellpath}/solve HGET {cellpath}/soma
setfield {cellpath}/soma inject 0e-12
call {cellpath}/solve HPUT {cellpath}/soma

step 0.5 -time

/*
call {cellpath}/solve HGET {cellpath}/soma
setfield {cellpath}/soma inject -22.5e-12
call {cellpath}/solve HPUT {cellpath}/soma
step 0.5 -time
*/



