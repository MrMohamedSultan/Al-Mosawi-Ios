import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/MyRoomsApi.dart';
import 'package:ahmad_pro/secreens/my%20courses/components/videoscreens.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ALLRomes extends StatefulWidget {
  @override
  _ALLRomesState createState() => _ALLRomesState();
}

class _ALLRomesState extends State<ALLRomes> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: MyRoomsApi.fetchAllMyRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return (snapshot.data == null || snapshot.data.isEmpty)
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لا يوجد بينات حاليا ',
                          style: AppTheme.heading,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ProchartRoom(
                    rooms: snapshot.data[0],
                  );

            // ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: snapshot.data.length,
            //   itemBuilder: (context, index) {
            //     return Column(
            //       children: [
            //         Card(
            //           elevation: 3,
            //           child: InkWell(
            //             child: Container(
            //               width: MediaQuery.of(context).size.width,
            //               height: 50,
            //               padding: EdgeInsets.symmetric(
            //                   horizontal: 10, vertical: 10),
            //               child: Text(snapshot.data[index].name),
            //             ),
            //             onTap: () {
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(
            //                   builder: (_) => ProchartRoom(
            //                     rooms: snapshot.data[index],
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //         Divider(
            //           color: customColorDivider,
            //           thickness: 2,
            //         ),
            //       ],
            //     );
            //   },
            // );
          } else {
            return Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}

class ProchartRoom extends StatefulWidget {
  final MyRooms rooms;

  const ProchartRoom({
    Key key,
    this.rooms,
  }) : super(key: key);
  @override
  _ProchartRoomState createState() => _ProchartRoomState();
}

class _ProchartRoomState extends State<ProchartRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rooms.name),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: widget.rooms.chats.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: dateType(
                  context: context,
                  type: widget.rooms.chats[index]['type'],
                  data: widget.rooms.chats[index]['data'],
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  dateType({String type, String data, BuildContext context}) {
    // final assetsAudioPlayer = AssetsAudioPlayer();
    switch (type) {
      case 'text':
        return Card(
          elevation: 3,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              data,
              style: AppTheme.subHeading,
            ),
          ),
        );

        break;
      case 'image':
        return Card(
          elevation: 3,
          child: customCachedNetworkImage(context: context, url: data),
        );

        break;
      case 'video':
        return Card(
          elevation: 3,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 260,
            child: ChewieVideo(
              videoUrl: data,
            ),
          ),
        );

        break;
      case 'audio':
        return CustomAudioPalyer(
          url: data,
        );

        break;
      default:
        return null;
    }
  }
}

class CustomAudioPalyer extends StatefulWidget {
  final String url;

  const CustomAudioPalyer({Key key, @required this.url}) : super(key: key);
  @override
  _CustomAudioPalyerState createState() => _CustomAudioPalyerState();
}

class _CustomAudioPalyerState extends State<CustomAudioPalyer> {
  Duration duration = new Duration();
  Duration position = new Duration();
  bool _play = false;

  @override
  Widget build(BuildContext context) {
    return audioPlyer(context);
  }

  audioPlyer(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: AudioWidget.network(
          url: widget.url,
          play: _play,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    _play
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_circle_outline_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _play = !_play;
                    });
                  }),
              Expanded(
                child: slider(),
              ),
            ],
          ),
          onFinished: () {
            setState(() {
              _play = false;
              duration = new Duration();
              position = new Duration();
            });
          },
          onReadyToPlay: (dd) {
            setState(() {
              duration = dd;
            });
          },
          onPositionChanged: (current, dd) {
            setState(() {
              position = current;
            });
          },
        ),
      ),
    );
  }

  slider() {
    return Slider(
      min: 0.0,
      activeColor: customColor,
      inactiveColor: customColor2.withOpacity(.5),
      autofocus: true,
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (val) {},
    );
  }
}
