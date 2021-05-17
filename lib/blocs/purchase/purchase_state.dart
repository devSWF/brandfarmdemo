

import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseState {
  bool isLoading;
  Timestamp curr;
  Farm farm;
  List<Field> fieldList;
  Field field;
  List<Purchase> productList;
  List<Purchase> productListFromDB;
  List<Purchase> productListBySearch;
  int currentSortColumn;
  bool isAscending;
  bool isSubmitted;

  List<String> menu;
  int menuIndex;
  bool showDropdownMenu;
  Purchase product;

  PurchaseState({
    @required this.isLoading,
    @required this.curr,
    @required this.farm,
    @required this.fieldList,
    @required this.field,
    @required this.productList,
    @required this.productListFromDB,
    @required this.productListBySearch,
    @required this.currentSortColumn,
    @required this.isAscending,
    @required this.isSubmitted,
    @required this.menu,
    @required this.menuIndex,
    @required this.showDropdownMenu,
    @required this.product,
  });

  factory PurchaseState.empty() {
    return PurchaseState(
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
      productListBySearch: [],
      currentSortColumn: 0,
      isAscending: false,
      isSubmitted: false,
      menu: ['자재명', '신청자', '수령인'],
      menuIndex: 0,
      showDropdownMenu: false,
      product: null,
    );
  }

  PurchaseState copyWith({
    bool isLoading,
    Timestamp curr,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<Purchase> productList,
    List<Purchase> productListFromDB,
    List<Purchase> productListBySearch,
    int currentSortColumn,
    bool isAscending,
    bool isSubmitted,
    List<String> menu,
    int menuIndex,
    bool showDropdownMenu,
    Purchase product,
  }) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      curr: curr ?? this.curr,
      farm: farm ?? this.farm,
      fieldList: fieldList ?? this.fieldList,
      field: field ?? this.field,
      productList: productList ?? this.productList,
      productListFromDB: productListFromDB ?? this.productListFromDB,
      productListBySearch: productListBySearch ?? this.productListBySearch,
      currentSortColumn: currentSortColumn ?? this.currentSortColumn,
      isAscending: isAscending ?? this.isAscending,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      menu: menu ?? this.menu,
      menuIndex: menuIndex ?? this.menuIndex,
      showDropdownMenu: showDropdownMenu ?? this.showDropdownMenu,
      product: product ?? this.product,
    );
  }

  PurchaseState update({
    bool isLoading,
    Timestamp curr,
    Farm farm,
    List<Field> fieldList,
    Field field,
    List<Purchase> productList,
    List<Purchase> productListFromDB,
    List<Purchase> productListBySearch,
    int currentSortColumn,
    bool isAscending,
    bool isSubmitted,
    List<String> menu,
    int menuIndex,
    bool showDropdownMenu,
    Purchase product,
  }) {
    return copyWith(
      isLoading: isLoading,
      curr: curr,
      farm: farm,
      fieldList: fieldList,
      field: field,
      productList: productList,
      productListFromDB: productListFromDB,
      productListBySearch: productListBySearch,
      currentSortColumn: currentSortColumn,
      isAscending: isAscending,
      isSubmitted: isSubmitted,
      menu: menu,
      menuIndex: menuIndex,
      showDropdownMenu: showDropdownMenu,
      product: product,
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
    productListBySearch: ${productListBySearch.length},
    currentSortColumn: ${currentSortColumn},
    isAscending: ${isAscending},
    isSubmitted: ${isSubmitted},
    menu: ${menu.length},
    menuIndex: ${menuIndex},
    showDropdownMenu: ${showDropdownMenu},
    product: ${product},
    }
    ''';
  }
}
