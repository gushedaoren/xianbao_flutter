import 'package:beir_flutter/model/EventModel.dart';
import 'package:event_bus/event_bus.dart';

class EventBusUtils {
  static EventBus? _instance;

  static EventBus getInstance() {
    if (null == _instance) {
      _instance = new EventBus();
    }
    return _instance!;
  }

  static updateHomeData(){

    print("updateHomeData");
    EventBusUtils.getInstance().fire(BLEvent("requestGameHomePageInfo"));
  }


  static updateDuanshiHomeData(){

    print("updateDuanshiHomeData");
    EventBusUtils.getInstance().fire(BLEvent("updateDuanshiHomeData"));
  }
  static updateShujuHomeData(){

    print("updateShujuHomeData");
    EventBusUtils.getInstance().fire(BLEvent("updateShujuHomeData"));
  }

  static updateWaterHomeData(){

    print("updateWaterHomeData");
    EventBusUtils.getInstance().fire(BLEvent("updateWaterHomeData"));
  }


  static updatePageMe(){

    print("updatePageMe");
    EventBusUtils.getInstance().fire(BLEvent("updatePageMe"));
  }
}
