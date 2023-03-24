import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  int _leftCounter = 0;
  int _rightCounter = 0;

  void _incrementLeftCounter() {
    setState(() {
      _leftCounter++;
    });
  }

  void _incrementRightCounter() {
    setState(() {
      _rightCounter++;
    });
  }

  void _decrementLeftCounter() {
    if (_leftCounter > 0) {
      setState(() {
        _leftCounter--;
      });
    }
  }

  void _decrementRightCounter() {
    if (_rightCounter > 0) {
      setState(() {
        _rightCounter--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match'),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _incrementLeftCounter,
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
              onTap: _decrementLeftCounter,
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
              onTap: _decrementRightCounter,
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
              onTap: _incrementRightCounter,
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Home team shots:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '$_leftCounter',
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
                    const Text(
                      'Away team shots:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '$_rightCounter',
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
      ),
    );
  }
}
