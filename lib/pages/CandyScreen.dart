import 'dart:async';
import 'dart:io';
import 'package:cooing_front/model/response/PurchasableProduct.dart';
import 'package:cooing_front/model/response/User.dart';
import 'package:cooing_front/model/response/storeState.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

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

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  //
  List<ProductDetails> _products = []; // 사용 가능한 상품 목록

  Future<void> _loadProducts() async {
    final _available = await _inAppPurchase.isAvailable();

    if (!_available) {
      storeState = StoreState.notAvailable;
      return;
    }

    const ids = <String>{'candy25', 'candy50', 'candy100', 'goldenCandy'};

    final response = await _inAppPurchase.queryProductDetails(ids);

    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;

    if (response.error != null) {
      print('Failed to fetch product details: ${response.error}');
      return;
    }

    // setState(() {
    //   products =
    //       response.productDetails.map((e) => PurchasableProduct(e)).toList();
    //   print(products[0].id); //candy100
    //   print(products[0].title); //candy100
    //   print(products[0].description); //candy100
    //   print(products[0].price); //w11000
    //   print(products[0].status); //ProductStatus.purchasable
    //   print(products[0].productDetails); //AppStoreProductDetails
    // });
  }

  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Future(() => _loadProducts());
    super.initState();

    // 인앱 결제 초기화
    // 사용 가능한 상품 조회
  }

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
      case 'candy25':
        // 구매를 다 끝내지 않고 창을 종료했을 경우, 다음 구매가 눌러지지 않는 오류 발생
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
        break;
      case 'candy50':
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
        break;
      case 'candy100':
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
        break;
      case 'goldenCandy':

      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
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
