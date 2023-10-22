import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'second_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String SERVER_URL = dotenv.get(
  "SERVER_URL",
  fallback: "http://localhost:88",
);
// ignore: non_constant_identifier_names
Future<List<ShopQueue>> fetchQueues() async {
  final response = await http.get(Uri.parse('$SERVER_URL/queue'));
  print(response.body);
  if (response.statusCode == 200) {
    // Do something with the response body
    return jsonDecode(response.body)
        .map((data) => ShopQueue.fromJson(data))
        .toList()
        .cast<ShopQueue>();
  } else {
    throw Exception('Failed to fetch queue');
  }
}

class ShopQueue {
  final int id;
  final String name;
  final int current;
  final int lastPosition;
  final String createdAt;
  final String iconName;
  ShopQueue({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.current,
    required this.lastPosition,
    required this.iconName,
  });

  factory ShopQueue.fromJson(Map<String, dynamic> json) {
    return ShopQueue(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      current: json['current'],
      lastPosition: json['last_position'],
      iconName: json['icon'],
    );
  }
}

// Create a FutureBuilder widget for the queues
FutureBuilder<List<ShopQueue>> buildFutureBuilderQueues() {
  return FutureBuilder<List<ShopQueue>>(
    future: fetchQueues(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<ShopQueue>? data = snapshot.data;
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 0,
            ),
            itemCount: data!.length,
            itemBuilder: (BuildContext context, int index) {
              return QueueItem(data: data[index]);
            });
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 8.0,
            color: Color.fromARGB(255, 255, 189, 89),
          ),
          SizedBox(height: 20),
          Text('Loading Queues...'),
        ],
      );
    },
  );
}

class QueueItem extends StatelessWidget {
  const QueueItem({
    super.key,
    required this.data,
  });
  final ShopQueue data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("napindot ${data.name}");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecondRoute(
                    queue: data,
                  )),
        );
      },
      child: ServiceCard(data.name, data.iconName),
    );
  }
}
