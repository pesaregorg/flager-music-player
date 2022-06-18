import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flager_player/services/audio_handler.dart';
import 'package:flager_player/utilities/page_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PageManager>(() => PageManager());

}