
import 'package:equatable/equatable.dart';

abstract class FMPurchaseEvent extends Equatable{
  const FMPurchaseEvent();

  @override
  List<Object> get props => [];
}

class LoadFMPurchase extends FMPurchaseEvent{}

class GetFieldList extends FMPurchaseEvent {}
//
// class SetField extends FMPurchaseEvent {
//   final Field field;
//
//   const SetField({
//     @required this.field,
//   });
//
//   // @override
//   // List<Object> get props => [navTo];
//
//   @override
//   String toString() => 'SetField { field : $field}';
// }
//
// class PostNotification extends FMPurchaseEvent{
//   final NotificationNotice obj;
//
//   const PostNotification({
//     @required this.obj,
//   });
//
//   @override
//   String toString() => '''PostNotification {
//     obj: $obj,
//   }''';
// }