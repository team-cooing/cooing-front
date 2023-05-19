import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/PurchasableProduct.dart';
import 'package:cooing_front/model/response/User.dart';
import 'package:cooing_front/model/response/storeState.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CandyScreen extends StatefulWidget {
  const CandyScreen({Key? key}) : super(key: key);
  @override
  State<CandyScreen> createState() => _CandyScreenState();
}

class _CandyScreenState extends State<CandyScreen> {
  // 인앱결제를 위한 초기화
  StoreState storeState = StoreState.loading;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];
  late final response;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  String? latestPurchasedID;

  @override
  void initState() {
    super.initState();
    _subscription = _inAppPurchase.purchaseStream
        .listen((List<PurchaseDetails> purchaseDetailsList) {
      for (PurchaseDetails purchase in purchaseDetailsList) {
        _handlePurchase(purchase);
      }
    });
    if (storeState == StoreState.loading) {
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    final _available = await _inAppPurchase.isAvailable();
    print(_available);
    if (!_available) {
      storeState = StoreState.notAvailable;
      return;
    }

    const ids = <String>{'candy25', 'candy50', 'candy100', 'goldenCandy'};

    response = await _inAppPurchase.queryProductDetails(ids);
    setState(() {
      products = response.productDetails
          .map<PurchasableProduct>(
              (dynamic e) => PurchasableProduct(e as ProductDetails))
          .toList();
      print(products[0].id);
      storeState = StoreState.available;
    });

    if (response.error != null) {
      print('Failed to fetch product details: ${response.error}');
      return;
    }
  }

  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    print(purchase.productID);
    print(purchase.status);
    print(purchase.pendingCompletePurchase);
    print('---------');
    if (purchase.status == PurchaseStatus.pending) {
      // 구매가 진행 중
    } else if (purchase.status == PurchaseStatus.error) {
      // 구매 중 오류가 발생
    } else if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
        // 구매를 완료
      }

      if (purchase.pendingCompletePurchase &&
          purchase.purchaseID != latestPurchasedID) {
        // 최신 구매 ID 업데이트
        latestPurchasedID = purchase.purchaseID;

        if (purchase.productID == 'candy25') {
          // 캔디 25 구매 완료 이벤트 처리
          updateCandy(purchase.productID, 25);
          FlutterDialog();
        } else if (purchase.productID == 'candy50') {
          updateCandy(purchase.productID, 50);
          FlutterDialog();
        } else if (purchase.productID == 'candy100') {
          updateCandy(purchase.productID, 100);
          FlutterDialog();
        }
      }
    } else if (purchase.status == PurchaseStatus.canceled) {
      // 구매 취소된 경우에도 거래를 완료해야 함.
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
  }

// 캔디 25, 50, 100개는 예전에 샀던 안샀던 계속 구매 가능.
// 구독은 사고 나면 구매가 불가능

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
      case 'candy25':
      case 'candy50':
      case 'candy100':
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
        break;
      case 'goldenCandy':

        // 구독하지 않은 경우
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

        break;

      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
  }

  Future<void> updateCandy(String productId, int number) async {
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);
    userProvider.updateCandyCount(number);
    if (userProvider.userData != null) {
      final uid = userProvider.userData!.uid;
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.update({'candyCount': userProvider.userData?.candyCount});

      final purchaseRef = FirebaseFirestore.instance
          .collection("purchaseHistory")
          .doc(uid)
          .collection('history');

      final timestamp = DateTime.now();

      await purchaseRef.doc(timestamp.toString()).set({
        'type': productId,
      });
    }
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('승인 완료'),
            content: Text('정상적으로 구매가 완료되었습니다.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    //action code for "Yes" button
                  },
                  child: Text('확인')),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close, color: Color.fromRGBO(51, 61, 75, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFffffff),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    child: Text(
                  "캔디가 부족해요!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color.fromARGB(255, 51, 61, 75)),
                )),
                Padding(padding: EdgeInsets.all(2.0)),
                Text(
                  "누가 보냈는지 확인해보세요!",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(151, 84, 251, 1)),
                ),
                Padding(padding: EdgeInsets.all(15.0)),
                SizedBox(
                  width: double.infinity,
                  height: 90.0,
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: Image(
                                          image:
                                              AssetImage('images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 25개",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                PurchasableProduct productDetails = products
                                    .where((product) => product.id == 'candy25')
                                    .first;
                                buy(productDetails);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromRGBO(151, 84, 251, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: const Text(
                                "3,000원",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                        ]),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: double.infinity,
                  height: 90.0,
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: Image(
                                          image:
                                              AssetImage('images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 50개",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                PurchasableProduct productDetails = products
                                    .where((product) => product.id == 'candy50')
                                    .first;
                                buy(productDetails);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromRGBO(151, 84, 251, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: const Text(
                                "6,000원",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                        ]),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: double.infinity,
                  height: 90.0,
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: Image(
                                          image:
                                              AssetImage('images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 100개",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                PurchasableProduct productDetails = products
                                    .where(
                                        (product) => product.id == 'candy100')
                                    .first;
                                buy(productDetails);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromRGBO(151, 84, 251, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: const Text(
                                "12,000원",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                        ]),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: double.infinity,
                  height: 90.0,
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: Image(
                                          image:
                                              AssetImage('images/candy2.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "황금캔디 구독(월)",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff333D4B),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "모든 힌트를 볼 수 있습니다.",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff333D4B),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                PurchasableProduct productDetails = products
                                    .where((product) =>
                                        product.id == 'goldenCandy')
                                    .first;
                                buy(productDetails);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromRGBO(151, 84, 251, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: const Text(
                                "12,000원",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                        ]),
                  ),
                )
              ])),
        ),
      ),
    );
  }
}
