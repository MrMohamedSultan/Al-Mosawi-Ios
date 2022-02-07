class ProductCourses {
  final title;
  final price;
  final proImageUrl;

  ProductCourses({this.proImageUrl, this.title, this.price});
}

class ProductConsualt {
  final title;
  final price;
  final proImageUrl;
  final date;
  final time;
  final consulId;
  final dateId;

  ProductConsualt({
    this.date,
    this.time,
    this.proImageUrl,
    this.title,
    this.price,
    this.consulId,
    this.dateId,
  });
}

class ConsultantProdect {
  String title;
  double price;
  String proImageUrl;
  String date;
  String type;
  String time;
  int _id;
  int dateId;
  int consultantId;

  ConsultantProdect(dynamic obj) {
    _id = obj['id'];
    consultantId = obj['consultantId'];
    dateId = obj['dateId'];
    title = obj['title'];
    price = obj['price'];
    proImageUrl = obj['proImageUrl'];
    date = obj['date'];
    type = obj['type'];
    time = obj['time'];
  }
  ConsultantProdect.formMap(Map<String, dynamic> data) {
    _id = data['id'];
    consultantId = data['consultantId'];
    dateId = data['dateId'];
    title = data['title'];
    price = data['price'];
    proImageUrl = data['proImageUrl'];
    date = data['date'];
    type = data['type'];
    time = data['time'];
  }
  Map<String, dynamic> toMap() => {
        'id': _id,
        'consultantId': consultantId,
        'dateId': dateId,
        'title': title,
        'price': price,
        'proImageUrl': proImageUrl,
        'date': date,
        'time': time,
        'type': type,
      };
}

class CustomVisa {
  String cvvNumber;
  String exDate;
  String type;
  String visaNumber;
  int _id;
  CustomVisa(dynamic obj) {
    _id = obj['id'];
    cvvNumber = obj['cvvNumber'];
    exDate = obj['exDate'];
    type = obj['type'];
    visaNumber = obj['visaNumber'];
  }
  CustomVisa.formMap(Map<String, dynamic> data) {
    _id = data['id'];
    cvvNumber = data['cvvNumber'];
    exDate = data['exDate'];
    type = data['type'];
    visaNumber = data['visaNumber'];
  }
  Map<String, dynamic> toMap() => {
        'id': _id,
        'cvvNumber': cvvNumber,
        'exDate': exDate,
        'visaNumber': visaNumber,
        'type': type,
      };
}

List<ProductConsualt> productConsualtList = [];
