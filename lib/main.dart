import 'package:flutter/material.dart';

import 'match_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shot Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shot Stats'),
          toolbarHeight: 80.0, // increase the toolbar height
          backgroundColor: Colors.blue,
        ),
        body: Builder(
          builder: (BuildContext context) {
            // Use a Builder widget to obtain a BuildContext that is a descendant of the Navigator
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'To start a new match, press New Match',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MatchPage()),
                      );
                    },
                    child: Container(
                      width: 200.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: const Center(
                        child: Text(
                          'New Match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
