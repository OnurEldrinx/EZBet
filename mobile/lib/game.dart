import 'package:flutter/material.dart';

class FootballGameItem extends StatelessWidget {
  final String leagueName;
  final String gameTime;
  final String team1;
  final String team2;
  final List<Map<String, String>> odds;

  FootballGameItem({
    required this.leagueName,
    required this.gameTime,
    required this.team1,
    required this.team2,
    required this.odds,
  });

  /*@override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$leagueName'),
                Text('$gameTime'),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('$team1 vs $team2', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: odds.map((odd) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 5 - 16,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            Text(odd['numeric'] ?? ''),
                            Text(odd['type'] ?? ''),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {

    bool isClicked=false;

    return Card(
      shadowColor: Colors.transparent,
      color: Color.fromRGBO(0, 154, 58, 1),
      margin: EdgeInsets.symmetric(horizontal: 2,vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$leagueName',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                Text('$gameTime',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('$team1 vs $team2', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: odds.map((odd) {
                        return Container(

                          margin: EdgeInsets.symmetric(horizontal: 4.0), // Adjust horizontal spacing here

                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                isClicked = !isClicked;
                                print('$leagueName - $team1 vs $team2 - $odd');
                                print(isClicked);
                              },
                              style: ElevatedButton.styleFrom(
                                //minimumSize: Size(75, 50),
                                padding: EdgeInsets.all(8),
                                elevation: 2,
                                backgroundColor: !isClicked ? Colors.white:Colors.amber,
                                foregroundColor: !isClicked ? Colors.black:Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(odd['numeric'] ?? ''),
                                  Text(odd['type'] ?? ''),
                                ],
                              ),
                            )

                          ),

                        );
                      }).toList(),
                    ),


                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
