import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/config/service_locator.dart';
import 'package:newsapp/model/handling.dart';
import 'package:newsapp/model/login_model.dart';
import 'package:newsapp/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

// Define the events
part 'app_manger_event.dart';

// Define the states
part 'app_manger_state.dart';

class AppManagerBloc extends Bloc<AppManagerEvent, AppManagerState> {
  AppManagerBloc() : super(AppInitial()) {
    on<CheckAuthorized>((event, emit) {
      if (core.get<SharedPreferences>().getString('token') == null ||
          core.get<SharedPreferences>().getString('token') == '') {
        emit(NavigateToLoginPage());
      } else {
        emit(NavigateToHomePage());
      }
    });

    on<HeLoggedIn>((event, emit) {
      emit(NavigateToHomePage());
    });

    on<HeLoggedOut>((event, emit) {
      core.get<SharedPreferences>().setString('token', '');
      emit(NavigateToLoginPage());
    });

    on<HeFailedToLoggedIn>((event, emit) => emit(NavigateToOffline()));

    on<RestoreToLogIn>((event, emit) => emit(NavigateToLoginPage()));

    on<LogOut>((event, emit) {
      core.get<SharedPreferences>().setString('token', '');
      emit(NavigateToLoginPage());
    });

    on<ExcuteLastRequest>((event, emit) async {
      ResultModel result = await AuthServiceImp().logIn(
          UserModel.fromJson(core.get<SharedPreferences>().getString('data')!));
      if (result is DataSuccess) {
        emit(NavigateToHomePage());
      } else {
        emit(NavigateToOffline());
      }
    });
  }
}
