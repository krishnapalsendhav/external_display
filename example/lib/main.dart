import 'package:flutter/material.dart';
import 'package:external_screen/display_manager.dart';
import 'package:external_screen/display.dart';
import 'package:external_screen/secondary_display.dart';

void main() {
  runApp(const MyApp());
}

/// Secondary display entry point
/// This is called when the secondary display is shown
@pragma('vm:entry-point')
void secondaryDisplayMain() {
  runApp(const SecondaryDisplayApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'External Display Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(title: 'External Display Demo'),
      // Register routes for secondary displays
      routes: {'/presentation': (context) => const PresentationScreen()},
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
  final DisplayManager _displayManager = DisplayManager();
  List<Display> _displays = [];
  int? _currentDisplayId;
  bool _isPresentationShowing = false;
  String _statusMessage = 'No displays connected';

  @override
  void initState() {
    super.initState();
    _loadDisplays();
    _listenToDisplayChanges();
  }

  Future<void> _loadDisplays() async {
    final displays = await _displayManager.getDisplays(category: DISPLAY_CATEGORY_PRESENTATION);
    setState(() {
      _displays = displays ?? [];
      _statusMessage = _displays.isEmpty ? 'No external displays found' : '${_displays.length} display(s) found';
    });
  }

  void _listenToDisplayChanges() {
    _displayManager.connectedDisplaysChangedStream?.listen((event) {
      if (event == 1) {
        _statusMessage = 'New display connected';
        _loadDisplays();
      } else if (event == 0) {
        _statusMessage = 'Display disconnected';
        _loadDisplays();
      }
      setState(() {});
    });
  }

  Future<void> _showPresentation(int displayId) async {
    final result = await _displayManager.showSecondaryDisplay(displayId: displayId, routerName: '/presentation');

    setState(() {
      if (result == true) {
        _isPresentationShowing = true;
        _currentDisplayId = displayId;
        _statusMessage = 'Presentation shown on display $displayId';
      } else {
        _statusMessage = 'Failed to show presentation';
      }
    });
  }

  Future<void> _hidePresentation() async {
    if (_currentDisplayId == null) return;

    final result = await _displayManager.hideSecondaryDisplay(displayId: _currentDisplayId!);

    setState(() {
      if (result == true) {
        _isPresentationShowing = false;
        _statusMessage = 'Presentation hidden';
        _currentDisplayId = null;
      } else {
        _statusMessage = 'Failed to hide presentation';
      }
    });
  }

  Future<void> _sendDataToPresentation() async {
    await _displayManager.transferDataToPresentation({'message': 'Hello from main display!', 'timestamp': DateTime.now().toIso8601String(), 'counter': DateTime.now().millisecondsSinceEpoch});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Status:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(_statusMessage, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Available Displays:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                child: _displays.isEmpty
                    ? const Center(child: Text('No external displays available'))
                    : ListView.builder(
                        itemCount: _displays.length,
                        itemBuilder: (context, index) {
                          final display = _displays[index];
                          final isCurrentDisplay = display.displayId == _currentDisplayId;
                          return Card(
                            child: ListTile(
                              leading: Icon(isCurrentDisplay ? Icons.monitor : Icons.monitor_outlined, color: isCurrentDisplay ? Colors.green : Colors.grey),
                              title: Text(display.name ?? 'Unknown'),
                              subtitle: Text('ID: ${display.displayId}'),
                              trailing: isCurrentDisplay ? const Icon(Icons.check_circle, color: Colors.green) : null,
                              onTap: () {
                                if (display.displayId != null) {
                                  _showPresentation(display.displayId!);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(onPressed: _loadDisplays, icon: const Icon(Icons.refresh), label: const Text('Refresh')),
                  ElevatedButton.icon(onPressed: _isPresentationShowing ? _sendDataToPresentation : null, icon: const Icon(Icons.send), label: const Text('Send Data')),
                  ElevatedButton.icon(
                    onPressed: _isPresentationShowing ? _hidePresentation : null,
                    icon: const Icon(Icons.close),
                    label: const Text('Hide'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Presentation screen shown on external display
class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  String _receivedData = 'Waiting for data...';

  void _handleData(dynamic data) {
    setState(() {
      _receivedData = data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryDisplay(
      callback: _handleData,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.blue.shade900,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monitor, size: 100, color: Colors.white),
                const SizedBox(height: 24),
                const Text(
                  'External Display',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 48),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text('Received Data:', style: TextStyle(fontSize: 24, color: Colors.white70)),
                      const SizedBox(height: 16),
                      Text(
                        _receivedData,
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary Display App (for Android)
class SecondaryDisplayApp extends StatelessWidget {
  const SecondaryDisplayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PresentationScreen());
  }
}
