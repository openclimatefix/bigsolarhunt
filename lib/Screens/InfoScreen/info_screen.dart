import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'InfoScreenWidgets/image_card.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    Key key,
  }) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Container(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                      text: 'About Solar Streets',
                      style: Theme.of(context).textTheme.headline5),
                  TextSpan(
                      text: '\n\n\nSolar Streets is a collaboration between '),
                  TextSpan(
                      text: 'Open Climate Fix',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.lightBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://openclimatefix.org/');
                        }),
                  TextSpan(text: ' and '),
                  TextSpan(
                      text: 'another charity',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.lightBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://openclimatefix.org/');
                        }),
                  TextSpan(
                      text:
                          '.\n\nWe are trying to produce a detailed dataset of solar panels in the UK. This dataset will be open and free for the public to use.'),
                  TextSpan(
                      text: '\n\n\nHow can you help?',
                      style: Theme.of(context).textTheme.headline6),
                  TextSpan(
                      text:
                          '\n\nEvery time you see a solar panel when you are out and about take a picture of it, mark its position on the map and hit upload. This is what they look like:'),
                ]),
          )),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: ImageCard(image: AssetImage('assets/example_solar.jpg')),
      ),
      Container(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                    text:
                        'Solar panels are generally located on the roofs of houses, so remember to look up!',
                  ),
                  TextSpan(
                      text:
                          '\n\nLegally you are allowed to take pictures from public spaces. So taking pictures of solar panels from the road or pavement is ok, but please be considerate when doing this. If you do catch someone in your photo, don’t worry. All uploaded picture will automatically blur out faces if they are in the picture.'),
                  TextSpan(
                      text: '\n\n\nWhy is this important?',
                      style: Theme.of(context).textTheme.headline6),
                  TextSpan(
                      text:
                          '\n\nThis is part of a wider project to cut CO\u2082 emissions when producing electricity.\n\nRight now we are not able to accurately predict the amount of energy that will be produced by solar panels at any moment. Because of this the people who run our electric grid need to have backup generators running, to avoid blackouts incase solar generation gets too low. Most these backup generators are powered by fossil fuels. So even if we have lots of solar panels installed, we still need to rely on non-renewable generators.\n\nHowever if we could predict solar generation better we would not have to rely on these backup generators as much. To get better predictions we need data about where solar panels are located. The more data there is the better the predictions will get.\n\nCurrently there is no comprehensive dataset of all the solar panels in the UK. This is why we need your help. Every time a solar panel is added to the dataset the predictions get better and we can rely on the backup generators less.'),
                  TextSpan(
                      text: '\n\n\nWhat is happening to the pictures?',
                      style: Theme.of(context).textTheme.headline6),
                  TextSpan(text: '\n\nThe pictures are uploaded to '),
                  TextSpan(
                      text: 'Mapillary',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.lightBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://www.mapillary.com/app/');
                        }),
                  TextSpan(
                      text:
                          ', an open database of street-view pictures. The pictures will then be processed and the size and orientation of the panels will be captured. This data will then be entered into '),
                  TextSpan(
                      text: 'Open Street Map',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.lightBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                              'https://www.openstreetmap.org/#map=5/54.021/-4.966');
                        }),
                  TextSpan(
                      text:
                          ' another open database for geographical data. If you would like to access the data you simply need to go onto Open Street Map and run a search for solar panels.')
                ]),
          )),
      Padding(
        padding: const EdgeInsets.all(42.0),
      )
    ]));
  }
}
