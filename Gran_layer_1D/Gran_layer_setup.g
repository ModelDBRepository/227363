// genesis
// included stellate cells, rmaex 19/6/96

include defaults
include Gran_layer_const.g

function make_synapse (pre, post, weight, delay)
   str     pre, post
   float   weight, delay
   int     syn_num

   addmsg {pre} {post} SPIKE
   syn_num = {getfield {post} nsynapses} - 1
   setfield {post} synapse[{syn_num}].weight  {weight} \
                   synapse[{syn_num}].delay   {delay}
end

function comb (C, n)
   int   C, n, fac, i, num, denom
   
   denom = 1
   for (i = n; i > 1; i = i - 1)
       denom = {denom * i}
   end
   if ({C < n})
       num = 0
   else num = C
   end
   for (i = 1; i < n; i = i + 1)
       num = {num * (C - i)}
   end
   fac = {num / denom}
   return (fac)
end

/*************************  neurons and mossy fibers   *****************/

   if ({number_mossy_fibers} < 4)
        number_mossy_fibers = 4
   end  // otherwise the synapse loops are not executed !!

// make /white_matter/mossy_fiber[0-number_mossy_fibers]
   include Mossy_fiber.g
   echo the number of mossy fibers is {number_mossy_fibers}
   if ({{number_mossy_fibers} > 0})
      make_mossy_fiber_array {number_mossy_fibers} \
                             {mossy_fiber_firing_rate} \
                          {mossy_fiber_refractory_period}
   end
   echo made  {number_mossy_fibers} mossy fibers

// make /granule_cell_layer/Granule[0-number_granule_cells]
   include Granule_cell.g
   number_granule_cells = 0 
   int i, var_comb
   var_comb = {comb {mossy_fiber_to_granule_cell_connection_radius} 3}
   for (i = 1; i <= {number_mossy_fibers}; i = i + 1)
       if ({i <= mossy_fiber_to_granule_cell_connection_radius})
            number_granule_cells = {number_granule_cells + {comb {i - 1} 3}} 
       else number_granule_cells = {number_granule_cells} + {var_comb}
       end
   end   
   if ({{number_granule_cells} > 0})
      make_granule_cell_array {number_granule_cells}
   end
   echo made {number_granule_cells} granule cells

// make /granule_cell_layer/Golgi[0-number_Golgi_cells]
   include Golgi_cell.g
   if ({{number_Golgi_cells} > 0})
      make_Golgi_cell_array {number_Golgi_cells}
   end
   echo made {number_Golgi_cells} Golgi cells

// make /molecular_layer/Stellate[0-number_stellate_cells]
/*   include Stellate_cell.g
   if ({{number_stellate_cells} > 0})
      make_stellate_cell_array {number_stellate_cells}
   end
   echo made {number_stellate_cells} stellate cells
*/
/************************    synapses                  *****************/


int i, j, k, l, index


// make AMPA synapses from mossy fibers to all Golgi cells
// within a circle of radius {mossy_fiber_to_Golgi_cell_radius}

   if ({{weight_mossy_fiber_Golgi_cell_synapse} > 0})
      planarconnect /white_matter/mossy_fiber[]/spike \
                    /granule_cell_layer/Golgi[]/soma/mf_AMPA \
                    -relative \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask   ellipse 0 0 {mossy_fiber_to_Golgi_cell_radius} \
                                            {mossy_fiber_to_Golgi_cell_radius} \
                    -probability {P_mossy_fiber_to_Golgi_cell_synapse}
      planarweight /white_matter/mossy_fiber[]/spike \
                    /granule_cell_layer/Golgi[]/soma/mf_AMPA -fixed \
                   {weight_mossy_fiber_Golgi_cell_synapse} -uniform {weight_distribution}
      planardelay   /white_matter/mossy_fiber[]/spike \
                    /granule_cell_layer/Golgi[]/soma/mf_AMPA -fixed \
                   {delay_mossy_fiber_Golgi_cell_synapse} -uniform {delay_distribution}
   end  
   echo connected {number_mossy_fibers} mossy fibers to {number_Golgi_cells} \
        Golgi cells with probability {P_mossy_fiber_to_Golgi_cell_synapse}

 

// make AMPA and NMDA synapses from mossy fibers to granule cells, each granule cell
// receiving a different combination of 4 different mossy fiber inputs within a circle
// with radius {mossy_fiber_to_granule_cell_connection_radius}

float delay_factor
int   lb_mossy_fiber = 0  // lower boundary

   index = 0
   for (i = 3; i < {number_mossy_fibers}; i = i + 1)

//       lb_mossy_fiber = 0;
//       while ({{getfield /white_matter/mossy_fiber[lb_mossy_fiber] x} +   \
//               {mossy_fiber_to_granule_cell_connection_radius} <          \
//               {getfield /white_matter/mossy_fiber[lb_mossy_fiber] x}})
//             lb_mossy_fiber = {lb_mossy_fiber} + 1
//       end

   lb_mossy_fiber = {i - mossy_fiber_to_granule_cell_connection_radius}
   if (lb_mossy_fiber < 0)
       lb_mossy_fiber = 0
   end
   for (j = i - 1;                 j >= {lb_mossy_fiber}; j = j - 1)
   for (k = j - 1;                 k >= {lb_mossy_fiber}; k = k - 1)
   for (l = k - 1;                 l >= {lb_mossy_fiber}; l = l - 1)

   if ({{{index} < {number_granule_cells}} && \
        {{rand 0 1} <= {P_mossy_fiber_to_granule_cell_connection}}})

       position /granule_cell_layer/Granule[{index}] \
                 {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                   {getfield /white_matter/mossy_fiber[{j}] x} + \
                   {getfield /white_matter/mossy_fiber[{k}] x} + \
                   {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} 0.0 0.0 


        delay_factor = {1 + {delay_distribution} * {rand -1 1}}
        if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
            make_synapse /white_matter/mossy_fiber[{i}]/spike \
                         /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                         {weight_mossy_fiber_granule_cell_AMPA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                         {delay_mossy_fiber_granule_cell_synapse * delay_factor}
            echo made AMPA synapse from mossy fiber {i} to granule cell {index}
        end
        if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
            make_synapse /white_matter/mossy_fiber[{i}]/spike \
                         /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                         {weight_mossy_fiber_granule_cell_NMDA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                         {delay_mossy_fiber_granule_cell_synapse * delay_factor}
            echo made NMDA synapse from mossy fiber {i} to granule cell {index}
        end

        delay_factor = {1 + {delay_distribution} * {rand -1 1}}
        if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
             make_synapse /white_matter/mossy_fiber[{j}]/spike \
                          /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                          {weight_mossy_fiber_granule_cell_AMPA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                          {delay_mossy_fiber_granule_cell_synapse  * delay_factor}
             echo made AMPA synapse from mossy fiber {j} to granule cell {index}
        end
        if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
             make_synapse /white_matter/mossy_fiber[{j}]/spike \
                          /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                          {weight_mossy_fiber_granule_cell_NMDA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                          {delay_mossy_fiber_granule_cell_synapse  * delay_factor}
             echo made NMDA synapse from mossy fiber {j} to granule cell {index}
        end

        delay_factor = {1 + {delay_distribution} * {rand -1 1}}
        if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
             make_synapse /white_matter/mossy_fiber[{k}]/spike \
                          /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                          {weight_mossy_fiber_granule_cell_AMPA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                          {delay_mossy_fiber_granule_cell_synapse * delay_factor}
             echo made AMPA synapse from mossy fiber {k} to granule cell {index}
        end
        if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
             make_synapse /white_matter/mossy_fiber[{k}]/spike \
                          /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                          {weight_mossy_fiber_granule_cell_NMDA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                          {delay_mossy_fiber_granule_cell_synapse * delay_factor}
             echo made NMDA synapse from mossy fiber {k} to granule cell {index}
        end

        delay_factor = {1 + {delay_distribution} * {rand -1 1}}
        if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
             make_synapse /white_matter/mossy_fiber[{l}]/spike \
                          /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                          {weight_mossy_fiber_granule_cell_AMPA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                          {delay_mossy_fiber_granule_cell_synapse * delay_factor}
             echo made AMPA synapse from mossy fiber {l} to granule cell {index}
        end
        if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
             make_synapse /white_matter/mossy_fiber[{l}]/spike \
                          /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                          {weight_mossy_fiber_granule_cell_NMDA_synapse  * (1 + {weight_distribution} * {rand -1 1})} \
                          {delay_mossy_fiber_granule_cell_synapse * delay_factor}
             echo made NMDA synapse from mossy fiber {l} to granule cell {index}
        end
   end
   index = {index} + 1
   end
   end
   end
   end


// make AMPA synapses from granule cells to Golgi cells

   if ({{weight_granule_cell_Golgi_cell_synapse} > 0})
      planarconnect /granule_cell_layer/Granule[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/pf_AMPA \
                    -relative \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask   box -{parallel_fiber_length / 2.0} -1e10 \
                                     {parallel_fiber_length / 2.0}  1e10 \ 
                    -probability {P_granule_cell_to_Golgi_cell_synapse}
      planarweight /granule_cell_layer/Granule[]/soma/spike \
                   /granule_cell_layer/Golgi[]/soma/pf_AMPA \
                   -fixed {weight_granule_cell_Golgi_cell_synapse} -uniform {weight_distribution}
      planardelay   /granule_cell_layer/Granule[]/soma/spike \ 
                    /granule_cell_layer/Golgi[]/soma/pf_AMPA \ // -fixed {delay_granule_cell_Golgi_cell_synapse} \
                   -radial {parallel_fiber_conduction_velocity} -uniform {delay_distribution}
//      planardelay   /granule_cell_layer/Granule[]/soma/spike \ 
//                    /granule_cell_layer/Golgi[]/soma/pf_AMPA \ 
//                   -add \ // to account for width Golgi cell dendritic tree
//                   -fixed {(Golgi_cell_separation / 2.0) / parallel_fiber_conduction_velocity} \
//                   -absoluterandom \
//                   -uniform {(Golgi_cell_separation / 2.0) / parallel_fiber_conduction_velocity}
   end
   echo connected {number_granule_cells} granule cells to {number_Golgi_cells} \
        Golgi cells with probability {P_granule_cell_to_Golgi_cell_synapse}

// make AMPA synapses from granule cells to stellate cells

   if ({{weight_granule_cell_stellate_cell_synapse} > 0})
      planarconnect /granule_cell_layer/Granule[]/soma/spike \
                    /molecular_layer/Stellate[]/soma/pf_AMPA \
                    -relative \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask   box -{parallel_fiber_length / 2.0} -1e10 \
                                     {parallel_fiber_length / 2.0}  1e10 \ 
                    -probability {P_granule_cell_to_stellate_cell_synapse}
      planarweight /granule_cell_layer/Granule[]/soma/spike \
                    /molecular_layer/Stellate[]/soma/pf_AMPA \
                    -fixed {weight_granule_cell_stellate_cell_synapse} -uniform {weight_distribution}
      planardelay   /granule_cell_layer/Granule[]/soma/spike \ 
                    /molecular_layer/Stellate[]/soma/pf_AMPA \ // -fixed {delay_granule_cell_Golgi_cell_synapse} \
                    -radial {parallel_fiber_conduction_velocity} -uniform {delay_distribution}
   end
   echo connected {number_granule_cells} granule cells to {number_stellate_cells} \
        stellate cells with probability {P_granule_cell_to_stellate_cell_synapse}



// make GABA_A synapses from Golgi cells to granule cells

   if ({{weight_Golgi_cell_granule_cell_GABAA_synapse} > 0})
      planarconnect /granule_cell_layer/Golgi[]/soma/spike \
                    /granule_cell_layer/Granule[]/soma/GABAA \
                    -relative \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask  ellipse 0 0 {Golgi_cell_to_granule_cell_radius} \
                                           {Golgi_cell_to_granule_cell_radius} \ 
                    -probability {P_Golgi_cell_to_granule_cell_synapse}
      planarweight /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAA \
                   -fixed {weight_Golgi_cell_granule_cell_GABAA_synapse} -uniform {weight_distribution}
      planardelay /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAA \
                   -fixed {delay_Golgi_cell_granule_cell_synapse} -uniform {delay_distribution}
   end
   if ({{weight_Golgi_cell_granule_cell_GABAB_synapse} > 0})
      planarconnect /granule_cell_layer/Golgi[]/soma/spike \
                    /granule_cell_layer/Granule[]/soma/GABAB \
                    -relative \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask ellipse 0 0 {Golgi_cell_to_granule_cell_radius} \
                                           {Golgi_cell_to_granule_cell_radius} \ 
                    -probability {P_Golgi_cell_to_granule_cell_synapse}
      planarweight /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAB \
                   -fixed {weight_Golgi_cell_granule_cell_GABAB_synapse} -uniform {weight_distribution}
      planardelay /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAB \
                   -fixed {delay_Golgi_cell_granule_cell_synapse} -uniform {delay_distribution}
   end



   echo connected {number_Golgi_cells} Golgi cells to {number_granule_cells} \
        granule cells with probability {P_Golgi_cell_to_granule_cell_synapse}


// make GABA_A synapses from stellate cells to Golgi cells

   if ({{weight_stellate_cell_Golgi_cell_synapse} > 0})
      planarconnect /molecular_layer/Stellate[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/GABAA \
                    -relative \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask  ellipse 0 0 {stellate_cell_to_Golgi_cell_radius} \
                                           {stellate_cell_to_Golgi_cell_radius} \ 
                    -probability {P_stellate_cell_to_Golgi_cell_synapse}

      planarweight /molecular_layer/Stellate[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/GABAA \
                    -fixed {weight_stellate_cell_Golgi_cell_synapse} -uniform {weight_distribution}
      planardelay   /molecular_layer/Stellate[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/GABAA \
                    -fixed {delay_stellate_cell_Golgi_cell_synapse} -uniform {delay_distribution}
   end

   echo connected {number_stellate_cells} stellate cells to {number_Golgi_cells} \
        Golgi cells with probability {P_stellate_cell_to_Golgi_cell_synapse}

