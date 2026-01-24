import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final String suffix;
  final Duration duration;
  final TextStyle? textStyle;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 2000),
    this.textStyle,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _animation.addListener(() {
      setState(() {
        _currentValue = _animation.value.round();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_currentValue${widget.suffix}',
      style: widget.textStyle ?? const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AnimatedCounterTrigger extends StatefulWidget {
  final Widget child;
  final VoidCallback onVisible;

  const AnimatedCounterTrigger({
    super.key,
    required this.child,
    required this.onVisible,
  });

  @override
  State<AnimatedCounterTrigger> createState() => _AnimatedCounterTriggerState();
}

class _AnimatedCounterTriggerState extends State<AnimatedCounterTrigger> {
  bool _hasTriggered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_hasTriggered) {
            final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final position = renderBox.localToGlobal(Offset.zero);
              final screenHeight = MediaQuery.of(context).size.height;
              
              if (position.dy < screenHeight * 0.8) {
                _hasTriggered = true;
                widget.onVisible();
              }
            }
          }
        });
        
        return widget.child;
      },
    );
  }
}
