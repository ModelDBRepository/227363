// nog te doen : omzetten Genesis2.1

// genesis (R.M. 12/12/95)

include defaults

/* 
The function "make_granule_cell_array" creates {length} granule cells,
named /granule_cell_layer/granule_cell [0] 
   to /granule_cell_layer/granule_cell [{length} - 1].
Each granule cell is a copy of the granule cell described in Gran1M0.p.
A spikegen object is added to the soma.
*/


// if tables have not been created with TABSAVE, first create them (e.g. with
// ../Granule_cell/TEST.g, or use ../Granule_cell/Gran_chan.g instead of
// ../Granule_cell/Gran_chan_tab.g

include ../Granule_cell/Gran_const.g
// include ../Granule_cell/Gran_chan.g
include ../Granule_cell/Gran_chan_tab.g
include ../Granule_cell/Gran_synchan.g 
include ../Granule_cell/Gran_comp.g


function make_granule_cell_array (length)

   int length
   int i
   str cellpath = "/Granule"

// To ensure that all subsequent elements are made in the library 
   if (! {exists /library/granule})
      create neutral /library/granule
   end
   ce /library/granule


// Make the prototypes of channels and compartments that can be invoked in .p files 
   make_Granule_chans
   make_Granule_syns
   make_Granule_comps

   setfield /library/granule/soma/GABAA normalize_weights 1
   setfield /library/granule/soma/GABAB normalize_weights 1
   setfield /library/granule/soma/mf_AMPA normalize_weights 0
   setfield /library/granule/soma/mf_NMDA normalize_weights 0


// read cell data from .p file
   readcell ../Granule_cell/Gran1M0.p {cellpath}


// add a spikegen object
   create spikegen {cellpath}/soma/spike
   setfield {cellpath}/soma/spike thresh -0.02 \
                                  abs_refract 0.005 \
                                  output_amp 1
   addmsg {cellpath}/soma {cellpath}/soma/spike INPUT Vm


   int size_message_list


   if(!{exists /granule_cell_layer})
          create neutral /granule_cell_layer
   end

// create an array of granule cells, positions will be determined later
// after the assignments of the mossy fiber afferents
   createmap {cellpath} /granule_cell_layer \
             {length} 1 -delta 1.0 0.0 -origin 0.0 0.0

   disable {cellpath}

end   








