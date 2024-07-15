import 'package:newsapp/core/config/service_locator.dart';
import 'package:newsapp/model/handling.dart';

import 'package:newsapp/model/login_model.dart';
import 'package:newsapp/service/core_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthService extends CoreSerivce {
  String baseurl = 'https://dummyjson.com/auth/login';
  Future<ResultModel> logIn(UserModel user);
}

class AuthServiceImp extends AuthService {
  @override
  Future<ResultModel> logIn(UserModel user) async {
    try {
      response = await dio.post(baseurl, data: user.toMap());
      if (response.statusCode == 200) {
        core
            .get<SharedPreferences>()
            .setString("token", response.data['token']);
        return DataSuccess();
      } else {
        return DataError();
      }
    } catch (e) {
      return DataError();
    }
  }
}
