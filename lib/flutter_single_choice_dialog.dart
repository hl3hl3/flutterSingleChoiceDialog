library flutter_single_choice_dialog;

import 'package:flutter/material.dart';

typedef OptionTitleBuilder<T> = Widget Function(BuildContext context, T option);

///
/// Sample
///
/// ```
/// showDialog(
///                context: context,
///                barrierDismissible: false,
///                builder: (context) {
///                  return SingleChooserDialog<String>(
///                    initValue: '白底橘子',
///                    options: [
///                      '虎斑',
///                      '橘虎斑',
///                      '白底橘虎斑',
///                      '黑虎斑',
///                      '白底黑虎斑',
///                      '橘子',
///                      '白底橘子',
///                      '賓士',
///                      '乳牛',
///                      '三花',
///                    ],
///                    titleBuilder: (context, option) {
///                      return Text(option);
///                    },
///                    ok: "確定",
///                    cancel: "取消",
///                  );
///                },
///              ).then((result) {
///                debugPrint('result: $result');
///              });
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
  final double itemHeight;
  final int displayItemCount;

  SingleChoiceDialog({
    @required this.initValue,
    @required this.options,
    @required this.titleBuilder,
    this.ok = "OK",
    this.cancel = "CANCEL",
    this.activeColor = Colors.green,
    this.okTextColor = Colors.green,
    this.cancelTextColor = Colors.green,
    this.itemHeight = 48,
    this.displayItemCount = 7,
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
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: Wrap(
        children: <Widget>[
          SizedBox(
            height: widget.itemHeight * widget.displayItemCount,
            child: SingleChildScrollView(
              child: Column(
                children: widget.options
                    .map(
                      (T itemValue) => SizedBox(
                        height: widget.itemHeight,
                        child: RadioListTile<T>(
                          value: itemValue,
                          groupValue: selectedValue,
                          onChanged: _onChanged,
                          title: widget.titleBuilder(context, itemValue),
                          activeColor: widget.activeColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              _button(widget.cancel, widget.cancelTextColor, _onPressedCancel),
              _button(widget.ok, widget.okTextColor, _onPressedOk),
            ],
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
