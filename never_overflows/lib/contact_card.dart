import 'package:flutter/material.dart';
import 'contacts.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark
          ? const Color(0xFF22324A)
          : const Color(0xFFE3F2FD),

      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isDark
                      ? Colors.blue.shade700
                      : Colors.blue.shade500,
                  child: Text(
                    contact.initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (contact.unread > 0)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${contact.unread}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),


            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    contact.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              Icons.chevron_right,
              color: isDark
                  ? Colors.white70
                  : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}