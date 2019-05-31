// genesis (R.M. 12/12/95)

include defaults

float DELTA_X = 1.0
int   i

/* 

The function "make_mossy_fiber_array" creates {length} mossy fibers,
named /white_matter/mossy_fiber[0] to /white_matter/mossy_fiber
[{length} - 1].  Each mossy fiber is a randomspike element with firing
rate {mossy_fiber_firing_rate} and with absolute refractory period
{mossy_fiber_refractory_period}.


*/

function make_mossy_fiber_array  (length, firing_rate, refractory_period)

   int   length
   float firing_rate, refractory_period


   if(!{exists /library})
          create neutral /library 
          disable /library
   end


   create randomspike /library/mossy_fiber
   setfield ^ rate {mossy_fiber_firing_rate} \
              abs_refract {mossy_fiber_refractory_period}
   create spikegen /library/mossy_fiber/spike 
   setfield ^ thresh 0.5 abs_refract {mossy_fiber_refractory_period}
   addmsg /library/mossy_fiber /library/mossy_fiber/spike INPUT state

   if(!{exists /white_matter}) 
          create neutral /white_matter
   end

   createmap /library/mossy_fiber /white_matter \
             {length} 1 -delta {mossy_fiber_separation} 0.0 \
                        -origin {(- {mossy_fiber_to_Golgi_cell_ratio} / 2) * {mossy_fiber_separation}} 0.0

end
