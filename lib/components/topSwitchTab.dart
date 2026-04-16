import 'package:flutter/material.dart';

class TopSwitchTab extends StatelessWidget {
  final bool isLeftSelected;
  final Function(bool) onChanged;
  final String leftText;
  final String rightText;
  final IconData leftIcon;
  final IconData rightIcon;
  final Color leftColor;
  final Color rightColor;

  const TopSwitchTab({
    super.key,
    required this.isLeftSelected,
    required this.onChanged,
    this.leftText = "Hoạt động",
    this.rightText = "Thống kê",
    this.leftIcon = Icons.access_time,
    this.rightIcon = Icons.attach_money,
    this.leftColor = Colors.pinkAccent,
    this.rightColor = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          /// LEFT TAB
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isLeftSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isLeftSelected
                      ? [BoxShadow(color: Colors.black12, blurRadius: 5)]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(leftIcon, color: leftColor),
                    const SizedBox(width: 6),
                    Text(
                      leftText,
                      style: TextStyle(
                        color: leftColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// RIGHT TAB
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isLeftSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: !isLeftSelected
                      ? [BoxShadow(color: Colors.black12, blurRadius: 5)]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(rightIcon, color: rightColor),
                    const SizedBox(width: 6),
                    Text(
                      rightText,
                      style: TextStyle(
                        color: rightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
