import 'dart:io';
import 'package:dio/dio.dart';
import '../../../app/utils/app_strings.dart';


class ApiExceptions {

  static String getDioException(error) {
    String? message;
    if (error is Exception) {
      try {
        if(error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              break;
            case DioErrorType.connectionTimeout:
              message = AppStrings.sendTimeout;
              break;
            case DioErrorType.receiveTimeout:
              message = AppStrings.receiveTimeout;
            case DioErrorType.badResponse:
              switch(error.response?.statusCode) {
                case 400:
                  if(error.response != null && error.response!.data != null) {
                    return message = error.response!.data['message'];
                  }
                  break;
                case 401:
                  break;
                case 403:
                  message = AppStrings.unauthorisedRequest;
                  break;
                case 404:
                  message = error.response?.data['message'].toString() ?? AppStrings.notFound;
                  break;
                case 408:
                  message = AppStrings.requestCancelled;
                  break;
                case 409:
                  message = AppStrings.conflict;
                  break;
                case 422:
                  message = error.response?.data['message'].toString() ?? AppStrings.validationError;
                  break;
                case 500:
                  message = AppStrings.internalServerError;
                  break;
                case 503:
                  message = AppStrings.serviceUnavailable;
                  break;
                default:
                  message = error.message;
                  break;
              }
              break;
            case DioErrorType.sendTimeout:
              message = AppStrings.sendTimeout;
              break;
            case DioErrorType.connectionError:
              message = "No Internet Error";
              break;
            case DioErrorType.badCertificate:
              message = AppStrings.badCertificate;
              break;
            case DioErrorType.unknown:
              message = AppStrings.unexpectedError;
              break;
          }
        } else if (error is SocketException) {
          message = AppStrings.noInternetConnection;
        } else {
          message = AppStrings.unexpectedError;
        }
        return message!;
      } on FormatException catch (e) {
        return AppStrings.formatException;
      } catch (_){
        return AppStrings.unexpectedError;
      }
    } else {
      if(error.toString().contains("is not a subtype of")) {
        return AppStrings.unableProcess;
      } else {
        return AppStrings.unexpectedError;
      }
    }
  }


}