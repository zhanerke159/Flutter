import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: _count == 0
                ? null
                : () {
                    setState(() {
                      _count--;
                    });
                  },
            child: const Text('-'),
          ),
          const SizedBox(width: 25),
          Text('$_count'),
          const SizedBox(width: 25),
          FilledButton(
            onPressed: () {
              setState(() {
                _count++;
              });
            },
            child: Text('+'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _saving
            ? null
            : () async {
                setState(() {
                  _saving = true;
                });
                await Future.delayed(const Duration(seconds: 2));

                if (!mounted) return;

                setState(() {
                  _saving = false;
                });

                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Saved')));
              },
        child: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : const Text('Save'),
      ),
    ],
  );
}
