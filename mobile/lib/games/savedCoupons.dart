import 'package:flutter/material.dart';
import 'myCoupon.dart';

class SavedCoupons extends StatefulWidget {
  @override
  SavedCouponsState createState() => SavedCouponsState();
}

class SavedCouponsState extends State<SavedCoupons> {
  MyCouponWidgetState myCouponWidgetState = MyCouponWidgetState();
  Widget build(BuildContext context) {
    return myCouponWidgetState.myCoupon(context);
  }
}
