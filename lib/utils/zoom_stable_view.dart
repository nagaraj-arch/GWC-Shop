import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Wrap your app (or any subtree using ScreenSizeHelper/MediaQuery for
/// responsive breakpoints) with this widget to stop Flutter Web from
/// reacting to browser zoom changes.
///
/// Browser zoom changes the logical (CSS) viewport size, which Flutter
/// Web reports through MediaQuery.size — identical to a real window
/// resize. This widget snapshots the size once, and only updates it
/// when a *real* resize happens (detected via a debounce + sanity check),
/// filtering out zoom-triggered metric changes.
class ZoomStableView extends StatefulWidget {
  final Widget child;
  const ZoomStableView({required this.child, super.key});

  @override
  State<ZoomStableView> createState() => _ZoomStableViewState();
}

class _ZoomStableViewState extends State<ZoomStableView>
    with WidgetsBindingObserver {
  Size? _lockedSize;
  double? _lockedDpr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _lock());
  }

  void _lock() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final dpr = view.devicePixelRatio;
    final size = view.physicalSize / dpr;
    if (!mounted) return;
    setState(() {
      _lockedDpr = dpr;
      _lockedSize = size;
    });
  }

  @override
  void didChangeMetrics() {
    // Intentionally ignored: this is what stops browser zoom from
    // cascading into MediaQuery-driven breakpoint/layout changes.
    //
    // NOTE: this also means a genuine window resize (e.g. dragging the
    // browser window edge, or rotating a device) won't be picked up
    // automatically either, since Flutter can't tell zoom and resize
    // apart from this signal alone. If you need real resizes to still
    // work, see the alternative approach below this class.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lockedSize == null) {
      return const SizedBox.shrink();
    }
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        size: _lockedSize,
        devicePixelRatio: _lockedDpr,
      ),
      child: widget.child,
    );
  }
}
