import 'package:flutter/material.dart';

class RowLabelWidget extends StatefulWidget {
  final String labelText;
  final String valueText;
  final double dividerHeight;
  final bool isDividerVisible;
  final double endIntend;
  final double padding;
  final Color dividerColor;

  RowLabelWidget(
      {Key key,
      this.labelText,
      this.valueText,
      this.dividerHeight,
      this.padding,
      this.endIntend = 1.0,
      this.dividerColor = Colors.grey,
      this.isDividerVisible})
      : super(key: key);

  @override
  _RowLabelWidgetState createState() => _RowLabelWidgetState();
}

class _RowLabelWidgetState extends State<RowLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.all(widget.padding == null ? 12.0 : widget.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(widget.labelText,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: Text(widget.valueText ?? "",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.isDividerVisible ?? true,
            child: Divider(
              height: widget.dividerHeight ?? 14,
              indent: 10,
              endIndent: widget.endIntend ?? 1.0,
              color: widget.dividerColor,
            ),
          )
        ],
      ),
    );
  }
}
