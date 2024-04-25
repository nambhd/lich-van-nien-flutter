import 'package:calendar/utils/anniversary_day_utils.dart';
import 'package:calendar/utils/can_chi_utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:calendar/components/StrokeText.dart';
import 'package:calendar/components/SelectDateButton.dart';
import 'package:calendar/utils/date_utils.dart';
import 'package:calendar/utils/lunar_solar_utils.dart';
import 'package:calendar/services/DataService.dart';
import 'package:calendar/model/QuoteVO.dart';
import 'package:calendar/components/SwipeDetector.dart';

class SingleDayContainer extends StatefulWidget {
  @override
  State createState() {
    return _SingleDayContainerState();
  }
}

class _SingleDayContainerState extends State<SingleDayContainer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SingleDayContainer> {
  List<QuoteVO> _quoteData = new List<QuoteVO>.empty();

  DateTime _selectedDate = DateTime.now();
  var jd;
  var lunarDate, lunarDay, lunarMonth, lunarYear, lunarLeap;
  
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    this._getData();

    jd = jdn(_selectedDate.day, _selectedDate.month, _selectedDate.year);
    var lunarDate = convertSolar2Lunar(_selectedDate.day, _selectedDate.month, _selectedDate.year, 7);
    lunarDay = lunarDate[0];
    lunarMonth = lunarDate[1];
    lunarYear = lunarDate[2];
    lunarLeap = lunarDate[3];

    //_animation
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _controller.value = 0.8;
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    //timer update datetime
    const oneSec = const Duration(seconds: 2);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              DateTime now = DateTime.now();
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, now.hour, now.minute, now.second);
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _getData() async {
    var data = await loadQuoteData();
    setState(() {
      _quoteData = data;
    });
  }

  _onSwipeLeft() {
    _controller.value = 0.8;
    _controller.forward();
    setState(() {
      _selectedDate = decreaseDay(_selectedDate);
    });
  }

  _onSwipeRight() {
    _controller.value = 0.8;
    _controller.forward();
    setState(() {
      _selectedDate = increaseDay(_selectedDate);
    });
  }

  Future<Null> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1920, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Widget paddingText(double top, String text, TextStyle style) {
    return Padding(
      padding: EdgeInsets.only(top: top, left: 10, right: 10),
      child: Text(text, style: style),
    );
  }

  Widget getHeader(context) {
    var title = 'Tháng ${_selectedDate.month} - ${_selectedDate.year}';
    var todayStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: new Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: SelectDateButton(
                  title: title,
                  onPress: () {
                    _showDatePicker(context);
                  })),
          Align(
            alignment: Alignment.topLeft,
              child: Container(
                height: 40,
                  width: 100,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedDate = DateTime.now();
                      });
                    },
                    child: Center(
                      child: Text("Hôm Nay",
                        style: todayStyle,
                      ),
                    ),
                  ))
          )
        ],
      ),
    );
  }

  Widget getMainDate() {
    var backgroundIndex = (_selectedDate.day % 17);
    var dayOfWeek = getNameDayOfWeek(_selectedDate);
    var anniversaryDay = getAnniversaryDay(lunarDay, lunarMonth, _selectedDate.day, _selectedDate.month);

    if (_quoteData.length > 0) {
    }
    const dayOfWeekStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    );

    const quoteStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
    );

    const quoteAuthorStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return Expanded(
      child: SwipeDetector(
        onSwipeRight: () {
          this._onSwipeRight();
        },
        onSwipeLeft: () {
          this._onSwipeLeft();
        },
        child: FadeTransition(
          opacity: _animation,
          child: (
              Stack(
            children: <Widget>[
              new Positioned.fill(
                child: Image(
                  image: AssetImage('assets/image_${backgroundIndex + 1}.jpg'),
                  fit: BoxFit.cover,
                  width: 1200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: StrokeText(
                        _selectedDate.day.toString(),
                        strokeWidth: 0,
                        fontSize: 120,
                        color: Colors.white,
                        strokeColor: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    this.paddingText(5, dayOfWeek, dayOfWeekStyle),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: this.paddingText(20, anniversaryDay, quoteStyle),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child:
                            this.paddingText(20, '', quoteAuthorStyle),
                      ),
                    ),
                    Expanded(
                      child: this.getDateInfo(),
                    )
                  ],
                ),
              ),
              this.getHeader(context),
            ],
          )),
        ),
      ),
    );
  }

  Widget infoBox(Widget widget, bool hasBorder) {
    return Expanded(
      child: (Container(
        height: 120,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(color: Colors.grey, width: hasBorder ? 1 : 0))),
        child: widget,
      )),
    );
  }

  Widget bottomBox(Widget widget) {
    return Expanded(
      child: (Container(
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                top:
                    BorderSide(color: Colors.grey, width: 1))),
        child: widget,
      )),
    );
  }

  Widget getDateInfo() {
    var headerStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    var bodyStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);
    var bottomStyle = TextStyle(color: Colors.white);
    var smallBottomStyle = TextStyle(color: Colors.white, fontSize: 12);
    var dayStyle = TextStyle(
        color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);
    
    var hourMinute = '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}';

    var lunarYearNameInCanChi = getLunarYearNameInCanChi(lunarYear);
    var lunarMonthNameInCanChi = getLunarMonthNameInCanChi(lunarMonth, lunarYear);
    var lunarDayNameInCanChi = getLunarDayNameInCanChi(jd);

    var gioHoangDao = getGioHoangDao(jd);
    var beginHourNameInCanChi = getBeginHourNameInCanChi(jd);

    return Container(
      height: 120,
      color: Colors.black.withOpacity(0.3),
      child: (new IntrinsicHeight(
        child: Column(
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                this.infoBox(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(hourMinute, style: bodyStyle),
                        Text('Giờ đầu:\n${beginHourNameInCanChi}', style: smallBottomStyle),
                      ],
                    ),
                    true),
                this.infoBox(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(lunarDay.toString(), style: dayStyle),
                        Text('THÁNG ${lunarMonth.toString()}', style: headerStyle),
                      ],
                    ),
                    true),
                this.infoBox(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Năm ${lunarYearNameInCanChi}\nTháng ${lunarMonthNameInCanChi}\nNgày ${lunarDayNameInCanChi}', style: smallBottomStyle),
                      ],
                    ),
                    false)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                this.bottomBox(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Giờ Hoàng Đạo:', style: smallBottomStyle),
                        Text('${gioHoangDao}', style: smallBottomStyle)
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: <Widget>[
      this.getMainDate(),
    ]);
  }

  @override
  bool get wantKeepAlive => true;

}
