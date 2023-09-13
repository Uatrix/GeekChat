import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_highlighter/themes/github.dart';
// import 'package:flutter_highlighter/themes/github.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/message.dart';
// import 'package:markdown_widget/markdown_widget.dart';
// import 'package:markdown_widget/widget/markdown.dart';

// ignore: must_be_immutable
class MessageBlock extends StatelessWidget {
  MessageModel message;
  MessageBlock({super.key, required this.message});

  MainAxisAlignment getMainAxisAligment() {
    if (message.role == SettingsController.to.chatGPTRoles.assistant) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }

  BorderRadiusGeometry getBorderRadius() {
    double radius = 14;
    if (message.role == SettingsController.to.chatGPTRoles.assistant) {
      return BorderRadius.only(
        topRight: Radius.circular(radius),
        topLeft: Radius.circular(radius),
        // bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        // bottomRight: Radius.circular(radius),
      );
    }
  }

  final messageGap = 15.0;
  double getMessageLeftSizedBoxWidth() {
    if (message.role == SettingsController.to.chatGPTRoles.user) {
      return messageGap;
    }
    return 0;
  }

  double getMessageRightSizedBoxWidth() {
    if (message.role == SettingsController.to.chatGPTRoles.user) {
      return 0;
    }
    return messageGap;
  }

  Color getMessageBackgroundColor(BuildContext context) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return Colors.black54;
    } else {
      return Colors.black12;
      // return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: getMainAxisAligment(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getMessageLeftSizedBoxWidth(),
          ),
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              // height: double.infinity,
              padding:
                  const EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
              decoration: BoxDecoration(
                color: getMessageBackgroundColor(context),
                borderRadius: getBorderRadius(),
              ),
              // child: Text(
              //   message.content,
              //   softWrap: true,
              //   textDirection: TextDirection.ltr,
              // ),
              child: Markdown(
                data: message.content.trim(),
                selectable: true,
                shrinkWrap: true,
                controller: ScrollController(),
                builders: {
                  'code': CodeElementBuilder(),
                },
                // child: MarkdownWidget(
                //   data: message.content.trim(),
                //   // tocController: TocController(),
                //   config: isDark
                //       ? MarkdownConfig.darkConfig
                //       : MarkdownConfig.defaultConfig,
                // ),
                // syntaxHighlighter: SyntaxHighlighter(),
                // styleSheet: MarkdownStyleSheet(
                //   code: const TextStyle(backgroundColor: Colors.transparent),
                // ),
                // syntaxHighlighter: ,
                // styleSheet: MarkdownStyleSheet(code: config),
                // extensionSet: md.ExtensionSet(
                //   md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                //   <md.InlineSyntax>[
                //     md.EmojiSyntax(),
                //     ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                //   ],
                // ),
              ),
            ),
          ),
          SizedBox(
            width: getMessageRightSizedBoxWidth(),
          ),
        ],
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(BuildContext context, md.Element element,
      TextStyle? preferredStyle, TextStyle? parentStyle) {
    // return super.visitElementAfterWithContext(context, element, preferredStyle, parentStyle);
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    // return SizedBox(child:,)
    return HighlightView(
      // The original code to be highlighted
      element.textContent,

      // Specify language
      // It is recommended to give it a value for performance
      language: language,

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      // theme: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
      //             .platformBrightness ==
      //         Brightness.light
      //     ? atomOneLightTheme
      //     : atomOneDarkTheme,
      theme: isDark ? atomOneDarkTheme : atomOneLightTheme,
      // theme: githubTheme,

      // Specify padding
      // padding: const EdgeInsets.all(8),

      // Specify text style
      textStyle: GoogleFonts.robotoMono(),
    );
  }
}