
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FMContactEvent extends Equatable{
  const FMContactEvent();

  @override
  List<Object> get props => [];
}

class LoadFMContact extends FMContactEvent{}

class GetContactList extends FMContactEvent {}

// class GetContactList extends FMContactEvent{
//   final int index;
//
//   const GetContactList({
//     @required this.index,
//   });
//
//   @override
//   String toString() => '''GetContactList {
//     index: $index,
//   }''';
// }