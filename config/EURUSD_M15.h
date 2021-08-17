/*
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_Demo_Params_M15 : DemoIndiParams {
  Indi_Demo_Params_M15() : DemoIndiParams(indi_demo_defaults, PERIOD_M15) {
    shift = 0;
  }
} indi_demo_m15;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Demo_Params_M15 : StgParams {
  // Struct constructor.
  Stg_Demo_Params_M15() : StgParams(stg_demo_defaults) {
    lot_size = 0;
    signal_open_method = 0;
    signal_open_filter = 4;
    signal_open_level = (float)20;
    signal_open_boost = 0;
    signal_close_method = -4;
    signal_close_level = (float)20;
    price_stop_method = 1;
    price_stop_level = (float)20;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_demo_m15;
