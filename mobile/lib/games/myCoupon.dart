import 'package:flutter/material.dart';
import 'game.dart';
import 'games.dart';

class MyCouponWidget extends StatefulWidget {
  @override
  MyCouponWidgetState createState() => MyCouponWidgetState();
}

class MyCouponWidgetState extends State<MyCouponWidget> {
  double totalOddupdated = 1.0;
  int betAmount = 0;
  double winning = 0.0;

  @override
  Widget build(BuildContext context) {
    updateTotalOdd();
    calculateWinning();
    return Scaffold(
      body: myCoupon(context),
    );
  }

  Widget myCoupon(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: FootballGameItemState.clickedGames.length,
            itemBuilder: (context, index) {
              List<FootballGameItem> clickedGamesList =
                  FootballGameItemState.clickedGames.values.toList();

              FootballGameItem game = clickedGamesList[index];
              print("-------------");
              print(clickedGamesList.toString());
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
                            Text(FootballGameItemState
                                .clickedOddsMap[game.matchID]![0]),
                            Text(FootballGameItemState
                                .clickedOddsMap[game.matchID]![1])
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
    );
  }

  void saveCoupons() {}

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
