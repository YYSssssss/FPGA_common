// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 5/2/19                                                      //
// Module       :                                                             //
// Description  :                                                             //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //

interface jb_ctrl_rf_control_if #( 
    parameter N_CARRIERS  = 2, 
    parameter N_ANTENNAS   = 4
);

    logic [15:0]        ant_switch_delay;
    logic               pa_switch_override;
    logic   [6:1]       pa_switch_en_n;
    logic   [6:1]       pa_switch_n;
    


modport master (
output  ant_switch_delay, pa_switch_override,  pa_switch_en_n,  pa_switch_n 
);


modport slave (
input  ant_switch_delay, pa_switch_override,  pa_switch_en_n,  pa_switch_n 
 );

endinterface
 
		
