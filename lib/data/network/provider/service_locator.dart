import 'package:get_it/get_it.dart';
import '../../datasources/remote_data_source.dart';
import '../../repos/app_repository.dart';

final locator=GetIt.instance;


void initServiceLocator(){
  locator.registerSingleton(AppRepository(appDataSource: RemoteDataSource()));
}