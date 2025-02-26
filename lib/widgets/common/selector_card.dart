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
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: SpaceTheme.getCardDecoration(color),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: SpaceTheme.iconContainerDecoration,
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: SpaceTheme.cardTitleStyle.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: SpaceTheme.cardDescriptionStyle,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: SpaceTheme.primaryDark,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedValue,
                      hint: Text(
                        'Seçiniz',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      items: options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onChanged(value);
                        }
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      dropdownColor: color.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 