
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PurchaseEvent extends Equatable{
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class LoadFMPurchase extends PurchaseEvent{}

class GetFieldListForFMPurchase extends PurchaseEvent {}

class SetInitialProductList extends PurchaseEvent {}

class UpdateFieldButtonState extends PurchaseEvent {
  final int index;

  const UpdateFieldButtonState({
    @required this.index,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => 'UpdateFieldButtonState { index : $index}';
}

class UpdateFieldName extends PurchaseEvent {
  final int index;
  final int field;

  const UpdateFieldName({
    @required this.index,
    @required this.field,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateFieldName { 
    index : $index,
    field : $field,
  }''';
}

class UpdateProductName extends PurchaseEvent {
  final int index;
  final String name;

  const UpdateProductName({
    @required this.index,
    @required this.name,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateProductName { 
    index : $index,
    field : $name,
  }''';
}

class UpdateAmount extends PurchaseEvent {
  final int index;
  final String amount;

  const UpdateAmount({
    @required this.index,
    @required this.amount,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateAmount { 
    index : $index,
    field : $amount,
  }''';
}

class UpdatePrice extends PurchaseEvent {
  final int index;
  final String price;

  const UpdatePrice({
    @required this.index,
    @required this.price,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdatePrice { 
    index : $index,
    field : $price,
  }''';
}

class UpdateMarketUrl extends PurchaseEvent {
  final int index;
  final String url;

  const UpdateMarketUrl({
    @required this.index,
    @required this.url,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateMarketUrl { 
    index : $index,
    field : $url,
  }''';
}

class UpdateMemo extends PurchaseEvent {
  final int index;
  final String memo;

  const UpdateMemo({
    @required this.index,
    @required this.memo,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateMemo { 
    index : $index,
    field : $memo,
  }''';
}

class SetAdditionalProduct extends PurchaseEvent {}

class CompletePurchase extends PurchaseEvent {}

class GetPurchaseList extends PurchaseEvent {}

class SetListOrder extends PurchaseEvent {
  final int columnIndex;

  const SetListOrder({
    @required this.columnIndex,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetListOrder { 
    columnIndex : $columnIndex,
  }''';
}

class SetSubmissionState extends PurchaseEvent {}

class UpdateDropdownMenuState extends PurchaseEvent {}

class UpdateMenuIndex extends PurchaseEvent {
  final int menuIndex;

  const UpdateMenuIndex({
    @required this.menuIndex,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''UpdateMenuIndex { 
    menuIndex : $menuIndex,
  }''';
}

class GetPurchaseListBySearch extends PurchaseEvent {
  final String word;

  const GetPurchaseListBySearch({
    @required this.word,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''GetPurchaseListBySearch { 
    word : $word,
  }''';
}

class SetProduct extends PurchaseEvent {
  final Purchase product;

  const SetProduct({
    @required this.product,
  });

  // @override
  // List<Object> get props => [navTo];

  @override
  String toString() => '''SetProduct { 
    product : $product,
  }''';
}

class MarkAsRead extends PurchaseEvent {}