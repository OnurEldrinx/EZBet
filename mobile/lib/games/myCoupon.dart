import 'package:flutter/material.dart';
import 'game.dart';
import 'games.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCouponWidget extends StatefulWidget {
  final String loggedInUsername;
  MyCouponWidget({Key? key, required this.loggedInUsername}) : super(key: key);
  @override
  MyCouponWidgetState createState() => MyCouponWidgetState();
}

class MyCouponWidgetState extends State<MyCouponWidget> {
  List<FootballGameItem> clickedGamesList = [];

  double totalOddUpdated = 1.0;
  int betAmount = 0;
  double winning = 0.0;

  @override
  Widget build(BuildContext context) {
    updateTotalOdd();
    calculateWinning();
    return Scaffold(body: myCoupon(context));
  }

  Widget myCoupon(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            itemCount: FootballGameItemState.clickedGames.length,
            itemBuilder: (context, index) {
              clickedGamesList =
                  FootballGameItemState.clickedGames.values.toList();
              FootballGameItem game = clickedGamesList[index];
              String odd =
                  FootballGameItemState.clickedOddsMap[game.matchID]![0];
              String oddType =
                  FootballGameItemState.clickedOddsMap[game.matchID]![1];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${game.team1} - ${game.team2}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.sports_soccer,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(
                              oddType,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            SizedBox(width: 5),
                            Text(
                              ":",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              odd,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ]),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                              alignment: Alignment.center)
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 0.25, color: Colors.grey),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          child: Container(
            clipBehavior: Clip.none,
            color: Color(0xFFE1E1E1),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        label: Text("Bet"),
                        floatingLabelStyle: TextStyle(color: Colors.green),
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none),
                        hintText: "Enter a number"),
                    onChanged: (bet) {
                      setState(() {
                        betAmount = int.parse(bet);
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Total Odds:"),
                      Text(
                        "${totalOddUpdated.toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Max Return:"),
                      Text("${winning.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 18))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 60,
                          height: 60,
                          child: OutlinedButton(
                              onPressed: () {},
                              child: Icon(Icons.delete_sharp, size: 30),
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  foregroundColor: Colors.red,
                                  backgroundColor: Colors.white,
                                  alignment: Alignment(0, 0)))),
                      SizedBox(width: 10),
                      SizedBox(
                          width: 60,
                          height: 60,
                          child: OutlinedButton(
                              onPressed: () {
                                sendCouponsToBackend(clickedGamesList);
                              },
                              child: Icon(Icons.save, size: 30),
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  alignment: Alignment(0, 0)))),
                    ],
                  )
                ],
              ),
            ),
          ),
          height: 225,
        )
      ],
    );
  }

  Future<Map<String, dynamic>> createPayload(String username,
      List<FootballGameItem> games, int betAmount, double winning) async {
    int lastId = await getLastSavedId();
    int newId = lastId + 1;
    await saveNewId(newId);

    List<Map<String, dynamic>> gamesJson =
        games.map((game) => game.toJson()).toList();
    return {
      'id': newId,
      'username': username,
      'games': gamesJson,
      'betAmount': betAmount,
      'winning': winning
    };
  }

  Future<int> getLastSavedId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('lastCouponId') ?? 0;
  }

  Future<void> saveNewId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastCouponId', id);
  }

  void sendCouponsToBackend(List<FootballGameItem> games) async {
    var payload =
        await createPayload(widget.loggedInUsername, games, betAmount, winning);
    const String scheme = Settings.scheme;
    const String ip = Settings.ip;
    const int port = Settings.port;

    const url = '$scheme://$ip:$port/api/savedCoupons';
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        print("data sent");
      } else {
        print("error");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void updateTotalOdd() {
    setState(() {
      totalOddUpdated = GamesPageWidget().calculateOdds();
    });
  }

  void calculateWinning() {
    setState(() {
      winning = betAmount * totalOddUpdated;
    });
  }
}
