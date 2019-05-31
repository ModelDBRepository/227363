// genesis
// included stellate cells, rmaex 19/6/96

include defaults
include Gran_layer_const.g

str el
int i

function graph_mossy_fibers

//   create xlabel /xgraphs/mossy_fibers -title "Mossy fibers" [1%, 2%, 32%, 25]

   create xgraph /xgraphs/graph1 [0%, 2%, 25%, 97%]  -title "Mossy fibers"
   setfield ^ xmin 0 xmax {time_axis_graph} ymin 0 ymax {number_mossy_fibers} \
              XUnits "t (sec)"
   useclock ^ 0
   for (i = 0; i < {number_mossy_fibers}; i = i + 1)
        addmsg /white_matter/mossy_fiber[{i}]/spike ^ PLOTSCALE state *"mf"{i} \
               *black 0.5 {i}
   end

end


function graph_Golgi_cells

//   create xlabel /xgraphs/Golgi_cells -title "Golgi cells" [34%, 2%, 32%, 25]

   create xgraph /xgraphs/graph2 [25%, 2%, 25%, 97%] -title "Golgi cells"
   setfield ^ xmin 0 xmax {time_axis_graph} ymin {-0.1 * number_Golgi_cells} ymax 0.05 \
            XUnits "t (sec)" yoffset -0.1
   useclock ^ 0
   for (i = 0; i < {number_Golgi_cells}; i = i + 1)
        el = {findsolvefield /granule_cell_layer/Golgi[{i}]/solve soma Vm}
        addmsg /granule_cell_layer/Golgi[{i}]/solve ^ PLOT {el} *"Vm" *black 
   end

end



function graph_granule_cells

//   create xlabel /xgraphs/granule_cells -title "Granule cells" [67%, 2%, 32%, 25]
 
   create xgraph /xgraphs/graph3 [50%, 2%, 25%, 97%] -title "Granule cells"
   setfield ^ xmin 0 xmax {time_axis_graph} ymin {-0.1 * number_granule_cells} ymax 0.05 \
            XUnits "t (sec)" yoffset -0.1
   useclock ^ 0
   for (i = 0; i < {number_granule_cells}; i = i + 1)
        el = {findsolvefield /granule_cell_layer/Granule[{i}]/solve soma Vm}
        addmsg /granule_cell_layer/Granule[{i}]/solve ^ PLOT {el} *"Vm" *black 
   end

end


function graph_stellate_cells

//   create xlabel /xgraphs/granule_cells -title "Granule cells" [67%, 2%, 32%, 25]
 
   create xgraph /xgraphs/graph4 [75%, 2%, 25%, 97%] -title "Stellate cells"
   setfield ^ xmin 0 xmax {time_axis_graph} ymin {-0.1 * number_stellate_cells} ymax 0.05 \
            XUnits "t (sec)" yoffset -0.1
   useclock ^ 0
   for (i = 0; i < {number_stellate_cells}; i = i + 1)
        el = {findsolvefield /molecular_layer/Stellate[{i}]/solve soma Vm}
        addmsg /molecular_layer/Stellate[{i}]/solve ^ PLOT {el} *"Vm" *black 
   end

end


create xform /xgraphs [0, 450, 1200, 420]

if ({{number_mossy_fibers}  > 0})     graph_mossy_fibers    
end
if ({{number_Golgi_cells}   > 0})     graph_Golgi_cells     
end
if ({{number_granule_cells} > 0})     graph_granule_cells   
end
if ({{number_stellate_cells} > 0})    graph_stellate_cells   
end

xshow /xgraphs

