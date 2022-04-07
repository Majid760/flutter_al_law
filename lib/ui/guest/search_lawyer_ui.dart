import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/guest/search_lawyer_controller.dart';
import 'package:flutter_al_law/ui/guest/detailed_lawyer_ui.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/ui/guest/lawyers_list_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:flutter_al_law/utils/palettes.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/utils/extensions.dart';

class SearchLawyerUI extends StatelessWidget {
  const SearchLawyerUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        // style: BorderStyle.solid,
        color: Colors.black12,
        // width: 1.0,
      ),
    );
    return GetBuilder(
      init: SearchLawyerController(),
      builder: (SearchLawyerController controller) => Scaffold(
        backgroundColor: kAppBackgroundColorLight1,
        body: GestureDetector(
          onTap: () {
            Helpers.unFocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 85,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ClipPath(
                    clipper: CustomAppBarClipper(),
                    child: AppBar(
                      centerTitle: true,
                      title: Text(
                        'Find a Lawyer',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          constraints: BoxConstraints(),
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Material(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Lawyer name, Specialization...",
                                hintStyle: TextStyle(color: Colors.black38),
                                suffixIcon: controller.searchFieldController.text.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          controller.searchFieldController.clear();
                                          Helpers.unFocus();
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                      )
                                    : null,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black38,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                enabledBorder: _border,
                                focusedBorder: _border,
                                disabledBorder: _border,
                              ),
                              controller: controller.searchFieldController,
                              onSaved: (value) {},
                              onFieldSubmitted: (value) {},
                              onChanged: (value) {},
                              keyboardType: TextInputType.name,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                controller.searchFieldController.text.isNotEmpty &&
                        controller.selectedLawyers.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lawyers',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Helpers.unFocus();
                                controller.searchFieldController.clear();
                                Get.to(() => LawyersListUI());
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Material(
                  elevation: 1,
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.searchedLawyers.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          color: Colors.white,
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              Helpers.unFocus();
                              Get.to(() => DetailedLawyerUI(),
                                  arguments: controller.searchedLawyers[index]);
                              controller.searchFieldController.clear();
                            },
                            child: Container(
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 3, bottom: 2, top: 2),
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          controller.searchedLawyers[index].photoBlob != null
                                              ? new MemoryImage(
                                                  controller.searchedLawyers[index].photoBlob.bytes,
                                                )
                                              : AssetImage(
                                                  'lawyer_m'.png,
                                                ),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: highlightOccurrences(
                                              controller.searchedLawyers[index].name,
                                              controller.searchFieldController.text,
                                            ),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          controller.searchedLawyers[index].education ??
                                              "PhD, Criminal Law",
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // child: ListTile(
                            //   dense: true,
                            //   contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                            //   // tileColor: kWhiteColor,
                            //   // onTap: () {},
                            //   title: RichText(
                            //     text: TextSpan(
                            //       children: highlightOccurrences(
                            //         searchedCustomers[index].name,
                            //         _searchController.text,
                            //       ),
                            //       style: TextStyle(color: Colors.black87),
                            //     ),
                            //   ),
                            //   subtitle: RichText(
                            //     text: TextSpan(
                            //       children: highlightOccurrences(
                            //           searchedCustomers[index].id, _searchController.text),
                            //       style: TextStyle(color: Colors.grey, fontSize: 12),
                            //     ),
                            //   ),
                            // ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Search by specialty',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Get.to(() => LawyersListUI());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('family');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("family".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Family",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('corporate');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("corporate".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Corporate",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('civil');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("personal".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Civil",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('tax');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("tax".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Tax",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('criminal');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("criminal".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Criminal",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('cyber');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("bankruptcy".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Cyber",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('revenue');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("revenue".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Revenue",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Card(
                                elevation: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.onCategoryTap('copyright');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset("copyright".png),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Copyrights",
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('all');
                                },
                                child: Card(
                                  elevation: 1,
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      child: Text(
                                        "All Lawyers",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
