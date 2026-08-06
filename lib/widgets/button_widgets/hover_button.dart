import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class HoverButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HoverButton({super.key, required this.icon, required this.onTap});

  @override
  State<HoverButton> createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    // final isDesktop = ResponsiveHelper(context).isDesktop;

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isHover ? gPrimaryColor : gWhiteColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isHover ? gPrimaryColor : borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: isHover ? 4 : 2,
              )
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              widget.icon,
              key: ValueKey(isHover),
              size: 16,
              color: isHover ? gWhiteColor : gPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}