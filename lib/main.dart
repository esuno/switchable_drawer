import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'eyeicon.dart';
import 'editable.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final editable = ref.watch(editableProvider);
    const drawerIcon = Icon(Icons.list);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: const [EyeIcon()],
          leading: editable
              ? IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: drawerIcon
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 200))
                      .rotate(
                          begin: 0.5,
                          end: 1,
                          duration: const Duration(milliseconds: 200)))
              : drawerIcon
                  .animate()
                  .fadeOut(duration: const Duration(milliseconds: 200))
                  .rotate(
                      begin: 0,
                      end: 0.5,
                      duration: const Duration(milliseconds: 200))),
      drawer: editable ? const NavigationDrawer(children: []) : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: editable
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
