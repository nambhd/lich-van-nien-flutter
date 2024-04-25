import 'package:calendar/constants/vn_anniversary_days.dart';

getAnniversaryDay(int lunarDay, int lunarMonth, int solarDay, int solarMonth) {
  var result = null;

  for(int i = 0; i < LUNAR_ANNIVERSARY_DAYS.length; i++) {
    var element = LUNAR_ANNIVERSARY_DAYS[i];
    if (element['d'] == lunarDay && element['m'] == lunarMonth) {
      result = element;
      break;
    }
  }
  
  if (result != null)
    return result['i'];

  for(int i = 0; i < SOLAR_ANNIVERSARY_DAYS.length; i++) {
    var element = SOLAR_ANNIVERSARY_DAYS[i];
    if (element['d'] == solarDay && element['m'] == solarMonth) {
      result = element;
      break;
    }
  }
  
   if (result != null)
    return result['i'];
  
  return '';
}