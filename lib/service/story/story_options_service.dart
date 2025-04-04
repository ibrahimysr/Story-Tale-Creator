import '../../repository/story_options_repository.dart';

class StoryOptionsService {
  final StoryOptionsRepository _repository;

  StoryOptionsService({StoryOptionsRepository? repository})
      : _repository = repository ?? StoryOptionsRepository();

  Future<CategoryOptions> getPlaces() async {
    return await _repository.getPlaces();
  }

  Future<CategoryOptions> getCharacters() async {
    return await _repository.getCharacters();
  }

  Future<CategoryOptions> getTimes() async {
    return await _repository.getTimes();
  }

  Future<CategoryOptions> getEmotions() async {
    return await _repository.getEmotions();
  }

  Future<CategoryOptions> getEvents() async {
    return await _repository.getEvents();
  }
}