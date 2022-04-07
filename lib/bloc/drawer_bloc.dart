import 'package:bloc/bloc.dart';
import 'package:flutter_al_law/ui/drawer/cases_ui.dart';
import 'package:flutter_al_law/ui/drawer/drawer.dart';
import 'package:flutter_al_law/ui/drawer/schedules_ui.dart';

enum DrawerEvents {
  HomeEvent,
  ProfileEvent,
  SettingsEvent,
  CasesEvent,
  ClientsEvent,
  SchedulesEvent,
  EvidencesEvent,
  NotesEvent,
}

abstract class DrawerStates {}

class DrawerBloc extends Bloc<DrawerEvents, DrawerStates> {
  DrawerBloc(DrawerStates initialState) : super(initialState);

  // @override
  // DrawerStates get initialState => HomeUI();

  @override
  Stream<DrawerStates> mapEventToState(DrawerEvents event) async* {
    switch (event) {
      case DrawerEvents.HomeEvent:
        yield HomeUI();
        break;
      case DrawerEvents.ProfileEvent:
        yield ProfileUI();
        break;
      case DrawerEvents.SettingsEvent:
        yield SettingsUI();
        break;
      case DrawerEvents.CasesEvent:
        yield CasesUI();
        break;
      case DrawerEvents.ClientsEvent:
        yield ClientsUI();
        break;
      case DrawerEvents.SchedulesEvent:
        yield SchedulesUI();
        break;
      case DrawerEvents.EvidencesEvent:
        yield EvidencesUI();
        break;
      case DrawerEvents.NotesEvent:
        yield NotesUI();
        break;
    }
  }
}
