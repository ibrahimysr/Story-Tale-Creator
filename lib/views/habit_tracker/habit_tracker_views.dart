import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../widgets/habit/habit_header.dart';
import '../../widgets/habit/streak_overview.dart';
import '../../widgets/habit/habit_card.dart';
import '../../viewmodels/habit_tracker_viewmodel.dart';
import '../../model/habit/habit.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitTrackerViewModel(),
      child: const HabitTrackerView(),
    );
  }
}

class HabitTrackerView extends StatefulWidget {
  const HabitTrackerView({super.key});

  @override
  State<HabitTrackerView> createState() => _HabitTrackerViewState();
}

class _HabitTrackerViewState extends State<HabitTrackerView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showLevelUpDialog(BuildContext context, HabitTrackerViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: SpaceTheme.getCardDecoration(SpaceTheme.accentGold),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Seviye Atladın!",
                style: SpaceTheme.titleStyle,
              ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: SpaceTheme.avatarDecoration,
                child: Center(
                  child: Text(
                    "${viewModel.userLevel}",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Yeni seviye: ${viewModel.userLevel}",
                style: SpaceTheme.subtitleStyle,
              ),
              const SizedBox(height: 10),
              Text(
                "Yeni unvan: ${viewModel.currentAchievement}",
                style: SpaceTheme.subtitleStyle,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentGold),
                child: const Text("Harika!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHabitDetailsDialog(BuildContext context, Habit habit) {
    final viewModel = context.read<HabitTrackerViewModel>();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: SpaceTheme.getCardDecoration(habit.color),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                habit.title,
                style: SpaceTheme.titleStyle,
              ),
              const SizedBox(height: 20),
              Icon(
                habit.icon,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                habit.description,
                style: SpaceTheme.subtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Her tamamladığında: +${habit.xpReward} XP",
                style: SpaceTheme.subtitleStyle,
              ),
              const SizedBox(height: 20),
              Text(
                "İstatistikler",
                style: SpaceTheme.cardTitleStyle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Günlük İlerleme: ${habit.currentProgress}/${habit.targetPerDay}",
                style: SpaceTheme.subtitleStyle,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      viewModel.completeHabit(habit);
                      if (viewModel.didLevelUp) {
                        _showLevelUpDialog(context, viewModel);
                      }
                      Navigator.pop(context);
                    },
                    style: SpaceTheme.getMagicalButtonStyle(habit.color),
                    child:  Text("Tamamla",style:TextStyle(color: Colors.white) ,),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: SpaceTheme.getMagicalButtonStyle(habit.color.withValues(alpha:0.7)),
                    child: const Text("Kapat",style:TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const StarryBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HabitHeader(),
                const SizedBox(height: 20),
                Consumer<HabitTrackerViewModel>(
                  builder: (context, viewModel, child) {
                    return StreakOverview(
                      longestStreak: viewModel.longestStreak,
                      totalHabits: viewModel.habits.length,
                      todayProgress: viewModel.todayProgress,
                    );
                  },
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Consumer<HabitTrackerViewModel>(
                    builder: (context, viewModel, child) {
                      return ScaleTransition(
                        scale: _scaleAnimation,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: viewModel.habits.length,
                          itemBuilder: (context, index) {
                            final habit = viewModel.habits[index];
                            return HabitCard(
                              habit: habit,
                              onTap: () => _showHabitDetailsDialog(context, habit),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
     
    );
  }
}
