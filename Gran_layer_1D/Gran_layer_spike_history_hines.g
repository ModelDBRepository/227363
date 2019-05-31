// genesis

include Gran_layer_const.g

str label = "test"


str mossy_fibers_history_filename   = (filename) @ "mossy_fibers_"   @ {label} @ ".history"
str Golgi_cells_history_filename    = (filename) @ "Golgi_cells_"    @ {label} @ ".history"
str Stellate_cells_history_filename = (filename) @ "Stellate_cells_" @ {label} @ ".history" 
str granule_cells_history_filename  = (filename) @ "granule_cells_"  @ {label} @ ".history"

int i
 int size_message_list


// mossy fibers

   if ({number_mossy_fibers > 0})
      echo initializing {mossy_fibers_history_filename}
      create spikehistory mossy_fibers.history
      setfield mossy_fibers.history ident_toggle 0 \ // index
                                    filename {mossy_fibers_history_filename} \
                                    initialize 1 leave_open 1 flush 1
      addmsg /white_matter/mossy_fiber[]/spike mossy_fibers.history SPIKESAVE
   end


// Golgi cells

   if ({number_Golgi_cells > 0})
      echo initializing {Golgi_cells_history_filename}
      create spikehistory Golgi_cells.history
      setfield Golgi_cells.history ident_toggle 0 \ // index
                                   filename {Golgi_cells_history_filename} \
                                   initialize 1 leave_open 1 flush 1
      addmsg /granule_cell_layer/Golgi[]/soma/spike Golgi_cells.history SPIKESAVE
   end


// granule cells

   if ({number_granule_cells > 0})
      echo initializing {granule_cells_history_filename}
      create spikehistory granule_cells.history
      setfield granule_cells.history ident_toggle 0 \ // index
                                     filename {granule_cells_history_filename} \
                                     initialize 1 leave_open 1 flush 1
      addmsg /granule_cell_layer/Granule[]/soma/spike granule_cells.history SPIKESAVE
   end


// Stellate cells

   if ({number_stellate_cells > 0})
      echo initializing {stellate_cells_history_filename}
      create spikehistory stellate_cells.history
      setfield stellate_cells.history ident_toggle 0 \ // index
                                      filename {stellate_cells_history_filename} \
                                      initialize 1 leave_open 1 flush 1
      addmsg /molecular_layer/Stellate[]/soma/spike stellate_cells.history SPIKESAVE
   end


