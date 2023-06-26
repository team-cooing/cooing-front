// 2023.06.20 TUE Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/PurchasableProduct.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/response/storeState.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:cooing_front/pages/candy_complete_page.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/cupertino.dart';

class CandyScreen extends StatefulWidget {
  final User user;
  final int number;

  const CandyScreen({required this.user, required this.number, super.key});

  @override
  State<CandyScreen> createState() => _CandyScreenState();
}

class _CandyScreenState extends State<CandyScreen> {
  // 인앱결제를 위한 초기화
  late BuildContext pageContext;

  StoreState storeState = StoreState.loading;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  String? latestPurchasedID;
  String content1 = "캔디가 부족해요!";
  String content2 = '캔디를 충전할까요?';
  UserDataProvider userProvider = UserDataProvider();
  bool isLoading = false;
  int selectedButtonIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    pageContext = context;

    return Scaffold(body: _buildCandyScreen());
  }

  Widget _buildCandyScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close, color: Color.fromRGBO(51, 61, 75, 1)),
          onPressed: () {
            Navigator.of(pageContext).pop();
          },
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
                Text(
                  widget.number == 1 ? content1 : content2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      color: Color.fromARGB(255, 51, 61, 75)),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                Text(
                  "누가 보냈는지 확인해보세요!",
                  style: TextStyle(
                      fontSize: 16.sp, color: Color.fromRGBO(151, 84, 251, 1)),
                ),
                Padding(padding: EdgeInsets.all(15.0)),
                SizedBox(
                  width: double.infinity,
                  height: 100.h,
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
                                      width: 25.w,
                                      height: 25.h,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 25개",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 80.w,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (!isLoading) {
                                    setState(() {
                                      selectedButtonIndex = 0;
                                      isLoading = true;
                                    });
                                    try {
                                      PurchasableProduct productDetails =
                                          products
                                              .where((product) =>
                                                  product.id == 'candy25')
                                              .first;
                                      await buy(productDetails);
                                    } catch (e) {
                                      print('알 수 없는 에러 - E: $e');
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(151, 84, 251, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: isLoading && selectedButtonIndex == 0
                                    ? SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "3,000원",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                          )
                        ]),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: double.infinity,
                  height: 100.h,
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
                                      width: 25.w,
                                      height: 25.h,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 50개",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 80.w,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (!isLoading) {
                                    setState(() {
                                      selectedButtonIndex = 1;
                                      isLoading = true;
                                    });
                                    try {
                                      PurchasableProduct productDetails =
                                          products
                                              .where((product) =>
                                                  product.id == 'candy50')
                                              .first;
                                      await buy(productDetails);
                                    } catch (e) {
                                      print('알 수 없는 에러 - E: $e');
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(151, 84, 251, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: isLoading && selectedButtonIndex == 1
                                    ? SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "6,000원",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                          )
                        ]),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: double.infinity,
                  height: 100.h,
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
                                      width: 25.w,
                                      height: 25.h,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 100개",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 80.w,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (!isLoading) {
                                    setState(() {
                                      selectedButtonIndex = 2;
                                      isLoading = true;
                                    });
                                    try {
                                      PurchasableProduct productDetails =
                                          products
                                              .where((product) =>
                                                  product.id == 'candy100')
                                              .first;
                                      await buy(productDetails);
                                    } catch (e) {
                                      print('알 수 없는 에러 - E: $e');
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(151, 84, 251, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: isLoading && selectedButtonIndex == 2
                                    ? SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "12,000원",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                          )
                        ]),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
              ])),
        ),
      ),
    );
  }

  Future<void> _loadProducts() async {
    const ids = <String>{'candy25', 'candy50', 'candy100', 'goldenCandy'};

    final response = await _inAppPurchase.queryProductDetails(ids);

    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      return;
    }

    setState(() {
      products = response.productDetails
          .map<PurchasableProduct>(
              (dynamic e) => PurchasableProduct(e as ProductDetails))
          .toList();
      storeState = StoreState.available;
    });

    if (response.error != null) {
      print('Failed to fetch product details: ${response.error}');
      return;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
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
          if (!mounted) return;
          Navigator.of(pageContext).push(
            MaterialPageRoute(
                builder: (BuildContext context) => CandyCompleteScreen()),
          );
        } else if (purchase.productID == 'candy50') {
          updateCandy(purchase.productID, 50);
          if (!mounted) return;
          Navigator.of(pageContext).push(
            MaterialPageRoute(
                builder: (BuildContext context) => CandyCompleteScreen()),
          );
        } else if (purchase.productID == 'candy100') {
          updateCandy(purchase.productID, 100);
          if (!mounted) return;
          Navigator.of(pageContext).push(
            MaterialPageRoute(
                builder: (BuildContext context) => CandyCompleteScreen()),
          );
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
    widget.user.candyCount += number;

    await Response.updateUser(newUser: widget.user);
    userProvider.saveCookie();

    final uid = widget.user.uid;
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
