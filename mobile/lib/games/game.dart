import 'package:flutter/material.dart';

class FootballGameItem extends StatefulWidget {
  final int matchID;
  final String leagueName;
  final String gameTime;
  final String team1;
  final String team2;
  final List<Map<String, dynamic>> odds;

  FootballGameItem({
    required this.matchID,
    required this.leagueName,
    required this.gameTime,
    required this.team1,
    required this.team2,
    required this.odds,
  });

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "$matchID - $leagueName - $gameTime - $team1 vs $team2";
  }

  @override
  FootballGameItemState createState() => FootballGameItemState();
}

class FootballGameItemState extends State<FootballGameItem> {
  static Map<String, int?> lastClickedOddIndexMap = {};
  static Map<int, List<String>> clickedOddsMap = {};
  static List<FootballGameItem> clickedGames = [];

  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Color.fromRGBO(0, 154, 58, 1),
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.leagueName}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text('${widget.gameTime}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
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
                  Text('${widget.team1} vs ${widget.team2}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.odds.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> odd = entry.value;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  int matchId = widget.matchID;

                                  // checks if odd selected before for matchid
                                  if (!clickedOddsMap.containsKey(matchId)) {
                                    clickedOddsMap[matchId] = [];
                                  }

                                  int? lastClickedIndex =
                                      lastClickedOddIndexMap[
                                          matchId.toString()];

                                  if (lastClickedIndex != null &&
                                      lastClickedIndex != index) {
                                    widget.odds[lastClickedIndex]['isClicked'] =
                                        false;

                                    // aynı matchid için eski seçilen odd'u kaldırıyor
                                    clickedOddsMap[matchId]?.remove(widget
                                        .odds[lastClickedIndex]['numeric']);
                                  }

                                  bool isClicked = !(odd['isClicked'] ?? false);
                                  odd['isClicked'] = isClicked;

                                  lastClickedOddIndexMap[matchId.toString()] =
                                      isClicked ? index : null;

                                  if (isClicked) {
                                    clickedOddsMap[matchId]
                                        ?.add(widget.odds[index]['numeric']);
                                    clickedGames.add(widget);
                                  } else {
                                    clickedOddsMap[matchId]
                                        ?.remove(widget.odds[index]['numeric']);
                                    clickedGames.remove(widget);
                                  }

                                  /*   print(
                                      'Updated Clicked Odds Map: $clickedOddsMap'); */
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(8),
                                elevation: 2,
                                backgroundColor: odd['isClicked'] ?? false
                                    ? Colors.amber
                                    : Colors.white,
                                foregroundColor: odd['isClicked'] ?? false
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      widget.odds[index]['numeric'].toString()),
                                  Text(widget.odds[index]['type'] ?? ''),
                                ],
                              ),
                            ),
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
