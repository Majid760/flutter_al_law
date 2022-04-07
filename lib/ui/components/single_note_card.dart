import 'package:flutter/material.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/utils/date_time_utils.dart';

class SingleNoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;

  const SingleNoteCard({this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              child: Container(
                color: Colors.cyan,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      note.dateTime != null ? dateFormat2.format(note.dateTime) : '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      note.dateTime != null ? timeFormat.format(note.dateTime) : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      Text(
                        note.title ?? '',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        note.detail ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
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
          ],
        ),
      ),
    );
  }
}
