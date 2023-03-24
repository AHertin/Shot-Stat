import 'dart:async';

import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> _shotList = [];

  bool _matchStarted = false;

  int _timeInSeconds = 0;
  bool _timerRunning = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startMatch();
  }

  void _incrementHomeCounter() {
    setState(() {
      _homeShotsCounter++;
      _shotList.add({'team': _homeTeam, 'time': _formatTime(_timeInSeconds), 'shot': _homeShotsCounter});
    });
  }

  void _incrementAwayCounter() {
    setState(() {
      _awayShotsCounter++;
      _shotList.add({'team': _awayTeam, 'time': _formatTime(_timeInSeconds), 'shot': _awayShotsCounter});
    });
  }

  void _decrementHomeCounter() {
    if (_homeShotsCounter > 0) {
      setState(() {
        _homeShotsCounter--;
      });
    }
  }

  void _decrementAwayCounter() {
    if (_awayShotsCounter > 0) {
      setState(() {
        _awayShotsCounter--;
      });
    }
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: _decrementHomeCounter,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _incrementHomeCounter,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _decrementAwayCounter,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _incrementAwayCounter,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
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
                return ListTile(
                  title: Text('Shot ${index + 1}'),
                  subtitle:
                      Text('Team: ${shot['team']}, Time: ${shot['time']}, Shot number: ${shot['shot']}'),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
