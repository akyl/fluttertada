import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'web_socket_state.dart';

import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WebSocket App', channel: IOWebSocketChannel.connect("ws://pm.tada.team/ws")),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title, @required this.channel}) : super(key: key);

  final String title;
  final WebSocketChannel channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isMedved = true;

  void _changeState() {
    setState(() {
      isMedved = !isMedved;
      var state = jsonEncode(WebSocketState(state: isMedved ? 1 : 0).toJson());
      widget.channel.sink.add(state);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current state:',
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.display1,);
                Map<String, dynamic> json = jsonDecode(snapshot.data);
                var webSocketState = WebSocketState.fromJson(json);
                isMedved = webSocketState.state == 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(isMedved ? 'MEDVED' : 'PREVED', style: Theme.of(context).textTheme.display1,),
                );
              },
            ),
            RaisedButton(
              onPressed: _changeState,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'Change state',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
