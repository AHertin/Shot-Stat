import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Shot {
  String team;
  String time;
  int shot;
  int player;
  String location;
  bool isAGoal;

  Shot({
    required this.team,
    required this.time,
    required this.shot,
    required this.player,
    required this.location,
    this.isAGoal = false,
  });

  dynamic operator [](String field) {
    switch (field) {
      case 'team':
        return team;
      case 'time':
        return time;
      case 'shot':
        return shot;
      case 'player':
        return player;
      case 'location':
        return location;
      case 'isAGoal':
        return isAGoal;
      default:
        throw Exception('Invalid field: $field');
    }
  }
}

class Goal {
  String team;
  String time;
  Shot shot;
  int goal;
  int player;
  String location;

  Goal({
    required this.team,
    required this.time,
    required this.shot,
    required this.goal,
    required this.player,
    required this.location,
  });

  dynamic operator [](String field) {
    switch (field) {
      case 'team':
        return team;
      case 'time':
        return time;
      case 'shot':
        return shot;
      case 'goal':
        return goal;
      case 'player':
        return player;
      case 'location':
        return location;
      default:
        throw Exception('Invalid field: $field');
    }
  }
}

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String _homeTeam = 'Home team';
  String _awayTeam = 'Away team';

  int _homeShotsCounter = 0;
  int _awayShotsCounter = 0;
  int _homeGoalsCounter = 0;
  int _awayGoalsCounter = 0;
  final List<Shot> _shotList = [];
  final List<Goal> _goalList = [];

  bool _matchStarted = false;
  int _timeInSeconds = 0;
  bool _timerRunning = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startMatch();
  }

  void _addShot(
      String teamName, String shotTime, int playerNumber, String location) {
    List<Shot> teamShots =
        _shotList.where((shot) => shot.team == teamName).toList();
    teamShots.sort((a, b) => b.shot.compareTo(a.shot));
    int highestShotNumber = teamShots.isNotEmpty ? teamShots.first.shot : 0;
    int newShotNumber = highestShotNumber + 1;
    Shot newShot = Shot(
      team: teamName,
      time: shotTime,
      player: playerNumber,
      location: location,
      shot: newShotNumber,
    );
    _shotList.add(newShot);
  }

  bool _removeLastShot(String teamName) {
    List<Shot> teamShots =
        _shotList.where((shot) => shot.team == teamName).toList();
    if (teamShots.isEmpty) {
      return false;
    }
    int highestShotNumber = teamShots.map((shot) => shot.shot).reduce(max);
    Shot lastShot =
        teamShots.lastWhere((shot) => shot.shot == highestShotNumber);
    if (lastShot.isAGoal) {
      return false;
    } else {
      _shotList.remove(lastShot);
      return true;
    }
  }

  void _addGoal(
      String teamName, String shotTime, int playerNumber, String location) {
    List<Shot> teamShots =
        _shotList.where((shot) => shot.team == teamName).toList();
    teamShots.sort((a, b) => b.shot.compareTo(a.shot));
    int highestShotNumber = teamShots.isNotEmpty ? teamShots.first.shot : 0;
    int newShotNumber = highestShotNumber + 1;
    List<Goal> teamGoals =
        _goalList.where((goal) => goal.team == teamName).toList();
    teamGoals.sort((a, b) => b.goal.compareTo(a.goal));
    int highestGoalNumber = teamGoals.isNotEmpty ? teamGoals.first.goal : 0;
    int newGoalNumber = highestGoalNumber + 1;
    Shot newShot = Shot(
      team: teamName,
      time: shotTime,
      player: playerNumber,
      location: location,
      shot: newShotNumber,
      isAGoal: true,
    );
    Goal newGoal = Goal(
      team: teamName,
      time: shotTime,
      player: playerNumber,
      location: location,
      goal: newGoalNumber,
      shot: newShot,
    );
    _goalList.add(newGoal);
    _addShot(teamName, shotTime, playerNumber, location);
  }

  void _removeLastGoal(String teamName) {
    List<Goal> teamGoals =
        _goalList.where((shot) => shot.team == teamName).toList();
    if (teamGoals.isEmpty) {
      return;
    }
    int highestShotNumber = teamGoals.map((goal) => goal.goal).reduce(max);
    Goal lastGoal =
        teamGoals.lastWhere((goal) => goal.goal == highestShotNumber);
    _goalList.remove(lastGoal);
    _removeLastShot(teamName);
  }

  void _incrementHomeShotCounter() {
    setState(() {
      _showPrompt(_homeTeam, 'shot');
      _homeShotsCounter++;
    });
  }

  void _incrementAwayShotCounter() {
    setState(() {
      _showPrompt(_awayTeam, 'shot');
      _awayShotsCounter++;
    });
  }

  void _decrementHomeShotCounter() {
    if (_homeShotsCounter > 0) {
      setState(() {
        bool shotRemoved = _removeLastShot(_homeTeam);
        if (!shotRemoved) {
          _homeShotsCounter--;
        }
      });

    }
  }

  void _decrementAwayShotCounter() {
    if (_awayShotsCounter > 0) {
      setState(() {
        bool shotRemoved = _removeLastShot(_awayTeam);
        if (!shotRemoved) {
        _awayShotsCounter--;
        }
      });
    }
  }

  void _incrementHomeGoalCounter() {
    setState(() {
      _showPrompt(_homeTeam, 'goal');
      _homeGoalsCounter++;
      _homeShotsCounter++;
    });
  }

  void _incrementAwayGoalCounter() {
    setState(() {
      _showPrompt(_awayTeam, 'goal');
      _awayGoalsCounter++;
      _awayShotsCounter++;
    });
  }

  void _decrementHomeGoalCounter() {
    if (_homeGoalsCounter > 0) {
      setState(() {
        _removeLastGoal(_homeTeam);
        _homeGoalsCounter--;
        _homeShotsCounter--;
      });
    }
  }

  void _decrementAwayGoalCounter() {
    if (_awayGoalsCounter > 0) {
      setState(() {
        _removeLastGoal(_awayTeam);
        _awayGoalsCounter--;
        _awayShotsCounter--;
      });
    }
  }

  void _showPrompt(String team, String type) {
    TextEditingController timeController = TextEditingController();
    TextEditingController playerController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $type for $team'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  hintText: 'Time',
                ),
              ),
              TextField(
                controller: playerController,
                decoration: const InputDecoration(
                  hintText: 'Player number',
                ),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: 'Location',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String time = timeController.text;
                int player = int.parse(playerController.text);
                String location = locationController.text;
                if (player != null) {
                  setState(() {
                    if (type == 'shot') {
                      _addShot(team, time, player, location);
                    } else {
                      _addGoal(team, time, player, location);
                    }
                  });
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Invalid input'),
                        content:
                            const Text('Please enter a valid player number'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _startMatch() async {
    await Future.delayed(Duration.zero, () {
      final homeTeamController = TextEditingController();
      final awayTeamController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Start match'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: homeTeamController,
                  decoration: const InputDecoration(
                    hintText: 'Enter home team name',
                  ),
                ),
                TextField(
                  controller: awayTeamController,
                  decoration: const InputDecoration(
                    hintText: 'Enter away team name',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _homeTeam = homeTeamController.text;
                    _awayTeam = awayTeamController.text;
                    _matchStarted = true;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Start'),
              ),
            ],
          );
        },
      );
    });
  }

  void _startTimer() {
    if (_timerRunning) {
      _timer?.cancel();
      _timerRunning = false;
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _timeInSeconds++;
        });
      });
      _timerRunning = true;
    }
  }

  String _formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 80.0, // increase the toolbar height
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_homeTeam - $_awayTeam',
              style: const TextStyle(
                fontSize: 20.0, // increase the font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0), // add some padding between the texts
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(_timeInSeconds),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    width:
                        8.0), // add some spacing between the texts and the icon
                IconButton(
                  icon: Icon(
                    _timerRunning
                        ? Icons.pause_circle
                        : Icons.play_arrow_outlined,
                  ),
                  onPressed: _startTimer,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Shots',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_homeTeam),
                    InkWell(
                      onTap: _decrementHomeShotCounter,
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _homeShotsCounter.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _incrementHomeShotCounter,
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_awayTeam),
                    InkWell(
                      onTap: _decrementAwayShotCounter,
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _awayShotsCounter.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _incrementAwayShotCounter,
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Goals',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_homeTeam),
                    InkWell(
                      onTap: _decrementHomeGoalCounter,
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _homeGoalsCounter.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _incrementHomeGoalCounter,
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_awayTeam),
                    InkWell(
                      onTap: _decrementAwayGoalCounter,
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _awayGoalsCounter.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _incrementAwayGoalCounter,
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _matchStarted ? _homeTeam : 'Home team',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          _matchStarted ? '$_homeShotsCounter' : '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  thickness: 2.0,
                  width: 2.0,
                  color: Colors.white,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _matchStarted ? _awayTeam : 'Away team',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          _matchStarted ? '$_awayShotsCounter' : '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Text('Shot list:'),
            Expanded(
              child: ListView.builder(
                itemCount: _shotList.length,
                itemBuilder: (context, index) {
                  final shot = _shotList[index];
                  final goalIndex = _goalList.indexWhere((goal) =>
                      goal['team'] == shot['team'] &&
                      goal['shot'] == shot['shot']);
                  return ListTile(
                    title: Text('Shot ${index + 1}'),
                    subtitle: Text(
                        'Team: ${shot['team']}, Time: ${shot['time']}, Shot number: ${shot['shot']}${goalIndex >= 0 ? ', Goal number: ${_goalList[goalIndex]['goal']}' : ''}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
