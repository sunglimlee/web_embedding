import 'dart:async';
import 'dart:html';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demos 18:18',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Pagess'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@js.JSExport() // We use @js.JSExport to annotate our state class
class _MyHomePageState extends State<MyHomePage> {
  int _counterScreenCount = 0;

  // 이제 이부분이 제일 중요한 부분이다. 외부와 통신하는 부분이가??
  final _streamController = StreamController<void>.broadcast();

  String _url = 'flutter.dev';
  bool _isShown = true;

  @js.JSExport() // 이렇게 개별적으로 외부 노출을 해주어야 하는가???
  int get count => _counterScreenCount;

  @js.JSExport() // 이렇게 외부의 함수도 연결해야하는가?
  void addHandler(void Function() handler) {
    // This registers the handler we wrote in
    _streamController.stream.listen((event) {
      handler(); // javascript 사이드에서 오는 함수
    });
  }

  @js.JSExport()
  void getValue(String payload) {
    setState(() {
      _url = payload;
      // This lizne makes sure the handler gets the event
      _streamController.add(null);
    });
  }

  @js.JSExport()
  void showHideValue(bool val) {
    setState(() {
      _isShown = val;
      // This line makes sure the handler gets the event
      _streamController.add(null);
    });
  }

  @js.JSExport()
  String get showHideNav => _isShown ? 'Hide Navigation' : 'Show Navigation';

/*
The JavaScript object that is created by js_util.createDartExport(this) can be used to call Dart methods and access Dart properties from JavaScript.
*/
  @override
  void initState() {
    /*
    In Flutter, this code is an implementation of the initState() method of a stateful widget. Here's a breakdown of what it does:

The @override annotation indicates that the initState() method is overriding a method from the superclass (in this case, StatefulWidget).

Inside the initState() method, the js_util.createDartExport(this) function is called. This function creates a JavaScript object that represents the Dart object that the this keyword refers to. The js_util library is part of the dart:js package, which provides interop between Dart and JavaScript.

The JavaScript object that is created by js_util.createDartExport(this) can be used to call Dart methods and access Dart properties from JavaScript.

Finally, the super.initState() method is called to ensure that the superclass's implementation of initState() is also executed.

Overall, this code is setting up an interop between Dart and JavaScript by creating a JavaScript object that represents the Dart object that the widget state belongs to. This can be useful when you need to interact with JavaScript code or libraries from your Flutter app.
*/
    final export = js_util.createDartExport(this);
    // These two are used inside the [js/js-interop.js]
    /*
    This code is using the js_util library to set a property on the global object called _appState with a value of export.

Let's break it down step-by-step:

js_util is a library that provides utility functions for working with JavaScript objects in the Dart programming language. It is likely being used in this code to provide some interoperability between Dart and JavaScript code.

js_util.globalThis is using the globalThis keyword to reference the global object in a way that is consistent across different environments. This is similar to using window in a browser or global in Node.js, but globalThis works in any environment.

The setProperty function is then called on the js_util library with three arguments:

The first argument is the object on which to set the property, in this case the global object.

The second argument is the name of the property to set, in this case _appState.

The third argument is the value to set the property to, in this case export.

Overall, this code is setting a property on the global object with the name _appState and a value of export using the js_util library. The specific purpose and context of this code may vary depending on the larger codebase it is a part of.
*/
    js_util.setProperty(js_util.globalThis, '_appState', export);
    /*
    In Flutter, `js_util.callMethod()` is used to call a JavaScript function from Dart. The first argument to `js_util.callMethod()` is the object on which the function is called, and the second argument is the name of the function. The third argument is a list of arguments to be passed to the function.

In the code snippet you provided, `js_util.callMethod<void>(js_util.globalThis, '_stateSet', [])` is calling the `_stateSet` function on the global `this` object in JavaScript with an empty argument list.

`js_util.globalThis` refers to the global object in JavaScript. In a web browser, the global object is usually `window`. 

The `void` type argument in `js_util.callMethod<void>` is indicating that we expect the function to return nothing. 

Without knowing the context of your code, it's difficult to provide more specific information about what `_stateSet` does and why it's being called in `initState()`.
    */
    /*
    In Flutter, `js_util.callMethod()` is a generic function. The type argument `<void>` in `js_util.callMethod<void>()` specifies the expected return type of the JavaScript function being called. 

By default, `js_util.callMethod()` returns a dynamic type, which can be cumbersome to work with in a statically typed language like Dart. Specifying the expected return type using generics can help with type safety and make the code more readable.

In this case, `js_util.callMethod<void>()` is indicating that the `_stateSet` function does not return anything (i.e., it has a return type of `void`). If the function did return a value, we would specify the return type accordingly (e.g., `js_util.callMethod<int>()` if the function returns an integer).
    */
    js_util.callMethod<void>(
        js_util.globalThis, '_stateSet', []); // 이제 javascript 함수를 실행한다.
    super.initState();
  }

  @js.JSExport()
  void increment() {
    setState(() {
      _counterScreenCount++;
      _streamController.add(null);
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counterScreenCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 40,
            ),
            if (_isShown)
              ElevatedButton(
                  onPressed: () => _launchUrl(_url),
                  child: Text('Going to $_url')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _launchUrl(String url) async {
    final toLaunch = Uri(scheme: 'https', host: url);
    window.open(toLaunch.toString(), 'new tab');
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
