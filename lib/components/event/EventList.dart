import 'package:flutter/material.dart';
import 'EventItem.dart';
import 'package:calendar/model/EventVO.dart';

class EventList extends StatelessWidget {
  EventList({required this.data});
  final List<EventVO> data;

  Widget renderItem(EventVO event) {
    return EventItem(event);
  }

  @override
  Widget build(BuildContext context) {

    return  ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int index) {
        return renderItem(data[index]);
      },
    );
  }

}