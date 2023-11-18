import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/settings.dart';
import 'package:mobile/game.dart';
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

class GamesPage extends StatelessWidget {

  List<Map<String, dynamic>> footballGames = [
    /*{
      'leagueName': 'Premier League',
      'gameTime': '15:00',
      'team1': 'Team A',
      'team2': 'Team B',
      'odds': [
        {'numeric': '2.5', 'type': 'MS 1'},
        {'numeric': '1.8', 'type': 'MS 0'},
        {'numeric': '3.0', 'type': 'MS 2'},
        {'numeric': '2.2', 'type': 'Alt 2.5'},
        {'numeric': '1.7', 'type': 'Üst 2.5'},
      ],
    },*/
    // Add more football game data as needed
  ];

  void testButton(){

    print("click");

  }

  double w = 60;
  double h = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 154, 58, 1),
      appBar: AppBar(
        title: const Text('Games'),
      ),
      body: FutureBuilder<List<Game>>(
        future: fetchGames(),
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

            return ListView.builder(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 5,vertical: 5),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {

                footballGames.add({
                  'leagueName': snapshot.data![index].league,
                  'gameTime': snapshot.data![index].time,
                  'team1': snapshot.data![index].team1,
                  'team2': snapshot.data![index].team2,
                  'odds': [
                    {'numeric': snapshot.data![index].ms1.toString(), 'type': 'MS 1'},
                    {'numeric': snapshot.data![index].ms0.toString(), 'type': 'MS 0'},
                    {'numeric': snapshot.data![index].ms2.toString(), 'type': 'MS 2'},
                    {'numeric': snapshot.data![index].alt25.toString(), 'type': 'Alt 2.5'},
                    {'numeric': snapshot.data![index].ust25.toString(), 'type': 'Üst 2.5'},
                  ],
                });

                return FootballGameItem(
                  leagueName: footballGames[index]['leagueName'],
                  gameTime: footballGames[index]['gameTime'],
                  team1: footballGames[index]['team1'],
                  team2: footballGames[index]['team2'],
                  odds: List<Map<String, String>>.from(footballGames[index]['odds']),


                );

                /*return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 25,horizontal: 5),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      title: Text('${snapshot.data![index].teams}'),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /*ElevatedButton(
                                onPressed: onPressed,
                                child: Text('${snapshot.data![index].ms1}'),

                            ),
                            ElevatedButton(onPressed: onPressed, child: Text('${snapshot.data![index].ms0}')),
                            ElevatedButton(onPressed: onPressed, child: Text('${snapshot.data![index].ms2}')),
                            ElevatedButton(onPressed: onPressed, child: Text('${snapshot.data![index].ust25}')),
                            ElevatedButton(onPressed: onPressed, child: Text('${snapshot.data![index].alt25}'))*/
                          ]

                      ),
                      trailing: null,
                      isThreeLine: false,
                    )

                );*/
                /*return ListTile(
                  title: Text(
                    //'${snapshot.data![index].team1} vs ${snapshot.data![index].team2}',
                    snapshot.data![index].league
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MS1: ${snapshot.data![index].ms1}'),
                      Text('MS0: ${snapshot.data![index].ms0}'),
                      Text('MS2: ${snapshot.data![index].ms2}'),
                      Text('Alt25: ${snapshot.data![index].alt25}'),
                      Text('Ust25: ${snapshot.data![index].ust25}'),
                    ],
                  ),
                );*/
              },
            );
          }
        },
      ),
    );
  }
}
