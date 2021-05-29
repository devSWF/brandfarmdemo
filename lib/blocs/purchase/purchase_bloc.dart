import 'package:BrandFarm/blocs/purchase/purchase_event.dart';
import 'package:BrandFarm/blocs/purchase/purchase_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/office/office_model.dart';
import 'package:BrandFarm/models/purchase/purchase_model.dart';
import 'package:BrandFarm/models/send_to_office/send_to_office_model.dart';
import 'package:BrandFarm/models/user/user_model.dart';
import 'package:BrandFarm/repository/purchase/purchase_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc() : super(PurchaseState.empty());

  @override
  Stream<PurchaseState> mapEventToState(PurchaseEvent event) async* {
    if (event is LoadFMPurchase) {
      yield* _mapLoadFMPurchaseToState();
    } else if (event is GetFieldListForFMPurchase) {
      yield* _mapGetFieldListForFMPurchaseToState();
    } else if (event is SetInitialProductList) {
      yield* _mapSetInitialProductListToState();
    } else if (event is UpdateFieldButtonState) {
      yield* _mapUpdateFieldButtonStateToState(event.index);
    } else if (event is UpdateFieldName) {
      yield* _mapUpdateFieldNameToState(event.index, event.field);
    } else if (event is UpdateProductName) {
      yield* _mapUpdateProductNameToState(event.index, event.name);
    } else if (event is UpdateAmount) {
      yield* _mapUpdateAmountToState(event.index, event.amount);
    } else if (event is UpdatePrice) {
      yield* _mapUpdatePriceToState(event.index, event.price);
    } else if (event is UpdateMarketUrl) {
      yield* _mapUpdateMarketUrlToState(event.index, event.url);
    } else if (event is UpdateMemo) {
      yield* _mapUpdateMemoToState(event.index, event.memo);
    } else if (event is SetAdditionalProduct) {
      yield* _mapSetAdditionalProductToState();
    } else if (event is CompletePurchase) {
      yield* _mapCompletePurchaseToState();
    } else if (event is GetPurchaseList) {
      yield* _mapGetPurchaseListToState();
    } else if (event is SetListOrder) {
      yield* _mapSetListOrderToState(event.columnIndex);
    } else if (event is SetSubmissionState) {
      yield* _mapSetSubmissionStateToState();
    } else if (event is UpdateDropdownMenuState) {
      yield* _mapUpdateDropdownMenuStateToState();
    } else if (event is UpdateMenuIndex) {
      yield* _mapUpdateMenuIndexToState(event.menuIndex);
    } else if (event is GetPurchaseListBySearch) {
      yield* _mapGetPurchaseListBySearchToState(event.word);
    } else if (event is SetProduct) {
      yield* _mapSetProductToState(event.product);
    } else if (event is MarkAsRead) {
      yield* _mapMarkAsReadToState();
    }
  }

  Stream<PurchaseState> _mapLoadFMPurchaseToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<PurchaseState> _mapGetFieldListForFMPurchaseToState() async* {
    Farm farm = await PurchaseRepository().getFarmInfo();
    List<Field> currFieldList = [
      Field(
          fieldCategory: farm.fieldCategory,
          fid: '',
          sfmid: '',
          lat: '',
          lng: '',
          city: '',
          province: '',
          name: '모든 필드')
    ];
    List<Field> newFieldList =
        await PurchaseRepository().getFieldList(farm.fieldCategory);
    List<Field> totalFieldList = [
      ...currFieldList,
      ...newFieldList,
    ];

    yield state.update(
      farm: farm,
      fieldList: totalFieldList,
      field: totalFieldList[0],
    );
  }

  Stream<PurchaseState> _mapSetInitialProductListToState() async* {
    // set initial product list
    Timestamp now = Timestamp.now();
    List<Purchase> pList = [];
    Purchase product = Purchase(
      purchaseID: '',
      farmID: state.farm.farmID,
      requester: await UserUtil.getUser().name,
      receiver: '', // field worker name
      requestDate: now,
      receiveDate: null,
      productName: '',
      amount: '',
      price: '',
      marketUrl: '',
      fid: null,
      memo: '',
      officeReply: '',
      waitingState: 1, // 미처리: 1 ; 승인: 2 ; 대기: 3 ; 완료: 4
      isFieldSelectionButtonClicked: false,
      isThereUpdates: true,
      reqUser: await UserUtil.getUser(),
      recUser: null,
    );
    pList.insert(0, product);
    yield state.update(
      productList: pList,
      curr: now,
      isLoading: false,
    );
  }

  Stream<PurchaseState> _mapUpdateFieldButtonStateToState(int index) async* {
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: obj.amount,
      price: obj.price,
      marketUrl: obj.marketUrl,
      fid: obj.fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: !obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapUpdateFieldNameToState(
      int index, int field) async* {
    User recUser = await PurchaseRepository()
        .getDetailUserInfo(state.fieldList[field].sfmid);
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: obj.amount,
      price: obj.price,
      marketUrl: obj.marketUrl,
      fid: state.fieldList[field].fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: !obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapUpdateProductNameToState(
      int index, String name) async* {
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: name,
      amount: obj.amount,
      price: obj.price,
      marketUrl: obj.marketUrl,
      fid: obj.fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapUpdateAmountToState(
      int index, String amount) async* {
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: amount,
      price: obj.price,
      marketUrl: obj.marketUrl,
      fid: obj.fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapUpdatePriceToState(int index, String price) async* {
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: obj.amount,
      price: price,
      marketUrl: obj.marketUrl,
      fid: obj.fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapUpdateMarketUrlToState(
      int index, String url) async* {
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: obj.amount,
      price: obj.price,
      marketUrl: url,
      fid: obj.fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapUpdateMemoToState(int index, String memo) async* {
    Purchase obj = state.productList[index];
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: obj.amount,
      price: obj.price,
      marketUrl: obj.marketUrl,
      fid: obj.fid,
      memo: memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: obj.isFieldSelectionButtonClicked,
      isThereUpdates: obj.isThereUpdates,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    List<Purchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapSetAdditionalProductToState() async* {
    Purchase product = Purchase(
      purchaseID: '',
      farmID: state.farm.farmID,
      requester: await UserUtil.getUser().name,
      receiver: '', // field worker name
      requestDate: state.curr,
      receiveDate: null,
      productName: '',
      amount: '',
      price: '',
      marketUrl: '',
      fid: null,
      memo: '',
      officeReply: '',
      waitingState: 1, // 미처리: 1 ; 승인: 2 ; 대기: 3 ; 완료: 4
      isFieldSelectionButtonClicked: false,
      isThereUpdates: true,
      reqUser: await UserUtil.getUser(),
      recUser: null,
    );

    List<Purchase> plist = state.productList;
    plist.add(product);

    yield state.update(
      productList: plist,
    );
  }

  Stream<PurchaseState> _mapCompletePurchaseToState() async* {
    // upload to firebase
    List<Purchase> plist = state.productList;
    String purchaseID = '';
    await Future.forEach(plist, (item) {
      purchaseID = FirebaseFirestore.instance.collection('Purchase').doc().id;
      Purchase newObj = Purchase(
        purchaseID: purchaseID,
        farmID: item.farmID,
        requester: item.requester,
        receiver: item.receiver,
        requestDate: item.requestDate,
        receiveDate: item.receiveDate,
        productName: item.productName,
        amount: item.amount,
        price: item.price,
        marketUrl: item.marketUrl,
        fid: item.fid,
        memo: item.memo,
        officeReply: item.officeReply,
        waitingState: item.waitingState,
        isFieldSelectionButtonClicked: item.isFieldSelectionButtonClicked,
        isThereUpdates: item.isThereUpdates,
        reqUser: item.reqUser,
        recUser: item.recUser,
      );
      PurchaseRepository().postPurchaseItem(newObj);
    });

    List<Purchase> pList = [];
    Office office = await PurchaseRepository().getOffice();
    User user = await PurchaseRepository().getDetailUserInfo(office.managerID);
    String docID =
        await FirebaseFirestore.instance.collection('SendToOffice').doc().id;
    SendToOffice _sendToOffice = SendToOffice(
        docID: docID,
        uid: await UserUtil.getUser().uid,
        name: await UserUtil.getUser().name,
        officeID: 'Office',
        title: '필드매니저 승인요청',
        content: '새로운 승인요청을 확인하세요',
        postedDate: Timestamp.now(),
        fcmToken: user.fcmToken);
    PurchaseRepository().sendNotification(_sendToOffice);

    yield state.update(
      productList: pList,
      isLoading: false,
      isSubmitted: true,
    );
  }

  Stream<PurchaseState> _mapGetPurchaseListToState() async* {
    // get purchase list from firebase
    List<Purchase> plist = [];
    plist = await PurchaseRepository().getPurchaseList(state.farm.farmID);

    yield state.update(
      productListFromDB: plist,
      productListBySearch: plist,
      isLoading: false,
    );
  }

  Stream<PurchaseState> _mapSetListOrderToState(int columnIndex) async* {
    // set list order
    List<Purchase> plist = state.productListBySearch;
    bool isAscending;
    if (state.isAscending == true) {
      isAscending = false;
      // sort the product list in Ascending, order by Price
      plist.sort(
          (listA, listB) => listB.requestDate.compareTo(listA.requestDate));
    } else {
      isAscending = true;
      // sort the product list in Descending, order by Price
      plist.sort(
          (listA, listB) => listA.requestDate.compareTo(listB.requestDate));
    }

    yield state.update(
      currentSortColumn: columnIndex,
      isAscending: isAscending,
      productListBySearch: plist,
    );
  }

  Stream<PurchaseState> _mapSetSubmissionStateToState() async* {
    yield state.update(
      isSubmitted: false,
    );
  }

  Stream<PurchaseState> _mapUpdateDropdownMenuStateToState() async* {
    yield state.update(
      showDropdownMenu: !state.showDropdownMenu,
    );
  }

  Stream<PurchaseState> _mapUpdateMenuIndexToState(int index) async* {
    yield state.update(
      menuIndex: index,
    );
  }

  Stream<PurchaseState> _mapGetPurchaseListBySearchToState(String word) async* {
    // product list by search
    List<Purchase> plist = [];

    if (state.menu[state.menuIndex].contains('자재명')) {
      plist = state.productListFromDB
          .where((element) => element.productName.contains(word))
          .toList();
    } else if (state.menu[state.menuIndex].contains('신청자')) {
      plist = state.productListFromDB
          .where((element) => element.requester.contains(word))
          .toList();
    } else {
      plist = state.productListFromDB
          .where((element) => element.receiver.contains(word))
          .toList();
    }

    yield state.update(
      productListBySearch: plist,
    );
  }

  Stream<PurchaseState> _mapSetProductToState(Purchase product) async* {
    yield state.update(
      product: product,
    );
  }

  Stream<PurchaseState> _mapMarkAsReadToState() async* {
    Purchase obj = state.product;
    Purchase newObj = Purchase(
      purchaseID: obj.purchaseID,
      farmID: obj.farmID,
      requester: obj.requester,
      receiver: obj.receiver,
      requestDate: obj.requestDate,
      receiveDate: obj.receiveDate,
      productName: obj.productName,
      amount: obj.amount,
      price: obj.price,
      marketUrl: obj.marketUrl,
      fid: obj.fid,
      memo: obj.memo,
      officeReply: obj.officeReply,
      waitingState: obj.waitingState,
      isFieldSelectionButtonClicked: obj.isFieldSelectionButtonClicked,
      isThereUpdates: false,
      reqUser: obj.reqUser,
      recUser: obj.recUser,
    );

    PurchaseRepository().updatePurchaseInfo(obj: newObj);

    int index1 = state.productListFromDB
            .indexWhere((element) => element.purchaseID == newObj.purchaseID) ??
        -1;
    int index2 = state.productListBySearch
            .indexWhere((element) => element.purchaseID == newObj.purchaseID) ??
        -1;
    List<Purchase> fromDB = state.productListFromDB;
    List<Purchase> bySearch = state.productListBySearch;

    if (index1 != -1 && index2 != -1) {
      fromDB.removeAt(index1);
      fromDB.insert(index1, newObj);
      bySearch.removeAt(index2);
      bySearch.insert(index2, newObj);
    }

    yield state.update(
      product: newObj,
      productListFromDB: fromDB,
      productListBySearch: bySearch,
    );
  }
}
