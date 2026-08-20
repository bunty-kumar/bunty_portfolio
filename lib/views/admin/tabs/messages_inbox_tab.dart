import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';

class MessagesInboxTab extends StatelessWidget {
  const MessagesInboxTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final messages = provider.messages;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Messages Inbox',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Inquiries and messages sent via the Portfolio Contact Form',
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),

          if (messages.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.primaryColor.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Icon(Icons.inbox, size: 64, color: theme.primaryColor.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'No messages received yet',
                    style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Messages submitted by visitors on the contact form will appear here live.',
                    style: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 13),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: m.read ? theme.cardColor.withValues(alpha: 0.5) : theme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: m.read
                          ? theme.primaryColor.withValues(alpha: 0.1)
                          : theme.primaryColor.withValues(alpha: 0.4),
                      width: m.read ? 1.0 : 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_circle, color: theme.primaryColor, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                m.name,
                                style: TextStyle(
                                  color: theme.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${m.email})',
                                style: TextStyle(
                                  color: theme.textColor.withValues(alpha: 0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${m.timestamp.day}/${m.timestamp.month}/${m.timestamp.year} ${m.timestamp.hour}:${m.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: theme.textColor.withValues(alpha: 0.5),
                                  fontSize: 12,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                onPressed: () => provider.deleteMessage(m.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Subject: ${m.subject}',
                        style: TextStyle(
                          color: theme.secondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m.message,
                        style: TextStyle(
                          color: theme.textColor.withValues(alpha: 0.85),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
