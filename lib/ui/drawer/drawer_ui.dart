import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/drawer/drawer.dart';
import 'package:flutter_al_law/ui/drawer/home_header.dart';
import 'package:flutter_al_law/ui/drawer/profile_header.dart';
import 'package:flutter_al_law/utils/palettes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DrawerLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: kAppBackgroundColorLight1,
          body: Column(
            children: <Widget>[
              BlocBuilder<DrawerBloc, DrawerStates>(
                builder: (context, DrawerStates state) {
                  return WillPopScope(
                    onWillPop: () {
                      if (state is! HomeUI) {
                        BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.HomeEvent);
                        return Future.value(false);
                      } else {
                        return Future.value(true);
                      }
                    },
                    child: CustomAppBar(
                      isBig: (state is ProfileUI),
                      height: (state is ProfileUI)
                          ? 140
                          : (state is HomeUI)
                              ? 285
                              : 90,
                      positionTop: (state is ProfileUI) ? 50 : 20,
                      title: findSelectedTitle(state),
                      trailing: IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        icon: Container(
                          child: Center(
                            child: Icon(Icons.menu),
                          ),
                        ),
                      ),
                      childHeight: 100,
                      child: (state is ProfileUI)
                          ? ProfileUIHeader()
                          : (state is HomeUI)
                              ? HomeUIHeader()
                              : null,
                    ),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<DrawerBloc, DrawerStates>(
                  builder: (context, DrawerStates state) {
                    return state as Widget;
                  },
                ),
              ),
            ],
          ),
          endDrawer: ClipPath(
            clipper: _DrawerClipper(),
            child: Drawer(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 48, bottom: 32),
                  height: (orientation == Orientation.portrait)
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(Icons.keyboard_backspace),
                        ),
                      ),
                      DrawerItem(
                        text: "Home",
                        icon: Icons.home_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.HomeEvent);
                        },
                      ),
                      DrawerItem(
                        text: "Clients",
                        icon: Icons.supervisor_account_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.ClientsEvent);
                        },
                      ),
                      DrawerItem(
                        text: "Cases",
                        icon: Icons.book_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.CasesEvent);
                        },
                      ),
                      DrawerItem(
                        text: "Schedule",
                        icon: Icons.schedule_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.SchedulesEvent);
                        },
                      ),
                      // DrawerItem(
                      //   text: "Evidence",
                      //   icon: Icons.saved_search_outlined,
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.EvidencesEvent);
                      //   },
                      // ),
                      DrawerItem(
                        text: "Notes",
                        icon: Icons.sticky_note_2_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.NotesEvent);
                        },
                      ),
                      DrawerItem(
                        text: "Profile",
                        icon: Icons.person_outline,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.ProfileEvent);
                        },
                      ),
                      DrawerItem(
                        text: "Settings",
                        icon: Icons.settings_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<DrawerBloc>(context).add(DrawerEvents.SettingsEvent);
                        },
                      ),
                      DrawerItem(
                        text: "Sign out",
                        icon: Icons.logout,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _openSignOutDrawer(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Divider(
                          color: Colors.black54,
                        ),
                      ),
                      DrawerItem(
                        text: "Privacy",
                        icon: Icons.privacy_tip_outlined,
                        onPressed: () {},
                      ),
                      DrawerItem(
                        text: "About Us",
                        icon: Icons.error_outline,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String findSelectedTitle(DrawerStates state) {
    if (state is HomeUI) {
      return 'Home';
    } else if (state is ProfileUI) {
      return "User Profile";
    } else if (state is SettingsUI) {
      return 'Settings';
    } else if (state is CasesUI) {
      return 'Cases';
    } else if (state is ClientsUI) {
      return 'Clients';
    } else if (state is SchedulesUI) {
      return 'Schedules';
    } else if (state is EvidencesUI) {
      return 'Evidences';
    } else if (state is NotesUI) {
      return 'Notes';
    } else {
      return 'Notes';
    }
  }

  void _openSignOutDrawer(BuildContext context) {
    showModalBottomSheet(
        shape: BottomSheetShape(),
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 16,
              left: 48,
              right: 48,
            ),
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Are you sure you want to sign out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          AuthController.to.signOut();
                        },
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Text(
                          'Sign Out',
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
                      child: OutlineButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        borderSide: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Stay",
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
        });
  }
}

class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(50, 0);
    path.quadraticBezierTo(0, size.height / 2, 50, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
