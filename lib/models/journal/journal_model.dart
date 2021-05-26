import 'package:BrandFarm/models/journal/widget_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'farming_model.dart';
import 'fertilize_model.dart';
import 'pest_model.dart';
import 'pesticide_model.dart';
import 'planting_model.dart';
import 'seeding_model.dart';
import 'shipment_model.dart';
import 'watering_model.dart';
import 'weeding_model.dart';
import 'workforce_model.dart';

class Journal {
  final String fid;
  final String fieldCategory;
  final String jid;
  final String uid;
  final Timestamp date;
  final String title;
  final String content;
  final List<Widgets> widgets;
  final List<String> widgetList;
  final int comments;
  final bool isReadByFM;
  final bool isReadByOffice;
  final Timestamp updatedDate;

  ///출하정보
  final List<Shipment> shipment;

  ///비료정보
  final List<Fertilize> fertilize;

  ///농약정보
  final List<Pesticide> pesticide;

  ///병,해충정보
  final List<Pest> pest;

  ///정식정보
  final List<Planting> planting;

  ///파종정보
  final List<Seeding> seeding;

  ///제초정보
  final List<Weeding> weeding;

  ///관수정보
  final List<Watering> watering;

  ///인력투입정보
  final List<Workforce> workforce;

  ///경운정보
  final List<Farming> farming;

  Journal({
    @required this.fid,
    @required this.fieldCategory,
    @required this.jid,
    @required this.uid,
    @required this.date,
    @required this.title,
    @required this.content,
    @required this.widgets,
    @required this.widgetList,
    @required this.comments,
    @required this.isReadByFM,
    @required this.isReadByOffice,
    @required this.updatedDate,
    @required this.shipment,
    @required this.fertilize,
    @required this.pesticide,
    @required this.pest,
    @required this.planting,
    @required this.seeding,
    @required this.weeding,
    @required this.watering,
    @required this.workforce,
    @required this.farming,
  });

  factory Journal.empty() {
    return Journal(
      fid: '',
      fieldCategory: '',
      jid: '',
      uid: '',
      date: Timestamp.now(),
      title: '',
      content: '',
      widgetList: [],
      widgets: [],
      comments: 0,
      isReadByFM: false,
      isReadByOffice: false,
      updatedDate: Timestamp.now(),
      shipment: [],
      farming: [],
      fertilize: [],
      watering: [],
      weeding: [],
      workforce: [],
      planting: [],
      pest: [],
      pesticide: [],
      seeding: [],
    );
  }

  factory Journal.fromDs(DocumentSnapshot ds) {
    List<Widgets> _temp = ds["widgets"]
        .map((dynamic widget) {
          return Widgets.fromDs(widget);
        })
        .cast<Widgets>()
        .toList();

    return Journal(
      fid: ds['fid'],
      fieldCategory: ds['fieldCategory'],
      jid: ds['jid'],
      uid: ds['uid'],
      date: ds['date'],
      title: ds['title'],
      content: ds['content'],
      widgets: ds["widgets"] == null ? null : _temp,
      widgetList: List.from(ds["widgetList"]),
      comments: ds['comments'],
      isReadByFM: ds['isReadByFM'],
      isReadByOffice: ds['isReadByOffice'],
      updatedDate: ds['updatedDate'],
      shipment: ds['shipment'] == null
          ? null
          : ds["shipment"]
              .map((dynamic item) {
                return Shipment.fromDs(item);
              })
              .cast<Shipment>()
              .toList(),
      fertilize: ds['fertilize'] == null
          ? null
          : ds["fertilize"]
              .map((dynamic item) {
                return Fertilize.fromDs(item);
              })
              .cast<Fertilize>()
              .toList(),
      pesticide: ds['pesticide'] == null
          ? null
          : ds["pesticide"]
              .map((dynamic item) {
                return Pesticide.fromDs(item);
              })
              .cast<Pesticide>()
              .toList(),
      pest: ds['pest'] == null
          ? null
          : ds["pest"]
              .map((dynamic item) {
                return Pest.fromDs(item);
              })
              .cast<Pest>()
              .toList(),
      planting: ds['planting'] == null
          ? null
          : ds["planting"]
              .map((dynamic item) {
                return Planting.fromDs(item);
              })
              .cast<Planting>()
              .toList(),
      seeding: ds['seeding'] == null
          ? null
          : ds["seeding"]
              .map((dynamic item) {
                return Seeding.fromDs(item);
              })
              .cast<Seeding>()
              .toList(),
      weeding: ds['weeding'] == null
          ? null
          : ds["weeding"]
              .map((dynamic item) {
                return Weeding.fromDs(item);
              })
              .cast<Weeding>()
              .toList(),
      watering: ds['watering'] == null
          ? null
          : ds["watering"]
              .map((dynamic item) {
                return Watering.fromDs(item);
              })
              .cast<Watering>()
              .toList(),
      workforce: ds['workforce'] == null
          ? null
          : ds["workforce"]
              .map((dynamic item) {
                return Workforce.fromDs(item);
              })
              .cast<Workforce>()
              .toList(),
      farming: ds['farming'] == null
          ? null
          : ds["farming"]
              .map((dynamic item) {
                return Farming.fromDs(item);
              })
              .cast<Farming>()
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> shipment = [];
    List<Map<String, dynamic>> fertilize = [];
    List<Map<String, dynamic>> pesticide = [];
    List<Map<String, dynamic>> pest = [];
    List<Map<String, dynamic>> planting = [];
    List<Map<String, dynamic>> seeding = [];
    List<Map<String, dynamic>> weeding = [];
    List<Map<String, dynamic>> watering = [];
    List<Map<String, dynamic>> workforce = [];
    List<Map<String, dynamic>> farming = [];
    List<Map<String, dynamic>> widgets = this.widgets.map((Widgets widget) {
      return widget.toMap();
    }).toList();

    ///출하정보
    if (this.shipment != null) {
      shipment = this.shipment.map((Shipment shipment) {
        return shipment.toMap();
      }).toList();
    }

    ///비료정보
    if (this.fertilize != null) {
      fertilize = this.fertilize.map((Fertilize fertilize) {
        return fertilize.toMap();
      }).toList();
    }

    ///농약정보
    if (this.pesticide != null) {
      pesticide = this.pesticide.map((Pesticide pesticide) {
        return pesticide.toMap();
      }).toList();
    }

    ///병,해충정보
    if (this.pest != null) {
      pest = this.pest.map((Pest pest) {
        return pest.toMap();
      }).toList();
    }

    ///정식정보
    if (this.planting != null) {
      planting = this.planting.map((Planting planting) {
        return planting.toMap();
      }).toList();
    }

    ///파종정보
    if (this.seeding != null) {
      seeding = this.seeding.map((Seeding seeding) {
        return seeding.toMap();
      }).toList();
    }

    ///제초정보
    if (this.weeding != null) {
      weeding = this.weeding.map((Weeding weeding) {
        return weeding.toMap();
      }).toList();
    }

    ///관수정보
    if (this.watering != null) {
      watering = this.watering.map((Watering watering) {
        return watering.toMap();
      }).toList();
    }

    ///인력투입정보
    if (this.workforce != null) {
      workforce = this.workforce.map((Workforce workforce) {
        return workforce.toMap();
      }).toList();
    }

    ///경운정보
    if (this.farming != null) {
      farming = this.farming.map((Farming farming) {
        return farming.toMap();
      }).toList();
    }

    return {
      'fid': this.fid,
      'fieldCategory': this.fieldCategory,
      'jid': this.jid,
      'uid': this.uid,
      'date': this.date,
      'title': this.title,
      'content': this.content,
      'widgets': this.widgets == null ? null : widgets,
      'widgetList': this.widgetList,
      'comments': this.comments,
      'isReadByFM': this.isReadByFM,
      'isReadByOffice': this.isReadByOffice,
      'updatedDate': this.updatedDate,
      'shipment': this.shipment == null ? null : shipment,
      'fertilize': this.fertilize == null ? null : fertilize,
      'pesticide': this.pesticide == null ? null : pesticide,
      'pest': this.pest == null ? null : pest,
      'planting': this.planting == null ? null : planting,
      'seeding': this.seeding == null ? null : seeding,
      'weeding': this.weeding == null ? null : weeding,
      'watering': this.watering == null ? null : watering,
      'workforce': this.workforce == null ? null : workforce,
      'farming': this.farming == null ? null : farming,
    };
  }
}
