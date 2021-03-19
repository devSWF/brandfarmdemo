
import 'package:equatable/equatable.dart';

abstract class FMPlanEvent extends Equatable{
  const FMPlanEvent();

  @override
  List<Object> get props => [];
}

class LoadFMPlan extends FMPlanEvent{}

class GetFieldListForFMPlan extends FMPlanEvent {}
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