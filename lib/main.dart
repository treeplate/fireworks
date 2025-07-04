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

extension type Firework((int, double, double, Color) value) {
  Firework copyWith({int? size, double? y, double? x, Color? color}) {
    return Firework((
      size ?? this.size,
      y ?? this.y,
      x ?? this.x,
      color ?? this.color,
    ));
  }

  int get size => value.$1;
  double get y => value.$2;
  double get x => value.$3;
  Color get color => value.$4;
}

const int minWidth = 5;

class _FireworksState extends State<Fireworks>
    with SingleTickerProviderStateMixin {
  List<Firework> fireworks = [];
  late final Ticker ticker;
  final Random random = Random();
  int newFireworkProbability = 40;

  @override
  void initState() {
    ticker = createTicker(tick)..start();
    super.initState();
  }

  void tick(Duration duration) {
    if (random.nextInt(newFireworkProbability) == 0) {
      fireworks.add(
        Firework((
          minWidth,
          1,
          random.nextDouble(),
          Color(random.nextInt(0x1000000) | 0xFF000000),
        )),
      );
    }
    List<Firework> newFireworks = [];
    setState(() {
      for (Firework firework in fireworks) {
        if (firework.size == minWidth) {
          if (firework.y <= Random(firework.color.toARGB32()).nextDouble()) {
            newFireworks.add(
              firework.copyWith(size: minWidth + 1, y: firework.y - .001),
            );
            continue;
          }
          newFireworks.add(firework.copyWith(y: firework.y - .001));
          continue;
        }
        if (firework.color.a < 1) {
          if (firework.color.a == 0) continue;
          newFireworks.add(
            firework.copyWith(
              size: (firework.size + 1),
              color: firework.color.withAlpha(
                (firework.color.a * 255).round() - 1,
              ),
            ),
          );
          continue;
        }
        if (random.nextInt(40) == 0) {
          newFireworks.add(
            firework.copyWith(
              size: (firework.size + 1),
              color: firework.color.withAlpha(254),
            ),
          );
          continue;
        }
        newFireworks.add(firework.copyWith(size: (firework.size + 1)));
      }
      fireworks = newFireworks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AppBar(
                actions: [Text('Firework Probability'), Slider(value: 1-(newFireworkProbability-1)/100, onChanged: (e) => newFireworkProbability=1+(1-e)*100~/1)],
              ),
              ...fireworks.map(
                (e) => Positioned(
                  top: e.y * constraints.maxHeight - e.size / 2,
                  left: e.x * constraints.maxWidth - e.size / 2,
                  child: Container(
                    width: e.size.toDouble(),
                    height: e.size.toDouble(),
                    decoration: BoxDecoration(
                      color: e.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
