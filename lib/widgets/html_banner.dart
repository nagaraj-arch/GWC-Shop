import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

class HtmlBanner extends StatelessWidget {
  final String htmlText;
  final bool isDescription;

  const HtmlBanner({
    super.key,
    required this.htmlText,
    this.isDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final h1Size = width < 600
        ? 22
        : width < 1024
        ? 32
        : width < 1440
        ? 38
        : width < 1920
        ? 44
        : 52;

    final spanSize = width < 600
        ? 26
        : width < 1024
        ? 38
        : width < 1440
        ? 46
        : width < 1920
        ? 54
        : 62;

    // Base pSize
    final basePSize = width < 600
        ? 14
        : width < 1024
        ? 20
        : width < 1440
        ? 22
        : 26;

    // Reduced pSize for description
    final pSize = basePSize;
    final descPSize = width < 600
        ? 10
        : width < 1024
        ? 16
        : width < 1440
        ? 18
        : width < 1920
        ? 20
        : 22;

    final viewType = "html_banner_${UniqueKey()}";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (int id) {
      final div = html.DivElement()
        ..style.width = "100%"
        ..style.margin = "0"
        ..style.padding = "0"
        ..style.backgroundColor = "transparent";

      final htmlContent = isDescription
          ? htmlText.replaceAll("<p>", '<p class="desc">')
          : htmlText;

      div.setInnerHtml(
        '''
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible:wght@400;700&family=Caveat:wght@700&display=swap" rel="stylesheet">

<style>

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  margin: 0;
  padding: 0;
  background: transparent;
}

body {
  display: block;
  font-family: 'Atkinson Hyperlegible', sans-serif;
}

h1 {
  font-size: ${h1Size}px;
  line-height: 1.1;
  font-weight: 400;
  color: #2C2423;
  margin: 0;
}

b {
  font-weight: 700;
}

span {
  color: #A63A2B;
  font-family: 'Caveat', cursive;
  font-size: ${spanSize}px;
  font-weight: 700;
}

/* Normal text (subText, etc.) */
p {
  margin-top: 8px;
  font-family: 'Caveat', cursive;
  font-size: ${pSize}px;
  font-weight: 700;
  color: #A63A2B;
}

/* Description text – smaller */
p.desc {
  margin-top: 6px;
  font-family: 'Caveat', cursive;
  font-size: ${descPSize}px;
  font-weight: 700;
  color: #A63A2B;
  line-height: 1.1;
}

</style>
    
$htmlContent
''',
        validator: html.NodeValidatorBuilder.common()
          ..allowHtml5()
          ..allowElement('style')
          ..allowElement('link', attributes: ['href', 'rel', 'crossorigin']),
      );

      return div;
    });

    return HtmlElementView(viewType: viewType);
  }
}