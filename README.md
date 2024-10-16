
# 概要

画面の状態によってdrawerやfloatingActionButtonのアイコンの表示/非表示を切り替えたい&アニメーションをつけたい場合の方法。

![drawer_demo2.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/417009/81f4d72b-db60-ca43-b00a-2f5d7dd62513.gif)

## floatingActionButton

ScaffoldのfloatingActionButtonに渡すウィジェットを`FloatingActionButton`ウィジェットと`null`で切り替えれば良い。
特に他に何も指定しなくても再描画時にいい感じにアニメーションしてくれる。

```dart
Scaffold(
      floatingActionButton: editable
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
    );
```

## NavigationDrawer(おそらくDrawerも同様)

drawerの場合、floatingActionButtonと同じように`null`を渡すだけだと特にアニメーションがなく、即時に表示非表示が切り替わる。

```dart
Scaffold(
      appBar: ...,
      drawer: editable ? const NavigationDrawer(children: []) : null,
      body: ...,
      floatingActionButton: editable
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
    );
```

![drawer_demo.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/417009/958f870f-6c4e-c747-7f92-9f753fa58a00.gif)

NavigationDrawerやDrawerにはアイコンについて指定するプロパティはなく、アイコンの変更等を行う場合はAppBarの`leading`をいじる。

### drawerの開閉用アイコンを任意のウィジェットにする

drawerの開閉用アイコンはデフォルトでハンバーガーメニューになっている。
ハンバーガーメニューから任意のウィジェットに変更したい場合、AppBarの`leading`に、タップしたときに`Scaffold.of(context).openDrawer()`を実行する任意のウィジェットを渡せばよい。

```dart
Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: drawerIcon,
            onPressed: () => Scaffold.of(context).openDrawer(),
          )),
      drawer: editable ? const NavigationDrawer(children: []) : null,
      body: ...,
      floatingActionButton: ...,
    );
```

### drawerの開閉用アイコンをアニメーションアイコンにする

floationActionButtonと同じようにアニメーションさせるには、先述の任意のウィジェットを、`flutter_animate`でアニメーションを追加したアイコンボタンとすれば良い。

#### flutter_animate の導入

```powershell
flutter pub add flutter_animate
```

詳しい使い方は公式ドキュメント等を参照。

#### アニメーションの設定

AppBarの`leading`に、表示時はタップで`Scaffold.of(context).openDrawer()`を実行するアイコンボタン(フェードインするアイコン)、非表示時はフェードアウトするアイコンを設定する。

```dart
AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(widget.title),
    actions: const [EyeIcon()],
    leading: editable
        ? IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: drawerIcon // 表示時フェードインつきアイコン
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 200))
                .rotate(
                    begin: 0.5,
                    end: 1,
                    duration: const Duration(milliseconds: 200)))
        : drawerIcon // 非表示時フェードアウトつきアイコン
            .animate()
            .fadeOut(duration: const Duration(milliseconds: 200))
            .rotate(
                begin: 0,
                end: 0.5,
                duration: const Duration(milliseconds: 200))),
```

## サンプルコード(main.dart全体)

editable.dart等を含む全体は[GitHub](https://github.com/esuno/switchable_drawer)にあります。
<details>
<summary>サンプルコード</summary>

```dart:main.dart
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
```

</details>
