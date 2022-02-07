import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/MyMessagesApi.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/services/network_sensitive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ahmad_pro/models/utils.dart';

import 'dart:io';
// import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:dio/dio.dart';

class ChatRome extends StatefulWidget {
  final String title;
  final MyMassege message;
  final int messageID;

  const ChatRome({Key key, this.title, this.message, this.messageID})
      : super(key: key);
  @override
  _ChatRomeState createState() => _ChatRomeState();
}

class _ChatRomeState extends State<ChatRome> {
  List<String> messageList = [];
  TextEditingController _messageController = TextEditingController();
  List<File> listFiles = [];
  bool loading = false;

  get customColorbottomBar => null;

  @override
  Widget build(BuildContext context) {
    print("messageID:${widget.messageID}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NetworkSensitive(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (loading)
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : Expanded(
                      child: FutureBuilder(
                        future: MyMessageApi.fetchAllMyMassegeComments(
                            widget.messageID),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snapshot.data.comments.length,
                              itemBuilder: (context, index) {
                                return MessageTile(
                                  message: snapshot.data.comments[index]
                                      ['content'],
                                  isSendByme: snapshot.data.comments[index]
                                          ['sender'] ==
                                      "user",
                                  date: snapshot.data.comments[index]
                                      ['created_at'],
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator.adaptive());
                          }
                        },
                      ),
                    ),
              (widget.message.status != 'مفتوح')
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: messageTextFiled(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  sentData({
    String message,
    int messageID,
    List<File> files,

    // ignore: non_constant_identifier_names
  }) async {
    print(files.isEmpty);
    try {
      var data;
      // ignore: prefer_is_not_empty
      if (!files.isEmpty) {
        var filesForm = [];
        for (var items in files) {
          filesForm.add(await MultipartFile.fromFile(
            items.path,
            filename: items.path.split('/').last,
          ));
        }

        print('filesForm:$filesForm');

        print('filesForm[0]:${filesForm[0]}');
        data = FormData.fromMap({
          'Comment': message,
          "files": filesForm,
        });
      } else {
        print(files.isEmpty);

        data = FormData.fromMap({
          'Comment': message,
          "files": [],
        });
      }
      Dio dio = new Dio();
      Response response = await dio.post(
          Utils.MyMessages_URL + '/${User.userid}/$messageID',
          data: data);

      if (response.data['status'] == 'success') {
        showMyDialog(
          context: context,
          message: "تم ارسال الرسالة بنجاح",
        );
        setState(() {
          loading = !loading;
        });

        listFiles.clear();
      } else {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          context: context,
          message: response.data['errorArr'].toString(),
        );
      }
      listFiles.clear();
    } catch (e) {
      print('Cash errrrrrrrrrrrrrrror');
      setState(() {
        loading = !loading;
      });
      showMyDialog(
        context: context,
        message: "حدث خطا اثناء الارسال يرجي المحاوله مجددا",
      );

      listFiles.clear();
      print(e);
    }
  }

  Container serviesMessage({String message}) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: customColorbottomBar,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          message,
          textDirection: TextDirection.ltr,
          style: AppTheme.subHeading,
        ),
      ),
    );
  }

  Container messageTextFiled() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: customColor2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              maxLines: null,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText:
                    (loading) ? 'جاري ارسال الرساله....' : 'اكتب تعليق ....',
                hintStyle: AppTheme.subHeading.copyWith(
                  fontSize: 10,
                  color: customColorIcon,
                ),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  // List<File> res = await FilePicker.getMultiFile(
                  //   type: FileType.any,
                  // );
                  // if (res == null) {
                  // } else {
                  //   listFiles = res;
                  fileDialog(
                    context: context,
                    message: 'تم اضاقه ${listFiles.length} ملفات',
                  );
                  // }
                },
                icon: Icon(Icons.upload_file),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    loading = !loading;
                    messageList.add(_messageController.text);
                    sentData(
                      message: _messageController.text,
                      messageID: widget.message.id,
                      files: listFiles,
                    );
                    _messageController.text = '';
                  });
                },
                child: Container(
                  child: Icon(
                    Icons.send,
                    color: customColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> fileDialog({BuildContext context, String message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    (message) ??
                        'تم اضافة الطلب لستكمال عمليه الشراء عليه الذهاب الي عربة التسوق',
                    style: AppTheme.subHeading,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'حسنا',
                style: AppTheme.heading.copyWith(
                  color: customColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'الغاء',
                style: AppTheme.heading.copyWith(
                  color: customColor,
                ),
              ),
              onPressed: () {
                listFiles.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MessageTile extends StatefulWidget {
  final String message;
  final bool isSendByme;
  final String date;

  const MessageTile({Key key, this.message, this.isSendByme, this.date})
      : super(key: key);
  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    print(widget.isSendByme);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      alignment:
          (widget.isSendByme) ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: (widget.isSendByme)
            ? EdgeInsets.only(left: 100)
            : EdgeInsets.only(right: 100),
        decoration: BoxDecoration(
            color: (widget.isSendByme) ? customColor : Color(0xffff1f1f1),
            borderRadius: (widget.isSendByme)
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parseHtmlString(widget.message) ?? '',
              style: AppTheme.heading.copyWith(
                color: (widget.isSendByme) ? Colors.white : customColor,
                fontSize: 11,
              ),
            ),
            Align(
              alignment: (!widget.isSendByme)
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: Text(
                widget.date ?? '',
                style: AppTheme.heading.copyWith(
                  color: (widget.isSendByme) ? Colors.white : customColor,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
