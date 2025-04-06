import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/viewmodels/locale_provider.dart';
import '../model/story/story_model.dart';
import '../service/story/story_service.dart';
import '../service/story/image_service.dart';
import '../service/story/story_options_service.dart';
import '../../repository/story_options_repository.dart';

class StoryViewModel extends ChangeNotifier {
  final StoryService _storyService;
  final ImageService _imageService;
  final StoryOptionsService _optionsService;
  final LocaleProvider _localeProvider;

  CategoryOptions _placesData = CategoryOptions(en: [], tr: []);
  CategoryOptions _charactersData = CategoryOptions(en: [], tr: []);
  CategoryOptions _timesData = CategoryOptions(en: [], tr: []);
  CategoryOptions _emotionsData = CategoryOptions(en: [], tr: []);
  CategoryOptions _eventsData = CategoryOptions(en: [], tr: []);

  String? _selectedPlaceEn;
  String? _selectedCharacterEn;
  String? _selectedTimeEn;
  String? _selectedEmotionEn;
  String? _selectedEventEn;

  String? selectedPlace;
  String? selectedCharacter;
  String? selectedTime;
  String? selectedEmotion;
  String? selectedEvent;

  List<String> places = [];
  List<String> characters = [];
  List<String> times = [];
  List<String> emotions = [];
  List<String> events = [];

  bool isLoading = false;
  bool _isLoadingCategories = true;
  bool _isCancelled = false;
  String? errorMessage;
  StoryModel? generatedStory;
  int _currentStep = 1;

  int get currentStep => _currentStep;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isCancelled => _isCancelled;

  StoryViewModel({
    StoryService? storyService,
    ImageService? imageService,
    StoryOptionsService? optionsService,
    required LocaleProvider localeProvider,
  })  : _storyService = storyService ?? StoryService(),
        _imageService = imageService ?? ImageService(),
        _optionsService = optionsService ?? StoryOptionsService(),
        _localeProvider = localeProvider {
    _localeProvider.addListener(_updateDisplayOptions);
    resetSelections();
    loadCategories();
  }

  @override
  void dispose() {
    _localeProvider.removeListener(_updateDisplayOptions);
    super.dispose();
  }

  Future<void> loadCategories() async {
    try {
      _isLoadingCategories = true;
      errorMessage = null;
      notifyListeners();

      _placesData = await _optionsService.getPlaces();
      _charactersData = await _optionsService.getCharacters();
      _timesData = await _optionsService.getTimes();
      _emotionsData = await _optionsService.getEmotions();
      _eventsData = await _optionsService.getEvents();

      _updateDisplayOptions();

      _isLoadingCategories = false;
    } catch (e) {
      _isLoadingCategories = false;
      errorMessage = 'Kategoriler yüklenirken bir hata oluştu: $e';
      notifyListeners();
    }
  }

  void _updateDisplayOptions() {
    final langCode = _localeProvider.locale.languageCode;

    places = _placesData.getOptions(langCode);
    characters = _charactersData.getOptions(langCode);
    times = _timesData.getOptions(langCode);
    emotions = _emotionsData.getOptions(langCode);
    events = _eventsData.getOptions(langCode);

    if (selectedPlace != null && !places.contains(selectedPlace)) {
      selectedPlace = null;
      _selectedPlaceEn = null;
    }

    notifyListeners();
  }

  void resetSelections() {
    selectedPlace = null;
    selectedCharacter = null;
    selectedTime = null;
    selectedEmotion = null;
    selectedEvent = null;

    _selectedPlaceEn = null;
    _selectedCharacterEn = null;
    _selectedTimeEn = null;
    _selectedEmotionEn = null;
    _selectedEventEn = null;

    generatedStory = null;
    errorMessage = null;
    isLoading = false;
    _currentStep = 1;
    _isCancelled = false;

    _updateDisplayOptions();
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
    if (place != null) {
      selectedPlace = place;
      _selectedPlaceEn = _placesData.findEnglishEquivalent(place);
    }
    if (character != null) {
      selectedCharacter = character;
      _selectedCharacterEn = _charactersData.findEnglishEquivalent(character);
    }
    if (time != null) {
      selectedTime = time;
      _selectedTimeEn = _timesData.findEnglishEquivalent(time);
    }
    if (emotion != null) {
      selectedEmotion = emotion;
      _selectedEmotionEn = _emotionsData.findEnglishEquivalent(emotion);
    }
    if (event != null) {
      selectedEvent = event;
      _selectedEventEn = _eventsData.findEnglishEquivalent(event);
    }
    notifyListeners();
  }

  bool get canGenerateStory {
    return _selectedPlaceEn != null &&
        _selectedCharacterEn != null &&
        _selectedTimeEn != null &&
        _selectedEmotionEn != null &&
        _selectedEventEn != null;
  }

  Future<void> generateStory(BuildContext context) async {
    if (!canGenerateStory) {
      List<String> missing = [];
      if (_selectedPlaceEn == null) missing.add("Mekan (Place)");
      if (_selectedCharacterEn == null) missing.add("Karakter (Character)");
      if (_selectedTimeEn == null) missing.add("Zaman (Time)");
      if (_selectedEmotionEn == null) missing.add("Duygu (Emotion)");
      if (_selectedEventEn == null) missing.add("Olay (Event)");

      errorMessage = context.localizations.incomplete_selection(missing.join(', '));

      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      _isCancelled = false;
      errorMessage = null;
      notifyListeners();
      final langCode = _localeProvider.locale.languageCode;

      final story = await _storyService.generateStory(
        place: selectedPlace!,
        character: selectedCharacter!,
        time: selectedTime!,
        emotion: selectedEmotion!,
        event: selectedEvent!,
        languageCode: langCode,
      );

      if (_isCancelled) return;

      final image = await _imageService.generateImage(
        place: _selectedPlaceEn!,
        character: _selectedCharacterEn!,
        event: _selectedEventEn!,
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
     notifyListeners();
    }
  }

  void cancelStoryGeneration() {
    _isCancelled = true;
    isLoading = false;
    notifyListeners();
  }

  void reset() {
    resetSelections();
  }
}
