/// Functions for handling copy written in markdown.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

/// Widget which reads in .md file defined via [mdfile] and display it as
/// scrollable text.
class ScrollableTextFromMdFile extends StatelessWidget {
  final String mdfile;

  const ScrollableTextFromMdFile({Key key, @required this.mdfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(mdfile),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return fmd.Markdown(
              data: snapshot.data,
              selectable: true,
              onTapLink: (text, href, title) => launch(href),
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                [
                  md.EmojiSyntax(),
                  ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

/// Widget which reads in .md file as text and display it as non-scrollable text.
class BodyTextFromMdFile extends StatelessWidget {
  final String mdfile;

  const BodyTextFromMdFile({Key key, @required this.mdfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString(mdfile),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return fmd.MarkdownBody(
                  data: snapshot.data,
                  extensionSet: md.ExtensionSet(
                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                    [
                      md.EmojiSyntax(),
                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
