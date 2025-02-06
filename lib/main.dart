import 'package:edge_detection/edge_detection.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _imagePath = '';

  Future<void> getImage() async {
    final path = ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_PICTURES);
    // ExternalPath
    final imagePath = '$path${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg';
    try {
      bool isSuccess = await EdgeDetection.detectEdge(imagePath);
      if (isSuccess) {
        setState(() {
          _imagePath = imagePath;
        });
      }
    } on PlatformException catch (e) {
      debugPrint('エラーでごわす');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imagePath.isNotEmpty) ...{
              Image.asset(_imagePath),
            } else ...{
              const Text('Empty'),
            },
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
