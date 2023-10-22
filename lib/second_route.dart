import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lineup_guru_app/QueueList.dart';
import 'package:lineup_guru_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Create a StatefulWidget that contains a ShopQueue field
class SecondRoute extends StatefulWidget {
  final ShopQueue queue;
  const SecondRoute({
    Key? key,
    required this.queue,
  }) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

// Create a ChangeNotifier for a nullable ShopQueue variable with an extra field my number
class QueueNotifier extends ChangeNotifier {
  ShopQueue? _queue;
  int _myNumber = -1;
  ShopQueue? get queue => _queue;
  int get myNumber => _myNumber;
  void setQueue(ShopQueue queue) {
    _queue = queue;
    notifyListeners();
  }

  void setMyNumber(int myNumber) {
    _myNumber = myNumber;
    notifyListeners();
  }
}

// Create a State class that contains the ShopQueue field
class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QueueNotifier>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Queue Details"),
        ),
        floatingActionButton: FloatingActionButton.extended(
            disabledElevation: 0,
            onPressed:
                model._myNumber > -1 // If myNumber is nonnegative, disable it
                    ? null
                    : () async {
                        model.setMyNumber(await joinQueue(widget.queue, model));
                      },
            label: const Text("Join Queue"),
            icon: const Icon(Icons.add)),
        body: Column(
          children: [
            PageTitleWidget(title: widget.queue.name),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Current #"),
                    Text("${widget.queue.current}"),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Last #"),
                    Text("${widget.queue.lastPosition}"),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Your Number #"),
                    Text("${model._myNumber}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

Future<int> joinQueue(ShopQueue q, QueueNotifier notifier) async {
  final response = await http.post(
    Uri.parse('$SERVER_URL/join/${q.id}'),
  );
  if (response.statusCode == 200) {
    // Do something with the response body
    Map<String, dynamic> result = jsonDecode(response.body);
    return result['number'];
  } else {
    throw Exception('Failed to join queue');
  }
}
