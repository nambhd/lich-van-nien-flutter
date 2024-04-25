import 'package:calendar/utils/lunar_solar_utils.dart';

const CAN = ['Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'];
const CHI = ['Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'];
const TIETKHI = ['Xuân phân', 'Thanh minh', 'Cốc vũ', 'Lập hạ', 'Tiểu mãn', 'Mang chủng',
'Hạ chí', 'Tiểu thử', 'Đại thử', 'Lập thu', 'Xử thử', 'Bạch lộ',
'Thu phân', 'Hàn lộ', 'Sương giáng', 'Lập đông', 'Tiểu tuyết', 'Đại tuyết',
'Đông chí', 'Tiểu hàn', 'Đại hàn', 'Lập xuân', 'Vũ thủy', 'Kinh trập'
];
const GIO_HD = ['110100101100', '001101001011', '110011010010', '101100110100', '001011001101', '010010110011'];

getLunarYearNameInCanChi(int lunarYear) {
  var can = CAN[(lunarYear + 6) % 10];
  var chi = CHI[(lunarYear + 8) % 12];

  return '${can} ${chi}';
}

getLunarMonthNameInCanChi(int lunarMonth, int lunarYear) {
  var can = CAN[(lunarYear * 12 + lunarMonth + 3) % 10];
  var chi = CHI[(lunarMonth + 1) % 12];

  return '${can} ${chi}';
}

/*
 Get Can-Chi of lunar month.
 If this month is leap month, the lunar month name in Can-Chi has "(nhuận)" at the end
*/
getLunarMonthNameInCanChiV2(int lunarMonth, int lunarYear) {
  var can = CAN[(lunarYear * 12 + lunarMonth + 3) % 10];
  var chi = CHI[(lunarMonth + 1) % 12];

  // TODO: Check leap month
  return '${can} ${chi}';
}

getLunarDayNameInCanChi(int jdn) {
  var can = CAN[(jdn + 9) % 10];
  var chi = CHI[(jdn + 1) % 12];

  return '${can} ${chi}';
}

// TODO: NEED refactor
getBeginHour(jdn) {
  return CAN[(jdn - 1) * 2 % 10] + ' ' +  CHI[0];
}

// TODO: NEED refactor
getCanHour(jdn) {
  return CAN[(jdn - 1) * 2 % 10];
}

// TODO: NEED refactor
getGioHoangDao(jd) {
  var chiOfDay = (jd+1) % 12;
  var gioHD = GIO_HD[chiOfDay % 6]; // same values for Ty' (1) and Ngo. (6), for Suu and Mui etc.
  var ret = "";
  var count = 0;
  for (var i = 0; i < 12; i++) {
    if (gioHD.substring(i, i + 1) == '1') {
      ret += CHI[i];
      ret += ' (${{(i*2+23)%24}}-${{(i*2+1)%24}})';
      if (count++ < 5) ret += ', ';
      if (count == 3) ret += '\n';
    }
  }
  return ret;
}

// TODO: NEED refactor
getTietKhi(jd) {
  return TIETKHI[getSunLongitude(jd + 1, 7.0)];
}
