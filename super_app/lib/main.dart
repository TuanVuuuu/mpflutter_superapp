import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp_flutter_runtime/mp_flutter_runtime.dart';
import 'package:super_app/models/app_info.dart';

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

class SuperAppHome extends StatefulWidget {
  const SuperAppHome({super.key});

  @override
  State<SuperAppHome> createState() => _SuperAppHomeState();
}

class _SuperAppHomeState extends State<SuperAppHome> {
  final List<AppInfo> miniApps = [
    const AppInfo(
      name: 'Mini App Example',
      description: 'A simple mini app example',
      mpkPath: 'assets/mini_app_example.mpk',
    ),
    const AppInfo(
      name: 'Counter Mini App',
      description: 'A counter mini app',
      mpkPath: 'assets/counter_mini_app.mpk',
    ),
  ];
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
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: miniApps.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MiniAppPage(
                          appInfo: miniApps[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.apps),
                            Text(miniApps[index].name),
                            Text(
                              miniApps[index].description,
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MiniAppPage extends StatefulWidget {
  const MiniAppPage({super.key, required this.appInfo});

  final AppInfo appInfo;

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
      final bytes = await rootBundle.load(widget.appInfo.mpkPath);
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
              packageId: widget.appInfo.name,
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
