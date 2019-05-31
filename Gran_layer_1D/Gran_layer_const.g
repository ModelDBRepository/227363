// See also instructions at the bottom of this file.

// Small networks for visualization or debugging were run with
// the following parameters:
//   int  number_mossy_fibers = 6 // 540 
//   int  number_granule_cells = 15 // 5355 
//   int  number_Golgi_cells =  2 // 30 
//   float   mossy_fiber_to_Golgi_cell_ratio =  3 // 18
// The numbers behind the // give the values used for large networks in the paper,
// but cannot be run with online graphical output on the screen.



// directory name for ascii output
   str filename = "results/"

// chanmode for hsolver
   int  chanmode = 4 // 3

// cell numbers
   int  number_mossy_fibers = 6 // 540 //  may be overwritten below
   int  number_granule_cells = 15 // 5355 //  may be overwritten in Gran_layer_setup.g
   int  number_Golgi_cells =   2 // 30 // fixed
   int  number_stellate_cells = 0 

// topographics : describes distances along the parallel-fiber axis (1D) only

   // separation between adjacent Golgi cells
      float Golgi_cell_separation  =  300e-6   // meter

   // ratio of number of mossy fibers over number of Golgi cells : an uneven number
      float   mossy_fiber_to_Golgi_cell_ratio =  3 // 18 //  9 // 3
            number_mossy_fibers = {number_Golgi_cells} * {mossy_fiber_to_Golgi_cell_ratio} 

   // ratio of number of stellate cells over number of Golgi cells : an uneven number
      int   stellate_cell_to_Golgi_cell_ratio = 0 // 5
            number_stellate_cells = {number_Golgi_cells} * {stellate_cell_to_Golgi_cell_ratio}

   // separation between adjacent mossy fibers
      float mossy_fiber_separation = {Golgi_cell_separation} / {mossy_fiber_to_Golgi_cell_ratio} // meter

   // separation between adjacent stellate cells
      float stellate_cell_separation = {Golgi_cell_separation} / {stellate_cell_to_Golgi_cell_ratio} // meter

   // 4 mossy fibers can converge onto a single granule cell only when they fall
   // within a circle with the following radius, the position of the created 
   // granule cell will be the midpoint of the 4 afferent mossy fibers 
      float mossy_fiber_to_granule_cell_connection_radius = 5 // in {mossy_fiber_separation} units

   // probability that a granule cell is created for a combination of 4 valid mossy fiber positions
      float P_mossy_fiber_to_granule_cell_connection = 1.0   // probability

   // radius for mossy fiber to Golgi cell connections
      float mossy_fiber_to_Golgi_cell_radius = {Golgi_cell_separation} / 2.0    // meter

   // overlap of Golgi cell axons : integer
      int Golgi_cell_axon_overlap = 1 // 1 // 3

   // radius for Golgi cell to granule cell connections 
      float Golgi_cell_to_granule_cell_radius  =  \
                       {Golgi_cell_separation} * {Golgi_cell_axon_overlap} / 2.0  // meter

   // radius for stellate cell to Golgi cell connections
      float stellate_cell_to_Golgi_cell_radius = {Golgi_cell_separation} / 2.0    // meter

   // length parallel fiber
      float parallel_fiber_length = 5.0e-3   // meter

// mossy fiber input
   float mossy_fiber_firing_rate = 50 // 10 //  25          // sec^-1
   float mossy_fiber_refractory_period = 0.005 // sec
   float interburst_interval = 0.1             // sec
   float burst_duration      = 0.01           // sec
   float burst_intensity     = 1.0              // multiplied by mossy_fiber_firing_rate 


// synaptic probabilities
   float P_mossy_fiber_to_Golgi_cell_synapse      =  1.0 // probability 
   float P_granule_cell_to_Golgi_cell_synapse     =  1.0 // 0.2 // 1.0 // probability
   float P_Golgi_cell_to_granule_cell_synapse     =  1.0 // probability
   float P_mossy_fiber_to_granule_cell_synapse    = {4.0 / number_mossy_fibers} // probability
   float P_stellate_cell_to_Golgi_cell_synapse    =  1.0 // probability
   float P_granule_cell_to_stellate_cell_synapse  =  0.1 // probability


// synaptic weights : the normalization is now done in RECALC of synchan !!!!

   float weight_mossy_fiber_granule_cell_AMPA_synapse = 6.0 
   float weight_mossy_fiber_granule_cell_NMDA_synapse = 4.0  
   float weight_mossy_fiber_Golgi_cell_synapse   = 0.0 // {dt} * 2.0 // 6.0
   float weight_granule_cell_Golgi_cell_synapse  =  45.0  // 18.0 // 15  // 6.0
   float weight_granule_cell_stellate_cell_synapse  = \
                   {weight_granule_cell_Golgi_cell_synapse * P_granule_cell_to_stellate_cell_synapse \
                                                           / P_granule_cell_to_Golgi_cell_synapse}
   float weight_Golgi_cell_granule_cell_GABAA_synapse  = 45.0  // 30.0 // 45.0 
   float weight_Golgi_cell_granule_cell_GABAB_synapse  = \
                 0.0 //   {weight_Golgi_cell_granule_cell_GABAA_synapse / 2} // 0.0
   float weight_stellate_cell_Golgi_cell_synapse = {weight_Golgi_cell_granule_cell_GABAA_synapse / 2}

// synaptic delays
   float delay_mossy_fiber_granule_cell_synapse =  0.0
   float delay_mossy_fiber_Golgi_cell_synapse   =  0.0
   float delay_granule_cell_Golgi_cell_synapse  =  0.0
   float delay_Golgi_cell_granule_cell_synapse  =  0.0
   float delay_stellate_cell_Golgi_cell_synapse =  0.0
   float parallel_fiber_conduction_velocity = 0.5  // m/s

float time_axis_graph = 1.0

float weight_distribution  = 0.15
float delay_distribution  = 0.0


/*** INSTRUCTIONS ***/
/* Some parameters have to be consistent with each other.

The basic parameters are : (1) the number of Golgi cells (number_Golgi_cells),
(2) the ratio of the number of mossy fibers to the number of Golgi cells 
(mossy_fiber_to_Golgi_cell_ratio), and (3) the span value for mossy fiber
ramification (mossy_fiber_to_granule_cell_connection_radius).

The number of mossy fibers (number_mossy_fibers) is derived from (1)
and (2), the number of granule cells (number_granule_cells) is derived
in Script Gran_layer_setup.g from number_mossy_fibers and (3).

Nevertheless, number_mossy_fibers and number_granule_cells must be correctly
initialized because these variables are used in some other scripts.

To know with which value number_granule_cells should be initialized,
you can run the simulation and abort it after script
Gran_layer_setup.g has been completed.  The correct number is printed
on the screen by Gran_layer_setup.g ("made ... numbers of granule cells").

*/
