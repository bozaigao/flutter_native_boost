import 'package:flutter/cupertino.dart';

// ignore: public_member_api_docs
class ContainerPageRouteBuilder<T> extends PageRouteBuilder<T> {
  // ignore: public_member_api_docs
  ContainerPageRouteBuilder({
    RouteSettings? settings,
    required WidgetBuilder pageBuilder,
  }) : super(
            transitionDuration: Duration(microseconds: 0),
            settings: settings,
            pageBuilder: (context, _, __) => pageBuilder(context),
            maintainState: true);

  @override
  Future<RoutePopDisposition> willPop() {
    return Future.value(RoutePopDisposition.bubble);
  }
}
