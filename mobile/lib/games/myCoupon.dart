import 'package:flutter/material.dart';
import 'game.dart';
import 'games.dart';

class MyCouponWidget extends StatefulWidget {
  @override
  MyCouponWidgetState createState() => MyCouponWidgetState();
}

class MyCouponWidgetState extends State<MyCouponWidget> {
  double totalOddUpdated = 1.0;
  int betAmount = 0;
  double winning = 0.0;

  @override
  Widget build(BuildContext context) {
    updateTotalOdd();
    calculateWinning();
    return Scaffold(
      body: myCoupon(context)
    );
  }

  Widget myCoupon(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            itemCount: FootballGameItemState.clickedGames.length,
            itemBuilder: (context, index) {
              List<FootballGameItem> clickedGamesList =
              FootballGameItemState.clickedGames.values.toList();
              FootballGameItem game = clickedGamesList[index];
              String odd = FootballGameItemState.clickedOddsMap[game.matchID]![0];
              String oddType = FootballGameItemState.clickedOddsMap[game.matchID]![1];
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
                            child: Icon(Icons.sports_soccer,color: Colors.green,),
                          )
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                Text(
                                  oddType,
                                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontFamily:"Arial Black"),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  ":",
                                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  odd,
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ]
                          ),
                          IconButton(onPressed: (){}, icon: Icon(Icons.delete),alignment: Alignment.center)
                        ],
                      ),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      /*trailing: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          ],
                        ),*/

                    ),
                    Divider(
                        height: 1,thickness: 0.25,
                        color: Colors.grey
                    ),
                  ],
                ),
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
      totalOddUpdated = GamesPageWidget().calculateOdds();
    });
  }

  void calculateWinning() {
    setState(() {
      winning = betAmount * totalOddUpdated;
    });
  }
}
