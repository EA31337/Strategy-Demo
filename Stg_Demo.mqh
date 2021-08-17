/**
 * @file
 * Implements Demo strategy based on the Demo indicator.
 */

// User input params.
INPUT string __Demo_Parameters__ = "-- Demo strategy params --";  // >>> Demo <<<
INPUT float Demo_LotSize = 0;               // Lot size
INPUT int Demo_SignalOpenMethod = 0;        // Signal open method
INPUT int Demo_SignalOpenFilterMethod = 0;  // Signal open filter method
INPUT float Demo_SignalOpenLevel = 0;       // Signal open level
INPUT int Demo_SignalOpenBoostMethod = 0;   // Signal open boost method
INPUT int Demo_SignalCloseMethod = 0;       // Signal close method
INPUT float Demo_SignalCloseLevel = 0;      // Signal close level
INPUT int Demo_PriceStopMethod = 0;         // Price limit method
INPUT float Demo_PriceStopLevel = 2;        // Price limit level
INPUT int Demo_TickFilterMethod = 1;        // Tick filter method (0-255)
INPUT float Demo_MaxSpread = 4.0;           // Max spread to trade (in pips)
INPUT short Demo_Shift = 0;                                      // Shift
INPUT int Demo_OrderCloseTime = -20;                             // Order close time in mins (>0) or bars (<0)
INPUT string __Demo_Indi_Demo_Parameters__ =
    "-- Demo strategy: Demo indicator params --";                               // >>> Demo strategy: Demo indicator <<<
INPUT int Demo_Indi_Demo_Shift = 0;                                             // Shift

// Structs.

// Defines struct with default user indicator values.
struct Indi_Demo_Params_Defaults : DemoIndiParams {
  Indi_Demo_Params_Defaults() : DemoIndiParams(::Demo_Indi_Demo_Shift) {}
} indi_demo_defaults;

// Defines struct with default user strategy values.
struct Stg_Demo_Params_Defaults : StgParams {
  Stg_Demo_Params_Defaults()
      : StgParams(::Demo_SignalOpenMethod, ::Demo_SignalOpenFilterMethod, ::Demo_SignalOpenLevel,
                  ::Demo_SignalOpenBoostMethod, ::Demo_SignalCloseMethod, ::Demo_SignalCloseLevel, ::Demo_PriceStopMethod,
                  ::Demo_PriceStopLevel, ::Demo_TickFilterMethod, ::Demo_MaxSpread, ::Demo_Shift, ::Demo_OrderCloseTime) {}
} stg_demo_defaults;

// Struct to define strategy parameters to override.
struct Stg_Demo_Params : StgParams {
  DemoIndiParams iparams;
  StgParams sparams;

  // Struct constructors.
  Stg_Demo_Params(DemoIndiParams &_iparams, StgParams &_sparams)
      : iparams(indi_demo_defaults, _iparams.tf.GetTf()), sparams(stg_demo_defaults) {
    iparams = _iparams;
    sparams = _sparams;
  }
};

// Loads pair specific param values.
#include "config/EURUSD_H1.h"
#include "config/EURUSD_H4.h"
#include "config/EURUSD_H8.h"
#include "config/EURUSD_M1.h"
#include "config/EURUSD_M15.h"
#include "config/EURUSD_M30.h"
#include "config/EURUSD_M5.h"

class Stg_Demo : public Strategy {
 public:
  Stg_Demo(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Demo *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    DemoIndiParams _indi_params(indi_demo_defaults, _tf);
    StgParams _stg_params(stg_demo_defaults);
#ifdef __config__
    SetParamsByTf<DemoIndiParams>(_indi_params, _tf, indi_demo_m1, indi_demo_m5, indi_demo_m15, indi_demo_m30, indi_demo_h1,
                             indi_demo_h4, indi_demo_h8);
    SetParamsByTf<StgParams>(_stg_params, _tf, stg_demo_m1, stg_demo_m5, stg_demo_m15, stg_demo_m30, stg_demo_h1, stg_demo_h4,
                             stg_demo_h8);
#endif
    // Initialize indicator.
    DemoIndiParams demo_params(_indi_params);
    _stg_params.SetIndicator(new Indi_Demo(_indi_params));
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams(_magic_no, _log_level);
    Strategy *_strat = new Stg_Demo(_stg_params, _tparams, _cparams, "Demo");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    Indi_Demo *_indi = GetIndicator();
    bool _is_valid = _indi[_shift].IsValid();
    bool _result = _is_valid;
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    double _value = _indi[_shift][0];
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result = _indi[_shift][0] < _indi[_shift + 1][0];
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result = _indi[_shift][0] < _indi[_shift + 1][0];
        break;
    }
    return _result;
  }
};
