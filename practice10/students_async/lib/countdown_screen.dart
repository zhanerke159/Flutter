import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _version = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('A: StreamBuilder')),
              ButtonSegment(value: 1, label: Text('B: listen')),
            ],
            selected: {_version},
            onSelectionChanged: (s) => setState(() => _version = s.first),
          ),
          Expanded(
            child: Center(
              child: _version == 0 ? const _VersionA() : const _VersionB(),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionA extends StatefulWidget {
  const _VersionA();

  @override
  State<_VersionA> createState() => _VersionAState();
}

class _VersionAState extends State<_VersionA> {
  late final Stream<int> _stream = countdown(10);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stream,
      builder: (context, snapshot) {
        return Text(
          '${snapshot.data ?? 10}',
          style: Theme.of(context).textTheme.displayLarge,
        );
      },
    );
  }
}

class _VersionB extends StatefulWidget {
  const _VersionB();

  @override
  State<_VersionB> createState() => _VersionBState();
}

class _VersionBState extends State<_VersionB> {
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) => setState(() => _left = i));
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_left',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}