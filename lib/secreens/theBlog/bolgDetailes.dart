import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/theBolg.dart';
import 'package:flutter/material.dart';

class BolgDetailes extends StatefulWidget {
  final TheBolg theBolg;

  const BolgDetailes({Key key, @required this.theBolg}) : super(key: key);
  @override
  _BolgDetailesState createState() => _BolgDetailesState();
}

class _BolgDetailesState extends State<BolgDetailes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            (widget.theBolg.image == null || widget.theBolg.image == '')
                ? 50
                : 0,
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        children: [
          (widget.theBolg.image == null || widget.theBolg.image == '')
              ? Container()
              : Container(
                  height: 200,
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: customCachedNetworkImage(
                          boxFit: BoxFit.cover,
                          context: context,
                          url: widget.theBolg.image,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: customColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ListView(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: [
              Text(
                widget.theBolg.name,
                style: AppTheme.heading.copyWith(
                  fontSize: 15,
                ),
              ),
              cutomHttpWidget(
                data: (widget.theBolg.contant) ??
                    (widget.theBolg.description) ??
                    '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
