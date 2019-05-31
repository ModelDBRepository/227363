//genesis (R.M. 13/12/95)

include defaults 

/* 
The function "make_Golgi_cell_array" creates {length} Golgi cells,
named /granule_cell_layer/Golgi_cell [0] 
   to /granule_cell_layer/Golgi_cell [{length} - 1].
Each Golgi cell is a copy of the Golgi cell described in Golg1M0.p.
A spikegen object is added to the soma.

*/


include ../Golgi_cell/Golg_const.g 
include ../Golgi_cell/Golg_chan_tab.g
include ../Golgi_cell/Golg_synchan.g 
include ../Golgi_cell/Golg_comp.g 


function make_Golgi_cell_array (length)

   int length
   int i
   str cellpath = "/Golgi"

// To ensure that all subsequent elements are made in the library 
   ce /library

// Make the prototypes of channels and compartments that can be invoked in .p files
   make_Golgi_chans
   make_Golgi_syns
   make_Golgi_comps

   if (!{exists /granule_cell_layer})
          create neutral /granule_cell_layer
   end

// MAEX 16/4/96
   setfield /library/interneuron/soma/mf_AMPA normalize_weights 1
   setfield /library/interneuron/soma/pf_AMPA normalize_weights 1
   setfield /library/interneuron/soma/GABAA   normalize_weights 1

// read cell data from .p file
   readcell ../Golgi_cell/Golg1M0.p {cellpath}

// add a spikegen object
   create spikegen {cellpath}/soma/spike
   setfield {cellpath}/soma/spike thresh 0 \
                                  abs_refract 0.002 \
                                  output_amp 1
   addmsg {cellpath}/soma {cellpath}/soma/spike INPUT Vm


   createmap {cellpath} /granule_cell_layer \
             {length} 1 -delta {Golgi_cell_separation} 0.0 -origin 0.0 0.0

   disable {cellpath}

end   





