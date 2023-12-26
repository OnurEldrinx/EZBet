import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/settings.dart';
import 'package:mobile/games/game.dart';
import 'myCoupon.dart';
import 'savedCoupons.dart';

class Game {
  final int matchId;
  final String date;
  final String time;
  final String leagueCode;
  final String league;
  final String teams;
  final String team1;
  final String team2;
  final int mbs;
  final int liveStatus;
  final int betCount;
  final double ms1;
  final double ms0;
  final double ms2;
  final double alt25;
  final double ust25;

  Game({
    required this.matchId,
    required this.date,
    required this.time,
    required this.leagueCode,
    required this.league,
    required this.teams,
    required this.team1,
    required this.team2,
    required this.mbs,
    required this.liveStatus,
    required this.betCount,
    required this.ms1,
    required this.ms0,
    required this.ms2,
    required this.alt25,
    required this.ust25,
  });
}

Future<List<Game>> fetchGames() async {
  const String scheme = Settings.scheme;
  const String ip = Settings.ip;
  const int port = Settings.port;

  const url = '$scheme://$ip:$port/api/games';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    List<Game> games = [];

    for (var item in jsonData) {
      games.add(Game(
        matchId: item['MatchID'],
        date: item['Tarih'],
        time: item['Saat'],
        leagueCode: item['LigKod'],
        league: item['Lig'],
        teams: item['takimlar'],
        team1: item['takim1'],
        team2: item['takim2'],
        mbs: item['mbs'],
        liveStatus: item['CanliDurumu'],
        betCount: item['BahisSayisi'],
        ms1: item['ms1'] != null ? double.parse(item['ms1'].toString()) : 0.0,
        ms0: item['ms0'] != null ? double.parse(item['ms0'].toString()) : 0.0,
        ms2: item['ms2'] != null ? double.parse(item['ms2'].toString()) : 0.0,
        alt25: double.parse(item['alt25'].toString()),
        ust25: double.parse(item['ust25'].toString()),
      ));
    }

    return games;
  } else {
    throw Exception('Failed to load games');
  }
}

class GamesPage extends StatefulWidget {
  final String loggedInUsername;
  GamesPage({Key? key, required this.loggedInUsername}) : super(key: key);

  @override
  GamesPageWidget createState() => GamesPageWidget();
}

class GamesPageWidget extends State<GamesPage> {
  static late List<Map<String, dynamic>> footballGames;
  bool isCouponVisible = false;
  static late var gamesStackWidget;
  static late var myCouponWidget;
  static late var savedCouponsWidget;
  var fetchgames = fetchGames();

  static double totalOdd = 0;

  @override
  void initState() {
    super.initState();
    footballGames = [];
    gamesStackWidget = gamesStack(context);
    myCouponWidget = MyCouponWidget(
      loggedInUsername: widget.loggedInUsername,
    );
    savedCouponsWidget =
        SavedCoupons(loggedInUsername: widget.loggedInUsername);
  }

  Widget gamesStack(BuildContext context) {
    return Stack(children: [
      FutureBuilder<List<Game>>(
        future: fetchgames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      footballGames.add({
                        'matchId': snapshot.data![index].matchId,
                        'leagueName': snapshot.data![index].league,
                        'gameTime': snapshot.data![index].time,
                        'team1': snapshot.data![index].team1,
                        'team2': snapshot.data![index].team2,
                        'odds': <Map<String, Object>>[
                          {
                            'numeric': snapshot.data![index].ms1.toString(),
                            'type': 'MS 1',
                            'isClicked': false
                          },
                          {
                            'numeric': snapshot.data![index].ms0.toString(),
                            'type': 'MS 0',
                            'isClicked': false
                          },
                          {
                            'numeric': snapshot.data![index].ms2.toString(),
                            'type': 'MS 2',
                            'isClicked': false
                          },
                          {
                            'numeric': snapshot.data![index].alt25.toString(),
                            'type': 'Alt 2.5',
                            'isClicked': false
                          },
                          {
                            'numeric': snapshot.data![index].ust25.toString(),
                            'type': 'Üst 2.5',
                            'isClicked': false
                          },
                        ],
                      });

                      return FootballGameItem(
                        matchID: footballGames[index]['matchId'],
                        leagueName: footballGames[index]['leagueName'],
                        gameTime: footballGames[index]['gameTime'],
                        team1: footballGames[index]['team1'],
                        team2: footballGames[index]['team2'],
                        odds: List<Map<String, Object>>.from(
                          footballGames[index]['odds'],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    ]);
  }

  /*Widget savedCoupons(BuildContext context) {return Placeholder(child: Center(child: Text("Saved Coupons")));}*/

  double calculateOdds() {
    Map<int, List<String>> clickedOddsMap =
        FootballGameItemState.clickedOddsMap;

    double result = 1.0;

    clickedOddsMap.forEach((key, values) {
      values.forEach((value) {
        result *= double.tryParse(value) ?? 1.0;
      });
    });
    totalOdd = result;
    print(' Result: $totalOdd');
    return totalOdd;
  }

  //Bottom Nav Bar Implementation Start
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    myCouponWidget,
    gamesStackWidget,
    savedCouponsWidget,
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Bottom Nav Bar Implementation End
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.amber,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          iconSize: 40,
          backgroundColor: Color(0xFF191233),
          items: [
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.checklist),
                icon: Icon(Icons.checklist_outlined, color: Colors.white),
                label: "My Coupon"),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.calendar_today),
                icon: Icon(Icons.calendar_today_outlined, color: Colors.white),
                label: "Games"),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.bookmark),
                icon: Icon(Icons.bookmark_border, color: Colors.white),
                label: "Saved Coupons")
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        backgroundColor: Color.fromRGBO(0, 154, 58, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF191233),
          elevation: 2,
          title: const Text('EZBet'),
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }
}
