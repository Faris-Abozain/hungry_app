import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    if(statusCode!=null) {
      if (data is Map<String, dynamic> && data['message'] != null) {
        return ApiError(message: data['message'], statusCode: statusCode);
      }
    }

    if(statusCode == 302){
      throw ApiError(message: 'This Email Is Already Taken');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(
          message: "Connection Timeout Please Check Your Internet Connection",
        );
      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request Timeout. Please Try Again");
      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Response Timeout. Please Try Again");
      default:
        return ApiError(
          message: "An Unexpected Error Occurred. Please Try Again",
        );
    }
  }
}