import 'package:BrandFarm/models/journal/journal_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class LoadJournal extends JournalEvent {}

class GetInitialList extends JournalEvent {}

class LoadJournalDetail extends JournalEvent {}

class JournalDetailLoaded extends JournalEvent {}

class GetListBySelectedDate extends JournalEvent {
  final String year;
  final String month;

  const GetListBySelectedDate({
    @required this.year,
    @required this.month,
  });

  @override
  List<Object> get props => [year, month];

  @override
  String toString() => 'GetListBySelectedDate { month: $month, year: $year }';
}

class GetIssueListByTimeOrder extends JournalEvent {
  final String issueListOption;
  final String issueListOrderOption;

  const GetIssueListByTimeOrder(
      {@required this.issueListOption, @required this.issueListOrderOption});

  @override
  List<Object> get props => [issueListOption, issueListOrderOption];

  @override
  String toString() =>
      'GetIssueListByTimeOrder { issueListOption: $issueListOption, issueListOrderOption: $issueListOrderOption }';
}

class GetIssueListByCategory extends JournalEvent {
  final int issueState;

  const GetIssueListByCategory({
    @required this.issueState,
  });

  @override
  List<Object> get props => [issueState];

  @override
  String toString() => 'GetIssueListByCategory { issueState: $issueState, }';
}

class WaitForLoadMore extends JournalEvent {}

class LoadMore extends JournalEvent {
  final int tab;

  const LoadMore({
    @required this.tab,
  });

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'LoadMore { tab: $tab, }';
}

class AddIssueComment extends JournalEvent {
  final String id;

  const AddIssueComment({
    @required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];

  @override
  String toString() => '''AddComment { 
      id: $id, 
      }''';
}

class SetUpdatedDateIssue extends JournalEvent {
  final String id;

  const SetUpdatedDateIssue({
    @required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];

  @override
  String toString() => '''SetUpdatedDateIssue { 
      id: $id, 
      }''';
}

class AddJournalComment extends JournalEvent {
  final String id;

  const AddJournalComment({
    @required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];

  @override
  String toString() => '''AddComment { 
      id: $id, 
      }''';
}

class SetUpdatedDate extends JournalEvent {
  final String id;

  const SetUpdatedDate({
    @required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];

  @override
  String toString() => '''SetUpdatedDate { 
      id: $id, 
      }''';
}

class PassSelectedJournal extends JournalEvent {
  final Journal journal;
  const PassSelectedJournal({
    this.journal,
  });
  @override
  String toString() {
    return '''PassSelectedJournal{
    Journal : ${journal}
    ''';
  }
}

class PassSelectedIssue extends JournalEvent {
  final SubJournalIssue issue;
  const PassSelectedIssue({
    @required this.issue,
  });
  @override
  String toString() {
    return '''PassSelectedIssue{
    issue : ${issue}
    ''';
  }
}
