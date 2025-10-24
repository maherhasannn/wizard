import 'package:flutter/material.dart';

class SecureProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color lightTextColor;
  final Color purpleAccent;
  final bool isDestructive;

  const SecureProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.lightTextColor,
    required this.purpleAccent,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: lightTextColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: purpleAccent.withOpacity(0.1),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : lightTextColor,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: isDestructive ? Colors.red : lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: lightTextColor.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
