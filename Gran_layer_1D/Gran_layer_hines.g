
// genesis

   float dt = 2.0e-5

   include defaults
   include Gran_layer_const.g


// create the granular layer model
   include Gran_layer_setup.g



// setting the clocks, this must de done BEFORE creating the hines solver !!!

   echo dt = {dt}
   for (i=0; i<=7; i=i+1)
        setclock {i} {dt}
   end
   setclock 8 20.0e-5




// spike history output (this must be done before the hines solver is set up)
   include Gran_layer_spike_history_hines.g


/************************      hines solver          ***********************/

   if ({{number_granule_cells} > 0})
       echo making hsolve of granule cells
       create hsolve /granule_cell_layer/Granule[0]/solve
       ce /granule_cell_layer/Granule[0]/solve
       setfield . path "../##[][TYPE=compartment]" comptmode 1 chanmode {chanmode}
       call . SETUP
       ce /granule_cell_layer/Granule[0]
       for (i = {number_granule_cells}; i > 1; i = i - 1)
           call solve  DUPLICATE \ 
                /granule_cell_layer/Granule[{i-1}]/solve \
                /granule_cell_layer/Granule[{i-1}]/##[][TYPE=compartment]
//           echo made hsolve of granule cell {i}
       end
   end

   if ({{number_Golgi_cells} > 0})
       echo making hsolve of Golgi cells
       create hsolve /granule_cell_layer/Golgi[0]/solve
       ce /granule_cell_layer/Golgi[0]/solve
       setfield . path "../##[][TYPE=compartment]" comptmode 1 chanmode {chanmode}
       call /granule_cell_layer/Golgi[0]/solve SETUP
       ce /granule_cell_layer/Golgi[0]
       for (i = {number_Golgi_cells}; i > 1; i = i - 1)
           call solve  DUPLICATE \ 
                /granule_cell_layer/Golgi[{i-1}]/solve \
                /granule_cell_layer/Golgi[{i-1}]/##[][TYPE=compartment]
//           echo made hsolve of Golgi cell {i}
       end
   end

   if ({{number_stellate_cells} > 0})
       echo making hsolve of stellate cells
       create hsolve /molecular_layer/Stellate[0]/solve
       ce /molecular_layer/Stellate[0]/solve
       setfield . path "../##[][TYPE=compartment]" comptmode 1 chanmode {chanmode}
       call /molecular_layer/Stellate[0]/solve SETUP
       ce /molecular_layer/Stellate[0]
       for (i = {number_stellate_cells}; i > 1; i = i - 1)
           call solve  DUPLICATE \ 
                /molecular_layer/Stellate[{i-1}]/solve \
                /molecular_layer/Stellate[{i-1}]/##[][TYPE=compartment]
//           echo made hsolve of stellate cell {i}
       end
   end


// graphics : xview  
// include Gran_layer_view_hines.g 


// Comment out this command if you are running large networks
// for which online screen graphs are impracticable.
// graphics : xgraph 
  include Gran_layer_graph_hines.g


// ascii file output 
// include Gran_layer_ascii_hines.g 



// method
   setmethod 11 // Crank-Nicholson

   reset

//   randseed 12345

   randseed 12345

// randomization of neurons' leak conductances
   include Gran_layer_randomize_hines.g
//   include Gran_layer_randomize_tau_hines.g

//   randseed 12345

   randseed 12345

// starting the simulation  
   echo starting the simulation
/*
   for (i = 0; i < {number_mossy_fibers}; i = i + 1)
       setfield /white_matter/mossy_fiber[{i}] rate {mossy_fiber_firing_rate * (1.0 + {rand -1.0 1.0})}
   end
*/
   reset

   echo {mossy_fibers_history_filename}

//   step 10.0 -time

//   exit













