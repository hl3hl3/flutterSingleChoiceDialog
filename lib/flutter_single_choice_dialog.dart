library flutter_single_choice_dialog;

import 'package:flutter/material.dart';

typedef OptionTitleBuilder<T> = Widget Function(BuildContext context, T option);

const kRoundedRectangleBorder16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)));

///
/// Sample
///
///
/// ```dart
/// final result = await showDialog(
///     context: context,
///     barrierDismissible: false,
///     builder: (context) {
///       return SingleChoiceDialog<String>(
///         initValue: '白底橘子',
///         options: [
///           '虎斑',
///           '橘虎斑',
///           '白底橘虎斑',
///           '黑虎斑',
///           '白底黑虎斑',
///           '橘子',
///           '白底橘子',
///           '賓士',
///           '乳牛',
///           '三花',
///         ],
///         titleBuilder: (context, option) {
///           return Text(option);
///         },
///         ok: "確定",
///         cancel: "取消",
///       );
///     },
///   ).then((result) {
///     debugPrint('result: $result');
///   });
/// ```
///
///
///
class SingleChoiceDialog<T> extends StatefulWidget {
  final T initValue;
  final List<T> options;
  final OptionTitleBuilder titleBuilder;
  final String ok;
  final String cancel;
  final Color activeColor;
  final Color okTextColor;
  final Color cancelTextColor;
  final Color splashColor;
  final Color buttonBarDividerColor;
  final double buttonBarDividerHeight;
  final double itemHeight;
  final int displayItemCount;
  final double radioWidth;
  final ShapeBorder shape;

  SingleChoiceDialog({
    this.initValue,
    this.options,
    this.titleBuilder,
    this.ok = "OK",
    this.cancel = "CANCEL",
    this.activeColor = Colors.green,
    this.okTextColor = Colors.green,
    this.cancelTextColor = Colors.green,
    this.splashColor = Colors.transparent,
    this.buttonBarDividerColor = const Color(0xfff2f2f2),
    this.buttonBarDividerHeight = 1,
    this.itemHeight = 48,
    this.displayItemCount = 7,
    this.radioWidth = 56,
    this.shape = kRoundedRectangleBorder16,
  });

  @override
  _SingleChoiceDialogState createState() => _SingleChoiceDialogState<T>();
}

class _SingleChoiceDialogState<T> extends State<SingleChoiceDialog<T>> {
  T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initValue;
  }

  _onChanged(T value) {
    selectedValue = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /// listTile 高度是根據 material design
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);
    // We divide by 4.0 because we want half of the average of the left and right padding.
    final double paddingUnit = buttonTheme.padding.horizontal / 4.0;

    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 20),
      shape: widget.shape,
      content: Wrap(
        children: <Widget>[
          SizedBox(
            height: widget.itemHeight * widget.displayItemCount,
            child: SingleChildScrollView(
              child: Column(
                children: widget.options
                    .map(
                      (T itemValue) => InkWell(
                    splashColor: widget.splashColor,
                    onTap: () {
                      _onChanged(itemValue);
                    },
                    child: Container(
                      height: widget.itemHeight,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: widget.radioWidth,
                            child: Radio(
                              activeColor: widget.activeColor,
                              value: itemValue,
                              groupValue: selectedValue,
                              onChanged: _onChanged,
                            ),
                          ),
                          widget.titleBuilder(context, itemValue),
                        ],
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
          Divider(
            color: widget.buttonBarDividerColor,
            height: widget.buttonBarDividerHeight,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingUnit, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _button(
                    widget.cancel, widget.cancelTextColor, _onPressedCancel),
                _button(widget.ok, widget.okTextColor, _onPressedOk),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, Color textColor, Function onPressed) =>
      FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        onPressed: onPressed,
      );

  _onPressedCancel() => Navigator.pop(context, widget.initValue);

  _onPressedOk() => Navigator.pop(context, selectedValue);
}