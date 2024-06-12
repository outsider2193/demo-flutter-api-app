import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'MyApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> productData = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> apiCall() async {
    var url = Uri.https('api.escuelajs.co', 'api/v1/products');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        productData = json.decode(response.body);
      });
    } else {
      setState(() {
        productData = [];
      });
    }
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
          children: [
            ElevatedButton(
              onPressed: apiCall,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: productData.isNotEmpty
                  ? ListView.builder(
                      itemCount: productData.length,
                      itemBuilder: (context, index) {
                        var product = productData[index];
                        return ListTile(
                          leading: product['images'] != null &&
                                  product['images'].isNotEmpty
                              ? Image.network(
                                  product['images'][0],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : null,
                          title: Text(product['title'] ?? 'No Title'),
                          subtitle:
                              Text('Price: \$${product['price'].toString()}'),
                        );
                      },
                    )
                  : const Center(child: Text("No data")),
            ),
          ],
        ),
      ),
    );
  }
}
