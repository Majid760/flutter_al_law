import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final List<String> selectedList;
  final Function(List<String>) onServicesSaved;
  MultiSelectChip(this.reportList, this.selectedList, {this.onServicesSaved});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
        left: 48,
        right: 48,
      ),
      // height: 180,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Select services",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            children: widget.reportList
                .map((item) => Container(
                      padding: const EdgeInsets.all(2.0),
                      child: ChoiceChip(
                        label: Text(
                          item,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: widget.selectedList.contains(item) ? Colors.white : Colors.black,
                        ),
                        selectedColor: Colors.black,
                        selected: widget.selectedList.contains(item),
                        onSelected: (selected) {
                          setState(() {
                            widget.selectedList.contains(item)
                                ? widget.selectedList.remove(item)
                                : widget.selectedList.add(item);
                          });
                        },
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    // AuthController.to.signOut();
                    Navigator.of(context).pop();
                    widget.onServicesSaved(widget.selectedList);
                  },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
