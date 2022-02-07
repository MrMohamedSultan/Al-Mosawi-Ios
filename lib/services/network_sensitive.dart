import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/enums/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  final double opacity;

  NetworkSensitive({
    this.child,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    // if (connectionStatus == ConnectivityStatus.WiFi) {
    return child;
    // }

    // if (connectionStatus == ConnectivityStatus.Cellular) {
    //   return child;
    // }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            FontAwesomeIcons.wifi,
            size: 50,
            color: customColor,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'لا ‏يوجد ‏اتصال ‏بالإنترنت',
          style: AppTheme.subHeading.copyWith(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
