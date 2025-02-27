import 'package:flutter/material.dart';
import '../model/story/story_model.dart';
import '../service/story/story_service.dart';
import '../service/story/image_service.dart';

class StoryViewModel extends ChangeNotifier {
  final StoryService _storyService;
  final ImageService _imageService;

  String? selectedPlace;
  String? selectedCharacter;
  String? selectedTime;
  String? selectedEmotion;
  String? selectedEvent;

  bool isLoading = false;
  String? errorMessage;
  StoryModel? generatedStory;
  int _currentStep = 1;

  int get currentStep => _currentStep;

  StoryViewModel({
    StoryService? storyService,
    ImageService? imageService,
  })  : _storyService = storyService ?? StoryService(),
        _imageService = imageService ?? ImageService() {
    resetSelections();
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
    notifyListeners();
  }

  void goToNextStep() {
    if (_currentStep < 5) {
      _currentStep++;
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
      errorMessage = 'Lütfen tüm seçimleri yapın';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final story = await _storyService.generateStory(
        place: selectedPlace!,
        character: selectedCharacter!,
        time: selectedTime!,
        emotion: selectedEmotion!,
        event: selectedEvent!,
      );

      final image = await _imageService.generateImage(
        place: selectedPlace!,
        character: selectedCharacter!,
        event: selectedEvent!,
        title: story.title,
      );

      generatedStory = StoryModel(
        title: story.title,
        content: story.content,
        image: image,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
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
    notifyListeners();
  }
} 