// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show IFrameElement;
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ContactMap extends StatefulWidget {
  const ContactMap({super.key});

  @override
  State<ContactMap> createState() => _ContactMapState();
}

class _ContactMapState extends State<ContactMap> {
  @override
  void initState() {
    super.initState();


    if (kIsWeb) { const mapHTML = '''<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2522.9688928084615!2d55.38256954016116!3d25.323459568066312!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3e5f5beb62018109%3A0xb49ea0a2563851a!2sAl%20Durrah%20Tower%20-%20First%20Floor%20-%20next%20to%20Al%20Buhaira%20Police%20station%20-%20Al%20Majaz%203%20-%20Al%20Majaz%20-%20Sharjah!5e1!3m2!1sen!2sae!4v1768716989958!5m2!1sen!2sae"
     width="100%" 
     height="400" 
     style="border:2;" 
     allowfullscreen="" 
     loading="eager" 
     referrerpolicy="no-referrer-when-downgrade"></iframe>''';
    PlatformViewRegistry().registerViewFactory(
      'gulfsky-map',
          (int viewId) => html.IFrameElement()
        ..srcdoc = mapHTML
        ..style.border = '0'
            ..style.width = '100%'
            ..style.height = '100%',
    );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(child: Text('Map available on Web only'));
    }
    return const SizedBox(
      child: HtmlElementView(viewType: 'gulfsky-map'),
    );
  }
}
