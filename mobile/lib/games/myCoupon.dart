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
              List<FootballGameItem> clickedGamesList =
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
                                  fontFamily: "Arial Black"),
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
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                              alignment: Alignment.center)
                        ],
                      ),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      /*trailing: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          ],
                        ),*/
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
                  SizedBox(height: 15),
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
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text("Maximum Return:"),
                      Text("${winning.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                              fontSize: 18))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 60,height: 60,child: OutlinedButton(onPressed: (){}, child: Icon(Icons.delete_sharp,size: 30),style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),foregroundColor: Colors.red,backgroundColor: Colors.white,alignment:Alignment(0, 0)))),
                      SizedBox(width: 10),
                      SizedBox(width: 60,height: 60,child: OutlinedButton(onPressed: (){}, child: Icon(Icons.save,size: 30),style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),foregroundColor: Colors.black,backgroundColor: Colors.white,alignment:Alignment(0, 0)))),
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
