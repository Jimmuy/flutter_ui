import 'package:flutter/widgets.dart';
import 'package:flutter_ui/ui/mixin/ui_mixin.dart';

abstract class YmStatus<T extends StatefulWidget> extends State<T> with UIMixin {
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    initUi(context);
    return buildWidgets(context);
  }

  Widget buildWidgets(BuildContext context);

  handleError(error);
}
