import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:solar_streets/Screens/InfoScreen/InfoScreenWidgets/bullet.dart';
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
                      text:
                          '\n\n\nThe UK has about 1 million rooftop solar installations. As well as feeding power directly into homes, these panels supply power back into the national grid when buildings can’t use all the power they’re producing. This is a good thing, because it means we can share clean energy around and reduce carbon emissions to tackle climate change.\n\nThing is: no-one knows exactly where all these solar panels are. This means that it’s difficult for National Grid to predict when and where there will be surges in solar power. In order to keep the power system stable, power stations currently have to be kept running in the background - burning fossil fuels. If, instead, we knew exactly where panels were, we could use short-term weather forecasts to anticipate solar power much better, and turn down those dirty power stations.'),
                  TextSpan(
                    text:
                        '\n\nPut simply - if we knew where the nation’s rooftop panels were, we could make better use of them - saving around 100,000 tonnes of carbon each year.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '\n\nThis is where you come in. '),
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
                      text: 'Possible',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.lightBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://www.wearepossible.org/)');
                        }),
                  TextSpan(
                    text:
                        ' have teamed up to create the Solar Streets app, so that with the help of individuals and communities across the country we can produce the most detailed dataset of solar panels in the UK. The dataset we create will be “open” - completely free for the public to use.',
                  ),
                  TextSpan(
                      text: '\n\n\nI’m in - how can I help?',
                      style: Theme.of(context).textTheme.headline6),
                  TextSpan(
                      text:
                          '\n\nEvery time you see a solar panel when you are out and about, take a picture of it, mark its position on the map and hit upload. Simple.\n\nThis is what they look like:'),
                ]),
          )),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: ImageCard(image: AssetImage('assets/example_solar.jpg')),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: 'Things to consider:\n',
              ),
            ],
          ),
        ),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(30, 0, 16, 0),
          child: BulletPoints([
            'Solar panels are generally located on the roofs of houses, so remember to look up.',
            'Taking pictures of solar panels on somebody’s house from the road or pavement is perfectly legal, but please be considerate of people’s privacy when doing this.',
            'If you do catch someone in your photo, don’t worry. All uploaded pictures will automatically blur out faces if they are in the picture.',
          ])),
      Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                      text: '\n\n\nTell me more',
                      style: Theme.of(context).textTheme.headline6),
                  TextSpan(
                      text:
                          '\n\nThis is part of a wider project to tackle the UK’s hefty carbon footprint. Open Climate Fix are dedicated to using computer science and machine learning to tackle climate change. Because finding all these panels means looking for a million rooftops, they plan to teach a computer how to recognise solar installations from aerial photographs. But in order to teach the computer you need lots of examples for it to learn from.\n\nThat means manually locating solar panels on rooftops in the world around us - so the computer can learn what they look like. By collaborating with the '),
                  TextSpan(
                      text: 'OpenStreetMap',
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
                        ' community, already 10% of UK panels have been mapped! But to create a really powerful computer solar panel hunter, we need to try and double that. At that point, the machines can take over and find the remaining 80% without anyone lifting a finger.',
                  ),
                  TextSpan(
                    text:
                        '\n\nAnd it doesn’t stop there, once we’ve got this working it can be used to map panels all around the world - providing data to help clean energy push out dirty fossil fuels.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                          ', an open database of street-view pictures. The pictures will then be processed and the size and orientation of the panels will be captured. This data will then be entered into OpenStreetMap, an open database for geographical data. If you would like to access the data you simply need to go onto OpenStreetMap and run a search for solar panels.\n\nMapillary stores the pictures, and uses them for automatically detecting map features. Your pictures will be publicly available on the Mapillary platform. However, the photos won’t be on OpenStreetMap - that’s just the map data, so that will just have the solar panel locations and other details.'),
                ]),
          )),
      Padding(
        padding: const EdgeInsets.all(42.0),
      )
    ]));
  }
}
