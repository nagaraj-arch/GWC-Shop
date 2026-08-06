import 'package:flutter/material.dart';
import 'package:gwc_shop/utils/constants.dart';

import '../../../widgets/app_bar_widgets/announcement_bar.dart';
import '../../../widgets/app_bar_widgets/dashboard_app_bar.dart';
import '../../widgets/app_bar_widgets/mobile_drawer.dart';
import 'footer_section.dart';

class FooterWrapper extends StatefulWidget {
  final Widget child;

  const FooterWrapper({super.key, required this.child});

  static final ScrollController scrollController = ScrollController();

  @override
  State<FooterWrapper> createState() => _FooterWrapperState();
}

class _FooterWrapperState extends State<FooterWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gWhiteColor,
      endDrawer: const MobileDrawer(),
      body: Column(
        children: [
          const DashboardAppBar(),
          const AnnouncementBar(),
          Expanded(
            child: ListView(
              controller: FooterWrapper.scrollController,
              children: [
                widget.child,
                const SizedBox(height: 40),
                const FooterSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}