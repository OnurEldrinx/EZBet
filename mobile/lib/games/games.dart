import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/settings.dart';
import 'package:mobile/games/game.dart';
import 'myCoupon.dart';
import 'savedCoupons.dart';
import 'dart:math';

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

Map<String, bool> selectedLeagues = {};

List<String> uniqueLeagueNames = [];
double parseOdd(dynamic value) {
  if (value == null) {
    return 0.0;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

Future<List<Game>> fetchGames(Map<String, bool> selectedLeagues) async {
  const String scheme = Settings.scheme;
  const String ip = Settings.ip;
  const int port = Settings.port;

  const url = '$scheme://$ip:$port/api/games';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    List<Game> games = [];

    Set<String> leagueNames = Set();

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
        ms1: parseOdd(item['ms1']),
        ms0: parseOdd(item['ms0']),
        ms2: parseOdd(item['ms2']),
        alt25: parseOdd(item['alt25']),
        ust25: parseOdd(item['ust25']),
      ));
      leagueNames.add(item['Lig']);

      uniqueLeagueNames = leagueNames.toList();
    }

    return games.where((game) => selectedLeagues[game.league] ?? true).toList();
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
  late var gamesStackWidget;
  late var myCouponWidget;
  late var savedCouponsWidget;
  Future<List<Game>>? FetchGames;
  static double totalOdd = 0;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  final TextEditingController _totalOddController = TextEditingController();
  final TextEditingController _numberOfGamesController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    FetchGames = fetchGames(selectedLeagues).then((games) {
      if (selectedLeagues.isEmpty) {
        for (String league in uniqueLeagueNames) {
          selectedLeagues[league] = true;
        }
      }
      return games;
    });

    footballGames = [];
    gamesStackWidget = gamesStack(context);
    myCouponWidget = MyCouponWidget(loggedInUsername: widget.loggedInUsername);
    savedCouponsWidget =
        SavedCoupons(loggedInUsername: widget.loggedInUsername);

    _widgetOptions = <Widget>[
      myCouponWidget,
      gamesStackWidget,
      savedCouponsWidget,
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget gamesStack(BuildContext context) {
    return Stack(children: [
      FutureBuilder<List<Game>>(
        future: FetchGames,
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
/*   int _selectedIndex = 0;
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
*/
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
          backgroundColor: Color(0xFF191233),
          elevation: 2,
          title: const Text('EZBet'),
          actions: <Widget>[
            SizedBox(width: 150),
            IconButton(
              icon: Icon(Icons.shuffle),
              onPressed: () {
                showShuffleDialog();
              },
            ),
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }

  List<String> oddTypes = <String>['Over 2.5', 'Under 2.5', 'Result',"Any"];
  List<String> moreLess = <String>['More Than', 'Less Than',"Equal"];


  void showShuffleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Random Coupon Generator'),
          content: SingleChildScrollView(scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Odd Type"),
                    SizedBox(width: 15),
                    FilterDropdownMenu(filterList: oddTypes,selectedValue: selectedOddTypeFilter)
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Odd"),
                      SizedBox(width: 15),
                      FilterDropdownMenu(filterList: moreLess,selectedValue: selectedTotalOddFilter),
                      SizedBox(width: 15),
                      Container(
                        width: 50,
                        child: TextField(
                          controller: _totalOddController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _numberOfGamesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Games',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                randomCouponGenerator();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static late String selectedOddTypeFilter = "Over 2.5";
  static late String selectedTotalOddFilter = "More Than";

  void showSelectedGames(BuildContext context, List<Game> selectedGames,
      List<double> selectedOddsList) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: selectedGames.asMap().entries.map((entry) {
                    int i = entry.key;
                    Game game = entry.value;
                    double odds = selectedOddsList[i];
                    return ListTile(
                      title: Text('${game.team1} vs ${game.team2}'),
                      subtitle:
                      Text('Selected Odd: ${selectedOddTypeFilter} ${odds.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> randomCouponGenerator() async {
    int numberOfGames = int.tryParse(_numberOfGamesController.text) ?? 0;
    double targetOdds = double.tryParse(_totalOddController.text) ?? 0;
    Random random = Random();

    List<Game> availableGames = await fetchGames(selectedLeagues);
    availableGames = availableGames
        .where((game) => selectedLeagues[game.league] ?? false)
        .toList();

    bool foundCombination = false;
    List<Game> selectedGames = [];
    List<double> selectedOddsList = [];
    double currentOdds = 1.0;

    for (int attempt = 0; attempt < 100000; attempt++) {
      selectedGames.clear();
      selectedOddsList.clear();
      currentOdds = 1.0;
      Set<int> usedIndices = {};

      while (selectedGames.length < numberOfGames &&
          usedIndices.length < availableGames.length) {
        int index = random.nextInt(availableGames.length);
        if (!usedIndices.contains(index)) {
          Game game = availableGames[index];
          List<double> oddsOptions = [
            game.ms1,
            game.ms0,
            game.ms2,
            game.alt25,
            game.ust25
          ];

          late double selectedOdds = oddsOptions[random.nextInt(oddsOptions.length)];


          switch(selectedOddTypeFilter){
            case "Over 2.5":
              selectedOdds = oddsOptions[4];
              break;
            case "Under 2.5":
              selectedOdds = oddsOptions[3];
              break;
            case "Result":
              selectedOdds = oddsOptions[random.nextInt(3)];
              break;
            case "Any":
              selectedOdds = oddsOptions[random.nextInt(oddsOptions.length)];
              break;
          }
          selectedGames.add(game);
          selectedOddsList.add(selectedOdds);
          currentOdds *= selectedOdds;
          usedIndices.add(index);
        }
      }

      double roundedCurrentOdds = double.parse(currentOdds.toStringAsFixed(2));



      if (roundedCurrentOdds == targetOdds && GamesPageWidget.selectedTotalOddFilter == "Equal") {
        foundCombination = true;
        break;
      }else if(roundedCurrentOdds <= targetOdds && GamesPageWidget.selectedTotalOddFilter == "Less Than"){
        foundCombination = true;
        break;
      }else if(roundedCurrentOdds >= targetOdds && GamesPageWidget.selectedTotalOddFilter == "More Than"){
        foundCombination = true;
        break;
      }


    }

    print(selectedOddTypeFilter);
    print(selectedTotalOddFilter);

    if (!foundCombination) {
      print('No match');
    } else {
      for (int i = 0; i < selectedGames.length; i++) {
        print(
            'Game: ${selectedGames[i].team1} vs ${selectedGames[i].team2}, Selected Odds: ${selectedOddsList[i]}');
      }
      showSelectedGames(context, selectedGames, selectedOddsList);
      print('Final Odds: ${currentOdds.toStringAsFixed(2)}');
    }
  }
}

class FilterDropdownMenu extends StatefulWidget {
  FilterDropdownMenu({super.key, required this.filterList, required this.selectedValue});
  final List<String> filterList;
  late String selectedValue;

  @override
  State<FilterDropdownMenu> createState() => _FilterDropdownMenuState();
}

class _FilterDropdownMenuState extends State<FilterDropdownMenu> {
  late String dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.filterList.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.filterList.contains("More Than") ? GamesPageWidget.selectedTotalOddFilter:GamesPageWidget.selectedOddTypeFilter,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.selectedValue = dropdownValue;
          if(widget.filterList.contains("More Than")){
            GamesPageWidget.selectedTotalOddFilter = dropdownValue;
          }else{
            GamesPageWidget.selectedOddTypeFilter = dropdownValue;
          }
        });
      },
      dropdownMenuEntries: widget.filterList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}





/*Future<void> randomCouponGenerator() async {
    int numberOfGames = int.tryParse(_numberOfGamesController.text) ?? 0;
    double targetOdds = double.tryParse(_totalOddController.text) ?? 0;
    Random random = Random();

    List<Game> availableGames = await fetchGames(selectedLeagues);
    availableGames = availableGames
        .where((game) => selectedLeagues[game.league] ?? false)
        .toList();

    bool foundCombination = false;
    List<Game> selectedGames = [];
    List<double> selectedOddsList = [];
    double currentOdds = 1.0;

    for (int attempt = 0; attempt < 100000; attempt++) {
      selectedGames.clear();
      selectedOddsList.clear();
      currentOdds = 1.0;
      Set<int> usedIndices = {};

      while (selectedGames.length < numberOfGames &&
          usedIndices.length < availableGames.length) {
        int index = random.nextInt(availableGames.length);
        if (!usedIndices.contains(index)) {
          Game game = availableGames[index];
          List<double> oddsOptions = [
            game.ms1,
            game.ms0,
            game.ms2,
            game.alt25,
            game.ust25
          ];
          double selectedOdds = oddsOptions[random.nextInt(oddsOptions.length)];
          selectedGames.add(game);
          selectedOddsList.add(selectedOdds);
          currentOdds *= selectedOdds;
          usedIndices.add(index);
        }
      }

      double roundedCurrentOdds = double.parse(currentOdds.toStringAsFixed(2));
      if (roundedCurrentOdds == targetOdds) {
        foundCombination = true;
        break;
      }
    }

    if (!foundCombination) {
      print('No match');
    } else {
      for (int i = 0; i < selectedGames.length; i++) {
        print(
            'Game: ${selectedGames[i].team1} vs ${selectedGames[i].team2}, Selected Odds: ${selectedOddsList[i]}');
      }
      print('Final Odds: ${currentOdds.toStringAsFixed(2)}');

      showSelectedGames(context, selectedGames, selectedOddsList);

    }
  }

  void showSelectedGames(BuildContext context, List<Game> selectedGames,
      List<double> selectedOddsList) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: selectedGames.asMap().entries.map((entry) {
                    int i = entry.key;
                    Game game = entry.value;
                    double odds = selectedOddsList[i];
                    return ListTile(
                      title: Text('${game.team1} vs ${game.team2}'),
                      subtitle:
                      Text('Selected Odd: ${odds.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }*/

