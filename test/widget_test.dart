import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _tambahCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$_counter', key: const Key('teksCounter')),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _tambahCounter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Counter bertambah ketika tombol ditekan', (
    WidgetTester tester,
  ) async {
    // Render widget CounterWidget
    await tester.pumpWidget(const CounterWidget());

    // Pastikan nilai awal 0 muncul dan 1 tidak muncul
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tekan tombol tambah (ikon plus)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); 

    // Pastikan nilai 1 sekarang muncul dan 0 hilang
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
