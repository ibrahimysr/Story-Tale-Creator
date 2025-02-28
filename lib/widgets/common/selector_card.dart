import 'package:flutter/material.dart';
import '../../core/theme/space_theme.dart';

class SelectorCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> options;
  final String? selectedValue;
  final Function(String) onChanged;

  const SelectorCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedValue;
          
          return GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              decoration: BoxDecoration(
                gradient: isSelected 
                  ? SpaceTheme.getMagicalGradient(color)
                  : LinearGradient(
                      colors: [
                        color.withValues(alpha:0.2),
                        color.withValues(alpha:0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected 
                    ? Colors.white.withValues(alpha:0.5)
                    : Colors.white.withValues(alpha:0.1),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected 
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha:0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
              ),
              child: Stack(
                children: [
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha:0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: color,
                        ),
                      ),
                    ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: Colors.white.withValues(alpha:isSelected ? 1 : 0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 