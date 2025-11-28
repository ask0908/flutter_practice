import 'package:dio/dio.dart';
import 'package:flutter_practice/model/user_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("/users")
  Future<List<UserDto>> getUsers();
}