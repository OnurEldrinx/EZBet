import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  const String scheme = 'http';
  const String ip = '192.168.1.101';
  const int port = 3000;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    '${snapshot.data![index].team1} vs ${snapshot.data![index].team2}',
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
