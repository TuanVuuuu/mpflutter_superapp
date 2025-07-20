import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp_flutter_runtime/mp_flutter_runtime.dart';

void main() {
  runApp(const SuperApp());
}

class SuperApp extends StatelessWidget {
  const SuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SuperAppHome(),
    );
  }
}

class SuperAppHome extends StatelessWidget {
  const SuperAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Super App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This app can load mini apps',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MiniAppPage(),
                  ),
                );
              },
              child: const Text('Load Mini App'),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniAppPage extends StatefulWidget {
  const MiniAppPage({super.key});

  @override
  State<MiniAppPage> createState() => _MiniAppPageState();
}

class _MiniAppPageState extends State<MiniAppPage> {
  Uint8List? mpkData;

  @override
  void initState() {
    super.initState();
    _loadMpkFile();
  }

  Future<void> _loadMpkFile() async {
    try {
      final bytes = await rootBundle.load('assets/mini_app_example.mpk');
      setState(() {
        mpkData = bytes.buffer.asUint8List();
      });
    } catch (e) {
      print('Error loading MPK file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: mpkData == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading MPK file...'),
                ],
              ),
            )
          : MPMiniPageDebug(
              packageId: 'mini_app_example',
              dev: false,
              mpk: mpkData,
              initParams: const {
                'accessToken': '',
                'refreshToken': '',
              },
              splash: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading mini app...'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
