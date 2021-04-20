import 'dart:io';

import 'package:BrandFarm/blocs/journal_issue_create/bloc.dart';
import 'package:BrandFarm/models/image_picture/image_picture_model.dart';
import 'package:BrandFarm/models/sub_journal/sub_journal_model.dart';
import 'package:BrandFarm/repository/image/image_repository.dart';
import 'package:BrandFarm/utils/field_util.dart';
import 'package:BrandFarm/utils/resize_image.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:BrandFarm/repository/sub_journal/sub_journal_repository.dart';

class JournalIssueCreateBloc
    extends Bloc<JournalIssueCreateEvent, JournalIssueCreateState> {
  JournalIssueCreateBloc() : super(JournalIssueCreateState.empty());

  @override
  Stream<JournalIssueCreateState> mapEventToState(
      JournalIssueCreateEvent event) async* {
    if(event is TitleChanged){
      yield* _mapTitleChangedToState(event.title);
    }else if (event is AddImageFile) {
      yield* _mapAddImageFileToState(
          imageFile: event.imageFile, index: event.index, from: event.from);
    } else if (event is SelectImage) {
      yield* _mapSelectImageToState(assetList: event.assetList);
    } else if (event is PressComplete) {
      yield* _mapPressCompleteToState();
    } else if (event is DeleteImageFile) {
      yield* _mapDeleteImageFileToState(removedFile: event.removedFile);
    } else if (event is UploadJournal) {
      yield* _mapUploadJournalToState(
        fid: event.fid,
        sfmid: event.sfmid,
        uid: event.uid,
        title: event.title,
        category: event.category,
        issueState: event.issueState,
        contents: event.contents,
        isReadByFM: event.isReadByFM,
        isReadByOffice: event.isReadByOffice,
      );
    }
  }

  Stream<JournalIssueCreateState> _mapTitleChangedToState(String title) async* {
    yield state.update(title: title);
  }

  Stream<JournalIssueCreateState> _mapAddImageFileToState(
      {File imageFile, int index, int from}) async* {
    List<File> _img = state.imageList;

    if (!_img.contains(imageFile) && from == 0) {
      _img.removeAt(index);
      _img.insert(index, await resizeImage(imageFile));
    }
    if (from == 1) {
      _img.add(await resizeImage(imageFile));
    }

    yield state.update(
      imageList: _img,
    );
  }

  Stream<JournalIssueCreateState> _mapSelectImageToState(
      {List<Asset> assetList}) async* {
    List<File> bufferList = state.imageList;
    for (int i = 0; i < assetList.length; i++) {
      bufferList.insert(0, null);
    }
    yield state.update(assetList: assetList, imageList: bufferList);
  }

  Stream<JournalIssueCreateState> _mapPressCompleteToState() async* {
    yield state.update(
        isComplete: true,
    );
  }

  Stream<JournalIssueCreateState> _mapDeleteImageFileToState(
      {File removedFile}) async* {
    List<File> _img = state.imageList;
    _img.remove(removedFile);

    yield state.update(
      imageList: _img,
    );
  }

  Stream<JournalIssueCreateState> _mapUploadJournalToState(
      {String fid,
      String sfmid,
      String uid,
      String title,
      int category,
      int issueState,
      String contents,
        bool isReadByFM,
        bool isReadByOffice,}) async* {
    String issid = '';
    issid = FirebaseFirestore.instance.collection('Issue').doc().id;
    SubJournalIssue subJournalIssue = SubJournalIssue(
      date: Timestamp.now(),
      fid: fid ?? await FieldUtil.getField().fid,
      fieldCategory: await FieldUtil.getField().fieldCategory,
      sfmid: sfmid ?? '--',
      issid: issid ?? '--',
      uid: uid ?? '--',
      title: title,
      category: category,
      issueState: issueState,
      contents: contents,
      comments: 0,
      isReadByOffice: isReadByOffice ?? false,
      isReadByFM: isReadByFM ?? false,
    );

    await SubJournalRepository()
        .uploadIssue(subJournalIssue: subJournalIssue);

    List<File> imageList = state.imageList;
    String pid = '';

    if (imageList.isNotEmpty) {
      await Future.forEach(imageList, (File file) async {
        pid = FirebaseFirestore.instance.collection('Picture').doc().id;
        ImagePicture _picture = ImagePicture(
          fid: subJournalIssue.fid,
          jid: '--',
          uid: UserUtil.getUser().uid,
          issid: subJournalIssue.issid,
          pid: pid,
          url: (await ImageRepository().uploadImageFile(file, pid)),
          dttm: Timestamp.now(),
        );

        await ImageRepository().uploadImage(
          picture: _picture,
        );
      });
    }

    yield state.update(
      isUploaded: true,
    );
  }
}
