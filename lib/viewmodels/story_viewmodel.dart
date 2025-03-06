import 'package:flutter/material.dart';
import '../model/story/story_model.dart';
import '../service/story/story_service.dart';
import '../service/story/image_service.dart';
import '../service/story/story_options_service.dart';

class StoryViewModel extends ChangeNotifier {
  final StoryService _storyService;
  final ImageService _imageService;
  final StoryOptionsService _optionsService;

  String? selectedPlace;
  String? selectedCharacter;
  String? selectedTime;
  String? selectedEmotion;
  String? selectedEvent;

  bool isLoading = false;
  bool _isLoadingCategories = true;
  bool _isCancelled = false; 
  String? errorMessage;
  StoryModel? generatedStory;
  int _currentStep = 1;

  List<String> places = [];
  List<String> characters = [];
  List<String> times = [];
  List<String> emotions = [];
  List<String> events = [];

  Map<String, String> placeTranslations = {};
  Map<String, String> characterTranslations = {};
  Map<String, String> eventTranslations = {};

  int get currentStep => _currentStep;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isCancelled => _isCancelled;

  StoryViewModel({
    StoryService? storyService,
    ImageService? imageService,
    StoryOptionsService? optionsService,
  })  : _storyService = storyService ?? StoryService(),
        _imageService = imageService ?? ImageService(),
        _optionsService = optionsService ?? StoryOptionsService() {
    resetSelections();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      _isLoadingCategories = true;
      errorMessage = null;
      notifyListeners();

      places = await _optionsService.getPlaces();
      characters = await _optionsService.getCharacters();
      times = await _optionsService.getTimes();
      emotions = await _optionsService.getEmotions();
      events = await _optionsService.getEvents();

      placeTranslations = await _optionsService.getPlaceTranslations();
      characterTranslations = await _optionsService.getCharacterTranslations();
      eventTranslations = await _optionsService.getEventTranslations();

      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCategories = false;
      errorMessage = 'Kategoriler yüklenirken bir hata oluştu: $e';
      notifyListeners();
    }
  }

  void resetSelections() {
    selectedPlace = null;
    selectedCharacter = null;
    selectedTime = null;
    selectedEmotion = null;
    selectedEvent = null;
    generatedStory = null;
    errorMessage = null;
    isLoading = false;
    _currentStep = 1;
    _isCancelled = false; 
    notifyListeners();
  }

  void goToNextStep() {
    if (_currentStep < 5) {
      _currentStep++;
      notifyListeners();
    }
  }

  void goToPreviousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  void updateSelection({
    String? place,
    String? character,
    String? time,
    String? emotion,
    String? event,
  }) {
    selectedPlace = place ?? selectedPlace;
    selectedCharacter = character ?? selectedCharacter;
    selectedTime = time ?? selectedTime;
    selectedEmotion = emotion ?? selectedEmotion;
    selectedEvent = event ?? selectedEvent;
    notifyListeners();
  }

  bool get canGenerateStory {
    return selectedPlace != null &&
        selectedCharacter != null &&
        selectedTime != null &&
        selectedEmotion != null &&
        selectedEvent != null;
  }

  Future<void> generateStory() async {
    if (!canGenerateStory) {
      errorMessage = 'Lütfen tüm seçimleri yapın.';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      _isCancelled = false; 
      errorMessage = null;
      notifyListeners();

      final story = await _storyService.generateStory(
        place: selectedPlace!,
        character: selectedCharacter!,
        time: selectedTime!,
        emotion: selectedEmotion!,
        event: selectedEvent!,
      );

      if (_isCancelled) return; 

      final image = await _imageService.generateImage(
        place: placeTranslations[selectedPlace!] ?? selectedPlace!,
        character: characterTranslations[selectedCharacter!] ?? selectedCharacter!,
        event: eventTranslations[selectedEvent!] ?? selectedEvent!,
        title: story.title,
      );

      if (_isCancelled) return; 

      generatedStory = StoryModel(
        title: story.title,
        content: story.content,
        image: image,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (_isCancelled) return; 
      isLoading = false;
      String error = e.toString().replaceFirst('Exception: ', '');

      if (error.contains('Görsel oluşturulamadı')) {
        errorMessage = '$error\nBu sorunun çözümü için destek ekibinden yardım alabilirsiniz.';
      } else if (error.contains('Çok fazla istek')) {
        errorMessage = error;
      } else if (error.contains('API anahtarı geçersiz')) {
        errorMessage = error;
      } else if (error.contains('Hikaye oluşturulamadı')) {
        errorMessage = error;
      } else {
        errorMessage = 'Hikaye veya görsel oluşturulurken bir hata oluştu: $error\nLütfen tekrar deneyin veya destek ekibinden yardım alın.';
      }
      notifyListeners();
    }
  }

  void cancelStoryGeneration() {
    _isCancelled = true;
    isLoading = false;
    notifyListeners();
  }

  void reset() {
    selectedPlace = null;
    selectedCharacter = null;
    selectedTime = null;
    selectedEmotion = null;
    selectedEvent = null;
    generatedStory = null;
    errorMessage = null;
    isLoading = false;
    _isCancelled = false; 
    notifyListeners();
  }
}