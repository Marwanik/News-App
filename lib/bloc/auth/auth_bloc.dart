import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/core/config/service_locator.dart';
import 'package:newsapp/model/handling.dart';
import 'package:newsapp/model/login_model.dart';
import 'package:newsapp/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LogIn>(
          (event, emit) async {
        core.get<SharedPreferences>().setString('data', event.user.toJson());
        ResultModel result = await AuthServiceImp().logIn(event.user);
        if (result is DataSuccess) {
          emit(SuccessToLogIn());
        } else {
          emit(FailedToLogIn());
        }
      },
    );
  }
}
