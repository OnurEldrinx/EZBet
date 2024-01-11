import 'package:flutter/material.dart';
import 'myCoupon.dart';
import 'package:mobile/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavedCoupons extends StatefulWidget {
  final String loggedInUsername;

  SavedCoupons({Key? key, required this.loggedInUsername}) : super(key: key);

  @override
  SavedCouponsState createState() => SavedCouponsState();
}

class SavedCouponsState extends State<SavedCoupons> {
  List<dynamic> savedCoupons = [];
  @override
  void initState() {
    super.initState();
    fetchSavedCoupons();
  }

  MyCouponWidgetState myCouponWidgetState = MyCouponWidgetState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Saved Coupons'),
        backgroundColor: Color.fromRGBO(0, 154, 58, 1),
      ),
      body: ListView.builder(
        itemCount: savedCoupons.length,
        itemBuilder: (context, index) {
          var coupon = savedCoupons[index];
          return InkWell(
            onTap: () {
              _showCouponDetails(context, coupon, myCouponWidgetState.betAmount,
                  myCouponWidgetState.winning);
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coupon ${index + 1}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        deleteCoupon(coupon['id']);
                      },
                      child: Icon(Icons.delete_sharp, size: 30),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteCoupon(int couponId) async {
    const String scheme = Settings.scheme;
    const String ip = Settings.ip;
    const int port = Settings.port;
    final url = '$scheme://$ip:$port/api/savedCoupons/$couponId';

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          savedCoupons.removeWhere((coupon) => coupon['id'] == couponId);
        });
      } else {
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget buildGameList(List<dynamic> games) {
    List<Widget> gameWidgets = [];
    for (var game in games) {
      List<Widget> individualGameWidgets = [];

      individualGameWidgets.add(Text('${game['team1']} vs ${game['team2']}'));

      for (var odd in game['odds']) {
        if (odd['isClicked']) {
          individualGameWidgets
              .add(Text('Odd Type: ${odd['type']} - ${odd['numeric']}'));
        }
      }

      gameWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: individualGameWidgets,
          ),
        ),
      );
    }
    return Column(children: gameWidgets);
  }

  void _showCouponDetails(
      BuildContext context, var coupon, int betAmount, double winning) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Coupon Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Username: ${coupon['username']}'),
              SizedBox(height: 10),
              Text('Games:'),
              buildGameList(coupon['games']),
              SizedBox(height: 10),
              Text('Bet Amount: ${coupon['betAmount']}'),
              SizedBox(height: 10),
              Text('Winning: ${coupon['winning']}'),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchSavedCoupons() async {
    const String scheme = Settings.scheme;
    const String ip = Settings.ip;
    const int port = Settings.port;
    final String loggedInUsername = widget.loggedInUsername;
    final url = '$scheme://$ip:$port/api/savedCoupons/$loggedInUsername';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          savedCoupons = json.decode(response.body);
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (error) {
      print(' error: $error');
    }
  }
}
