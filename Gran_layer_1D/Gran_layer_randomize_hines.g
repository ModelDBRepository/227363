// genesis
// randomization mf_AMPA Golgi cells (3/2/1997)

   include defaults
   include Gran_layer_const.g


float Golgi_E_leak_lb   = -0.06 // -0.070 // -0.060  // E_leak lower boundary
float Golgi_E_leak_ub   = -0.05 //  -0.060 // -0.050  // E_leak upper boundary
float Granule_E_leak_lb = -0.070
float Granule_E_leak_ub = -0.060
float Stellate_E_leak_lb = Golgi_E_leak_lb
float Stellate_E_leak_ub = Golgi_E_leak_ub

float Vm_init_lb =  -0.090 // initial values membrane potential
float Vm_init_ub =  -0.05 //  0.050

int   i
float initvm



   echo randomizing granule cells
   for (i = {number_granule_cells}; i > 0; i = i - 1)
       pushe /granule_cell_layer/Granule[{i-1}]/soma
       initvm = {rand {Vm_init_lb} {Vm_init_ub}}
       setfield . initVm {initvm}
       setfield . Vm     {initvm}
       setfield . Em     {rand {Granule_E_leak_lb} {Granule_E_leak_ub}}
       call /granule_cell_layer/Granule[{i-1}]/solve HPUT /granule_cell_layer/Granule[{i-1}]/soma
       pope

       pushe /granule_cell_layer/Granule[{i-1}]/soma/mf_AMPA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Granule[{i-1}]/solve HPUT .
       pope

       pushe /granule_cell_layer/Granule[{i-1}]/soma/mf_NMDA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Granule[{i-1}]/solve HPUT .
       pope

       pushe /granule_cell_layer/Granule[{i-1}]/soma/GABAA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Granule[{i-1}]/solve HPUT .
       pope


//       echo randomized granule cell {i}
   end

// randseed 12345
   echo randomizing Golgi cells
   for (i = {number_Golgi_cells}; i > 0; i = i - 1)
       pushe /granule_cell_layer/Golgi[{i-1}]/soma
       initvm = {rand {Vm_init_lb} {Vm_init_ub}}
       setfield . initVm {initvm}
       setfield . Vm     {initvm}
       setfield . Em     {rand {Golgi_E_leak_lb} {Golgi_E_leak_ub}}
       call /granule_cell_layer/Golgi[{i-1}]/solve HPUT /granule_cell_layer/Golgi[{i-1}]/soma
       pope
/*
       pushe /granule_cell_layer/Golgi[{i-1}]/soma/mf_AMPA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
       pope
*/
// weight_distribution = 0.71

       pushe /granule_cell_layer/Golgi[{i-1}]/soma/pf_AMPA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
       pope
/*
       pushe /granule_cell_layer/Golgi[{i-1}]/soma/mf_AMPA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
       pope
*/
// weight_distribution = 0.15

       pushe /granule_cell_layer/Golgi[{i-1}]/soma/GABAA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
       pope

//       echo randomized Golgi cell {i}
   end

   echo randomizing stellate cells
   for (i = {number_stellate_cells}; i > 0; i = i - 1)
       pushe /molecular_layer/Stellate[{i-1}]/soma
       initvm = {rand {Vm_init_lb} {Vm_init_ub}}
       setfield . initVm {initvm}
       setfield . Vm     {initvm}
       setfield . Em     {rand {Stellate_E_leak_lb} {Stellate_E_leak_ub}}
       call /molecular_layer/Stellate[{i-1}]/solve HPUT /molecular_layer/Stellate[{i-1}]/soma
       pope

       pushe /molecular_layer/Stellate[{i-1}]/soma/pf_AMPA
       setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
       call /molecular_layer/Stellate[{i-1}]/solve HPUT .
       pope

//       echo randomized stellate cell {i}
   end







