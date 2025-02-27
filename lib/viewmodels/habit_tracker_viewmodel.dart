import 'package:flutter/material.dart';
import '../model/habit/habit.dart';
import '../core/theme/space_theme.dart';

class HabitTrackerViewModel extends ChangeNotifier {
  final List<Habit> _habits = [
    Habit(
      id: '1',
      title: 'Diş Fırçalama',
      description: 'Günde iki kez dişlerini fırçala',
      icon: Icons.cleaning_services,
      color: SpaceTheme.accentBlue,
      xpReward: 10,
      targetPerDay: 2,
      currentProgress: 0,
    ),
    Habit(
      id: '2',
      title: 'Kitap Okuma',
      description: 'Her gün 30 dakika kitap oku',
      icon: Icons.book,
      color: SpaceTheme.accentPurple,
      xpReward: 20,
      targetPerDay: 1,
      currentProgress: 0,
    ),
    Habit(
      id: '3',
      title: 'Su İçme',
      description: 'Günde 8 bardak su iç',
      icon: Icons.water_drop,
      color: SpaceTheme.accentTurquoise,
      xpReward: 5,
      targetPerDay: 8,
      currentProgress: 0,
    ),
    Habit(
      id: '4',
      title: 'Egzersiz',
      description: 'Her gün 20 dakika egzersiz yap',
      icon: Icons.fitness_center,
      color: SpaceTheme.accentPink,
      xpReward: 25,
      targetPerDay: 1,
      currentProgress: 0,
    ),
  ];

  int _userLevel = 1;
  int _userXp = 0;
  int _xpToNextLevel = 100;
  String _currentAchievement = "Sihir Çırağı";
  bool _didLevelUp = false;
  final int _longestStreak = 7;
  String _todayProgress = "2/3"; 

  // Getters
  List<Habit> get habits => _habits;
  int get userLevel => _userLevel;
  int get userXp => _userXp;
  int get xpToNextLevel => _xpToNextLevel;
  String get currentAchievement => _currentAchievement;
  bool get didLevelUp => _didLevelUp;
  int get longestStreak => _longestStreak;
  String get todayProgress => _todayProgress;

  void completeHabit(Habit habit) {
    if (habit.currentProgress < habit.targetPerDay) {
      habit.currentProgress++;
      _userXp += habit.xpReward;
      _didLevelUp = false;
      
      if (_userXp >= _xpToNextLevel) {
        _userLevel++;
        _userXp = _userXp - _xpToNextLevel;
        _xpToNextLevel = (_xpToNextLevel * 1.5).round();
        _updateAchievement();
        _didLevelUp = true;
      }

      _updateTodayProgress();
      notifyListeners();
    }
  }

  void _updateAchievement() {
    if (_userLevel < 5) {
      _currentAchievement = "Sihir Çırağı";
    } else if (_userLevel < 10) {
      _currentAchievement = "Sihir Öğrencisi";
    } else if (_userLevel < 15) {
      _currentAchievement = "Yetenekli Büyücü";
    } else if (_userLevel < 20) {
      _currentAchievement = "Usta Büyücü";
    } else {
      _currentAchievement = "Büyü Lordu";
    }
  }

  void _updateTodayProgress() {
    int completed = _habits.where((h) => h.currentProgress > 0).length;
    _todayProgress = "$completed/${_habits.length}";
  }

  void resetHabits() {
    for (var habit in _habits) {
      habit.currentProgress = 0;
    }
    _updateTodayProgress();
    notifyListeners();
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    _updateTodayProgress();
    notifyListeners();
  }

  void removeHabit(String habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
    _updateTodayProgress();
    notifyListeners();
  }
} 