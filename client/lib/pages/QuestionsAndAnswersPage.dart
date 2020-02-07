import 'package:flutter/material.dart';

class QuestionsAndAnswersPage extends StatelessWidget {
  final Map<String, String> questionsAndAnswersMap = {
    'How are ratings calcualted?': 'Ratings for each library are based on the ' +
        'average ratings of it\'s floors; Ratings for floors are based on ' +
        'the average of user submitted records of the floor, ' +
        'or the average of it\s subsections if they exist; Ratings for ' +
        'subsections are the average of user submitted records of the subsection',
    'What do the ratings mean': 'Ratings are scaled from 0 to 10, where ' +
        '0 means there are no one in the area, 10 means the area is full.',
    'How often are data updated?': 'Ratings are auto updated every 5 minutes.'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Q&A'),
      ),
      body: ListView(
        children: questionsAndAnswersMap.entries
            .map(
              (e) => Padding(
                  padding: EdgeInsets.only(
                    top: 7,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(e.key),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 7),
                        child: Text(e.value),
                      ),
                      Divider(
                        color: Theme.of(context).backgroundColor,
                      ),
                    ],
                  )),
            )
            .toList(),
      ),
    );
  }
}
