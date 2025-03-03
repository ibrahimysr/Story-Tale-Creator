import '../../repository/story_options_repository.dart';

class StoryOptionsService {
  final StoryOptionsRepository _repository;

  StoryOptionsService({StoryOptionsRepository? repository})
      : _repository = repository ?? StoryOptionsRepository();

 
  Future<List<String>> getPlaces() async {
    return await _repository.getPlaces();
  }

  Future<List<String>> getCharacters() async {
    return await _repository.getCharacters();
  }

  Future<List<String>> getTimes() async {
    return await _repository.getTimes();
  }

  Future<List<String>> getEmotions() async {
    return await _repository.getEmotions();
  }

  Future<List<String>> getEvents() async {
    return await _repository.getEvents();
  }

  Future<Map<String, String>> getPlaceTranslations() async {
    return await _repository.getPlaceTranslations();
  }

  Future<Map<String, String>> getCharacterTranslations() async {
    return await _repository.getCharacterTranslations();
  }

  Future<Map<String, String>> getEventTranslations() async {
    return await _repository.getEventTranslations();
  }
} 