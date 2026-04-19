import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'auto_demo_helper.dart';

/// Spec for a device to simulate
class DeviceSpec {
  final String name;
  final Size? size;
  final IconData icon;

  const DeviceSpec({required this.name, this.size, required this.icon});
}

class DevicePreviewBar extends StatefulWidget {
  final Widget child;

  const DevicePreviewBar({super.key, required this.child});

  @override
  State<DevicePreviewBar> createState() => _DevicePreviewBarState();
}

class _DevicePreviewBarState extends State<DevicePreviewBar> {
  static const List<DeviceSpec> _specs = [
    DeviceSpec(name: 'Full', size: null, icon: Icons.fullscreen_rounded),
    DeviceSpec(
      name: 'iPhone 17 Pro Max',
      size: Size(440, 956),
      icon: Icons.phone_iphone_rounded,
    ),
    DeviceSpec(
      name: 'Fold 7',
      size: Size(768, 900),
      icon: Icons.stay_current_portrait_rounded,
    ),
    DeviceSpec(
      name: 'iPad Pro',
      size: Size(1024, 1366),
      icon: Icons.tablet_mac_rounded,
    ),
  ];

  DeviceSpec _selectedSpec = _specs[0];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          // ── App Container ──
          Positioned.fill(
            top: 60, // Space for the bar
            child: _buildAppContainer(),
          ),

          // ── Floating Bar ──
          Positioned(top: 0, left: 0, right: 0, height: 60, child: _buildBar()),
        ],
      ),
    );
  }

  Widget _buildAppContainer() {
    if (_selectedSpec.size == null) {
      return widget.child;
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        width: _selectedSpec.size!.width,
        height: _selectedSpec.size!.height,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: _selectedSpec.size!,
            padding: const EdgeInsets.only(top: 44), // Simulate notch space
          ),
          child: widget.child,
        ),
      ),
    );
  }

  Widget _buildBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showLabel = constraints.maxWidth > 500;
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (showLabel) ...[
                    Text(
                      'NOVA Device Test',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                  ],
                  _buildDemoButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // Keep the active option visible if possible
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _specs.map((spec) => _buildOption(spec)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: AutoDemoHelper.isRunning,
      builder: (context, isRunning, child) {
        return GestureDetector(
          onTap: () => AutoDemoHelper.runFullDemo(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isRunning 
                  ? Colors.red.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isRunning 
                    ? Colors.red.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                if (isRunning) ...[
                  const _PulseDot(),
                  const SizedBox(width: 8),
                ] else ...[
                  const Icon(Icons.play_circle_fill, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  isRunning ? 'DEMO LIVE' : 'PLAY DEMO',
                  style: TextStyle(
                    color: isRunning ? Colors.redAccent : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSpecSelected(DeviceSpec spec) async {
    setState(() => _selectedSpec = spec);

    // Sync with native window on desktop
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      if (spec.size != null) {
        // Add some margin for the title bar/debug bar if needed, 
        // but for now let's use the actual spec size
        await windowManager.setSize(
          Size(spec.size!.width, spec.size!.height + 60),
          animate: true,
        );
      } else {
        // Restore to a reasonable default or previous size
        await windowManager.setSize(const Size(1200, 800), animate: true);
      }
      await windowManager.center();
    }
  }

  Widget _buildOption(DeviceSpec spec) {
    final isSelected = _selectedSpec == spec;
    return GestureDetector(
      onTap: () => _handleSpecSelected(spec),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              spec.icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                spec.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
