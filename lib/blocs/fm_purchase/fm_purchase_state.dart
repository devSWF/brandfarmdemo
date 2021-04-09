

import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FMPurchaseState {
  bool isLoading;
  Timestamp curr;
  Farm farm;
  List<Field> fieldList;
  Field field;
  List<FMPurchase> productList;
  List<FMPurchase> productListFromDB;
  int currentSortColumn;
  bool isAscending;

  FMPurchaseState({
    @required this.isLoading,
    @required this.curr,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.productList,
    @required this.productListFromDB,
    @required this.currentSortColumn,
    @required this.isAscending,
  });

  factory FMPurchaseState.empty() {
    return FMPurchaseState(
      isLoading: false,
      curr: Timestamp.now(),
      farm: Farm(farmID: '', fieldCategory: '', managerID: ''),
      fieldList: [],
      field: Field(
          fieldCategory: '',
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: ''),
      productList: [],
      productListFromDB: [],
      currentSortColumn: 0,
      isAscending: true,
    );
  }

  FMPurchaseState copyWith({
    bool isLoading,
    Timestamp curr,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPurchase> productList,
    List<FMPurchase> productListFromDB,
    int currentSortColumn,
    bool isAscending,
  }) {
    return FMPurchaseState(
      isLoading: isLoading ?? this.isLoading,
      curr: curr ?? this.curr,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      productList: productList ?? this.productList,
      productListFromDB: productListFromDB ?? this.productListFromDB,
      currentSortColumn: currentSortColumn ?? this.currentSortColumn,
      isAscending: isAscending ?? this.isAscending,
    );
  }

  FMPurchaseState update({
    bool isLoading,
    Timestamp curr,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<FMPurchase> productList,
    List<FMPurchase> productListFromDB,
    int currentSortColumn,
    bool isAscending,
  }) {
    return copyWith(
      isLoading: isLoading,
      curr: curr,
      farm: farm,
      fieldList: fieldList,
      field: field,
      productList: productList,
      productListFromDB: productListFromDB,
      currentSortColumn: currentSortColumn,
      isAscending: isAscending,
    );
  }

  @override
  String toString() {
    return '''FMPurchaseState{
    isLoading: $isLoading,
    curr: $curr,
    farm: ${farm},
    fieldList: ${fieldList.length},
    field: ${field},
    productList: ${productList.length},
    productListFromDB: ${productListFromDB.length},
    currentSortColumn: ${currentSortColumn},
    isAscending: ${isAscending},
    }
    ''';
  }
}
