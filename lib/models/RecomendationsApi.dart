import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArchiveRecomendationsModels {
  final String currencyName;
  final String arrow;
  final String number;
  final List<RecomendationsModels> recomendations;

  ArchiveRecomendationsModels({
    this.currencyName,
    this.arrow,
    this.number,
    this.recomendations,
  });
}

class RecomendationsModels {
  int id;
  final String name;
  final String status;
  var ordered;
  final String theTime;
  final String bigPrice;
  final String buyOrSale;
  final String txtBesideName;
  final String percentageTxt;
  final String points;
  final String smallPrice;
  final String entryPrice;
  final String outPrice;
  final String image;
  final String direction;
  final String forms;
  final String buy;
  final String selling;
  var aimBuy;
  final String stopBuy;
  final String stopSelling;
  final String discount;
  final String createdAt;
  final String updatedAt;
  final String comment;
  final String statusLoss;
  final String buyAreaGoals;
  final String dayDate;
  final String archive;
  final String free;

  RecomendationsModels({
    this.theTime,
    this.buyOrSale,
    this.txtBesideName,
    this.percentageTxt,
    this.points,
    this.buyAreaGoals,
    this.dayDate,
    this.archive,
    this.free,
    this.id,
    this.name,
    this.status,
    this.ordered,
    this.bigPrice,
    this.smallPrice,
    this.entryPrice,
    this.outPrice,
    this.image,
    this.direction,
    this.forms,
    this.buy,
    this.selling,
    this.aimBuy,
    this.stopBuy,
    this.stopSelling,
    this.discount,
    this.createdAt,
    this.updatedAt,
    this.comment,
    this.statusLoss,
  });
}

class RecomendationsApi {
  static Future<List<RecomendationsModels>> fetchAllRecomendations(
      {String type}) async {
    List<RecomendationsModels> listOfRecomendations = [];
    try {
      var response = await http.get(
        Utils.Recomendations_URL + "?type=$type",
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          RecomendationsModels recomendations = RecomendationsModels(
            id: items['id'],
            buyOrSale: items['BuyOrSale'],
            theTime: items['theTime'],
            points: items['Points'],
            txtBesideName: items['TxtBesideName'],
            percentageTxt: items['PercentageTxt'],
            name: items['name'],
            status: items['status'],
            ordered: items['Ordered'],
            bigPrice: items['big_price'],
            smallPrice: items['small_price'],
            entryPrice: items['entry_price'],
            outPrice: items['out_price'],
            image: items['image'],
            direction: items['direction'],
            forms: items['forms'],
            buy: items['buy'],
            selling: items['selling'],
            aimBuy: items['aim_buy'],
            stopBuy: items['stop_buy'],
            stopSelling: items['stop_selling'],
            discount: items['Discount'],
            createdAt: items['created_at'],
            updatedAt: items['updated_at'],
            comment: items['comment'],
            statusLoss: items['status_loss'],
            buyAreaGoals: items['buyAreaGoals'],
            dayDate: items['dayDate'],
            archive: items['archive'],
            free: items['free'],
          );
          listOfRecomendations.add(recomendations);
        }
      }
    } catch (e) {
      print('Erroro Recomendations');
      print(e);
    }
    return listOfRecomendations;
  }

  static Future<List<ArchiveRecomendationsModels>>
      fetchAllArchiveRecomendations({String type}) async {
    List<RecomendationsModels> listOfRecomendations = [];
    List<ArchiveRecomendationsModels> listOfArchiveRecomendations = [];
    try {
      var response = await http.get(
        Utils.Recomendations_URL + "?type=$type",
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          listOfRecomendations = [];
          for (var item in items['recomendations']) {
            RecomendationsModels recomendations = RecomendationsModels(
              id: item['id'],
              buyOrSale: item['BuyOrSale'],
              theTime: item['theTime'],
              points: item['Points'],
              txtBesideName: item['TxtBesideName'],
              percentageTxt: item['PercentageTxt'],
              name: item['name'],
              status: item['status'],
              ordered: item['Ordered'],
              bigPrice: item['big_price'],
              smallPrice: item['small_price'],
              entryPrice: item['entry_price'],
              outPrice: item['out_price'],
              image: item['image'],
              direction: item['direction'],
              forms: item['forms'],
              buy: item['buy'],
              selling: item['selling'],
              aimBuy: item['aim_buy'],
              stopBuy: item['stop_buy'],
              stopSelling: item['stop_selling'],
              discount: item['Discount'],
              createdAt: item['created_at'],
              updatedAt: item['updated_at'],
              comment: item['comment'],
              statusLoss: item['status_loss'],
              buyAreaGoals: item['buyAreaGoals'],
              dayDate: item['dayDate'],
              archive: item['archive'],
              free: item['free'],
            );
            listOfRecomendations.add(recomendations);
          }
          print('listOfRecomendations:$listOfRecomendations');
          ArchiveRecomendationsModels archive = ArchiveRecomendationsModels(
            arrow: items['arrow'],
            currencyName: items['currencyName'],
            number: items['number'],
            recomendations: listOfRecomendations,
          );
          listOfArchiveRecomendations.add(archive);
        }
      }
    } catch (e) {
      print('Erroro Recomendations');
      print(e);
    }
    return listOfArchiveRecomendations;
  }
}
