import 'package:flutter/material.dart';
import 'game.dart';
import 'games.dart';

class MyCouponWidget extends StatefulWidget {
  @override
  _MyCouponWidgetState createState() => _MyCouponWidgetState();
}

class _MyCouponWidgetState extends State<MyCouponWidget> {
  double totalOddupdated = 1.0;
  int betAmount = 0;
  double winning = 0.0;

  @override
  Widget build(BuildContext context) {
    updateTotalOdd();
    calculateWinning();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 154, 58, 1),
        flexibleSpace: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'My Coupon',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Winning :$winning',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Total Odd: $totalOddupdated",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      betAmount = int.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Bet Amount',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: FootballGameItemState.clickedGames.length,
              itemBuilder: (context, index) {
                List<FootballGameItem> clickedGamesList =
                    FootballGameItemState.clickedGames.values.toList();
                FootballGameItem game = clickedGamesList[index];
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${game.team1} - ${game.team2}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${game.leagueName} - ${game.gameTime}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 50,
                        color: Colors.amber.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "üst",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "1.74",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateTotalOdd() {
    setState(() {
      totalOddupdated = GamesPageWidget().calculateOdds();
    });
  }

  void calculateWinning() {
    setState(() {
      winning = betAmount * totalOddupdated;
    });
  }
}
