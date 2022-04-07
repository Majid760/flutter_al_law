import 'package:flutter/material.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/utils/date_time_utils.dart';

class SingleCaseCard extends StatelessWidget {
  final CaseModel singleCase;
  final VoidCallback onTap;
  final bool searching;
  final String searchFieldText;

  const SingleCaseCard({this.singleCase, this.onTap, this.searching = false, this.searchFieldText});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: highlightOccurrences(
                                singleCase.caseName,
                                searchFieldText,
                              ),
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            singleCase.courtCity == null ? '' : ' (${singleCase.courtCity})',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      // Text(singleCase.judgeName ?? ''),
                      RichText(
                        text: TextSpan(
                          children: highlightOccurrences(
                            singleCase.judgeName,
                            searchFieldText,
                          ),
                          style: new TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_right,
              size: 28,
              color: Colors.black54,
            ),
            SizedBox(
              width: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      singleCase.caseDate != null ? dateFormat2.format(singleCase.caseDate) : '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'OPEN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}
