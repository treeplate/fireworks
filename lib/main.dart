import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const Fireworks());
}

class Fireworks extends StatefulWidget {
  const Fireworks({super.key});

  @override
  State<Fireworks> createState() => _FireworksState();
}

typedef Firework = (int, double, double, Color);

class _FireworksState extends State<Fireworks>
    with SingleTickerProviderStateMixin {
  List<Firework> fireworks = [];
  late final Ticker ticker;
  final Random random = Random();

  @override
  void initState() {
    ticker = createTicker((duration) {
      if (random.nextInt(10) == 0) {
        fireworks.add((
          0,
          random.nextDouble(),
          random.nextDouble(),
          Color(random.nextInt(0x1000000) | 0xFF000000),
        ));
      }
      List<Firework> newFireworks = [];
      setState(() {
        for (Firework firework in fireworks) {
          print(firework.$4);
          if (random.nextInt(40) == 0) {
            continue;
          }
          newFireworks.add((
            (firework.$1 + 1),
            firework.$2,
            firework.$3,
            firework.$4,
          ));
        }
        fireworks = newFireworks;
      });
    })..start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: fireworks
                .map(
                  (e) => Positioned(
                    top: e.$2 * constraints.maxHeight - e.$1 / 2,
                    left: e.$3 * constraints.maxWidth - e.$1 / 2,
                    child: Container(
                      width: e.$1.toDouble(),
                      height: e.$1.toDouble(),
                      decoration: BoxDecoration(
                        color: e.$4,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
