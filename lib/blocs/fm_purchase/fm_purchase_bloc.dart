
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_event.dart';
import 'package:BrandFarm/blocs/fm_purchase/fm_purchase_state.dart';
import 'package:BrandFarm/models/farm/farm_model.dart';
import 'package:BrandFarm/models/field_model.dart';
import 'package:BrandFarm/models/fm_purchase/fm_purchase_model.dart';
import 'package:BrandFarm/repository/fm_purchase/fm_purchase_repository.dart';
import 'package:BrandFarm/utils/user/user_util.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FMPurchaseBloc
    extends Bloc<FMPurchaseEvent, FMPurchaseState> {
  FMPurchaseBloc() : super(FMPurchaseState.empty());

  @override
  Stream<FMPurchaseState> mapEventToState(
      FMPurchaseEvent event) async* {
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

  Stream<FMPurchaseState> _mapLoadFMPurchaseToState() async* {
    yield state.update(isLoading: true);
  }

  Stream<FMPurchaseState> _mapGetFieldListForFMPurchaseToState() async* {
    Farm farm = await FMPurchaseRepository().getFarmInfo();
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
    await FMPurchaseRepository().getFieldList(farm.fieldCategory);
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

  Stream<FMPurchaseState> _mapSetInitialProductListToState() async* {
    // set initial product list
    Timestamp now = Timestamp.now();
    List<FMPurchase> pList = [];
    FMPurchase product = FMPurchase(
      purchaseID: '',
      farmID: state.farm.farmID,
      requester: UserUtil.getUser().name,
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
    );
    pList.insert(0, product);
    yield state.update(
      productList: pList,
      curr: now,
      isLoading: false,
    );
  }

  Stream<FMPurchaseState> _mapUpdateFieldButtonStateToState(int index) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapUpdateFieldNameToState(int index, int field) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapUpdateProductNameToState(int index, String name) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapUpdateAmountToState(int index, String amount) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapUpdatePriceToState(int index, String price) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapUpdateMarketUrlToState(int index, String url) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapUpdateMemoToState(int index, String memo) async* {
    FMPurchase obj = state.productList[index];
    FMPurchase newObj = FMPurchase(
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
        isThereUpdates: obj.isThereUpdates
    );

    List<FMPurchase> plist = state.productList;
    plist.removeAt(index);
    plist.insert(index, newObj);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapSetAdditionalProductToState() async* {
    FMPurchase product = FMPurchase(
      purchaseID: '',
      farmID: state.farm.farmID,
      requester: UserUtil.getUser().name,
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
    );

    List<FMPurchase> plist = state.productList;
    plist.add(product);

    yield state.update(
        productList: plist,
    );
  }

  Stream<FMPurchaseState> _mapCompletePurchaseToState() async* {
    // upload to firebase
    List<FMPurchase> plist = state.productList;
    String purchaseID = '';
    await Future.forEach(plist, (item) {
      purchaseID = FirebaseFirestore.instance.collection('Purchase').doc().id;
      FMPurchase newObj = FMPurchase(
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
          isThereUpdates: item.isThereUpdates
      );
      FMPurchaseRepository().postPurchaseItem(newObj);
    });

    List<FMPurchase> pList = [];
    // FMPurchase product = FMPurchase(
    //   purchaseID: '',
    //   farmID: state.farm.farmID,
    //   requester: UserUtil.getUser().name,
    //   receiver: '', // field worker name
    //   requestDate: state.curr,
    //   receiveDate: null,
    //   productName: '',
    //   amount: '',
    //   price: '',
    //   marketUrl: '',
    //   fid: null,
    //   memo: '',
    //   officeReply: '',
    //   waitingState: 1, // 미처리: 1 ; 승인: 2 ; 대기: 3 ; 완료: 4
    //   isFieldSelectionButtonClicked: false,
    //   isThereUpdates: true,
    // );
    // pList.insert(0, product);

    yield state.update(
      productList: pList,
      isLoading: false,
      isSubmitted: true,
    );
  }

  Stream<FMPurchaseState> _mapGetPurchaseListToState() async* {
    // get purchase list from firebase
    List<FMPurchase> plist = [];
    plist = await FMPurchaseRepository().getPurchaseList(state.farm.farmID);

    yield state.update(
      productListFromDB: plist,
      productListBySearch: plist,
      isLoading: false,
    );
  }

  Stream<FMPurchaseState> _mapSetListOrderToState(int columnIndex) async* {
    // set list order
    List<FMPurchase> plist = state.productListBySearch;
    bool isAscending;
    if (state.isAscending == true) {
      isAscending = false;
      // sort the product list in Ascending, order by Price
      plist.sort((listA, listB) =>
          listB.requestDate.compareTo(
              listA.requestDate));
    } else {
      isAscending = true;
      // sort the product list in Descending, order by Price
      plist.sort((listA, listB) =>
          listA.requestDate.compareTo(
              listB.requestDate));
    }

    yield state.update(
      currentSortColumn: columnIndex,
      isAscending: isAscending,
      productListBySearch: plist,
    );
  }

  Stream<FMPurchaseState> _mapSetSubmissionStateToState() async* {
    yield state.update(
      isSubmitted: false,
    );
  }

  Stream<FMPurchaseState> _mapUpdateDropdownMenuStateToState() async* {
    yield state.update(
      showDropdownMenu: !state.showDropdownMenu,
    );
  }

  Stream<FMPurchaseState> _mapUpdateMenuIndexToState(int index) async* {
    yield state.update(
      menuIndex: index,
    );
  }

  Stream<FMPurchaseState> _mapGetPurchaseListBySearchToState(String word) async* {
    // product list by search
    List<FMPurchase> plist = [];

    if(state.menu[state.menuIndex].contains('자재명')) {
      plist = state.productListFromDB.where((element) => element.productName.contains(word)).toList();
    } else if(state.menu[state.menuIndex].contains('신청자')) {
      plist = state.productListFromDB.where((element) => element.requester.contains(word)).toList();
    } else {
      plist = state.productListFromDB.where((element) => element.receiver.contains(word)).toList();
    }

    yield state.update(
      productListBySearch: plist,
    );
  }

  Stream<FMPurchaseState> _mapSetProductToState(FMPurchase product) async* {
    yield state.update(
      product: product,
    );
  }

  Stream<FMPurchaseState> _mapMarkAsReadToState() async* {
    FMPurchase obj = state.product;
    FMPurchase newObj = FMPurchase(
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
    );

    FMPurchaseRepository().updatePurchaseInfo(obj: newObj);

    int index1 = state.productListFromDB.indexWhere((element) => element.purchaseID == newObj.purchaseID) ?? -1;
    int index2 = state.productListBySearch.indexWhere((element) => element.purchaseID == newObj.purchaseID) ?? -1;
    List<FMPurchase> fromDB = state.productListFromDB;
    List<FMPurchase> bySearch = state.productListBySearch;

    if(index1 != -1 && index2 != -1) {
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
