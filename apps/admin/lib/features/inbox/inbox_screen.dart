import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/format_date.dart';

/// App-local message model — not in mercury_client until messaging is grilled.
class MessageThread {
  const MessageThread({
    required this.id,
    required this.subject,
    required this.senderName,
    required this.senderEmail,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.support,
  });

  final String id;
  final String subject;
  final String senderName;
  final String senderEmail;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;
}

enum MessageType { system, support, notification }

/// Mock inbox data.
final _mockMessages = [
  MessageThread(
    id: 'm001',
    subject: 'Plattformoppdatering: v2.3 er ute',
    senderName: 'System',
    senderEmail: 'system@dittodatto.no',
    body: 'DittoDatto v2.3 er nå tilgjengelig. Oppdateringer inkluderer forbedret søkefunksjonalitet, raskere sideinnlasting, og bugfikser for bookingmodulen.\n\nVennligst oppdater alle klienter innen utgangen av uken.',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    type: MessageType.system,
  ),
  MessageThread(
    id: 'm002',
    subject: 'Trenger hjelp med onboarding',
    senderName: 'Ingrid Pedersen',
    senderEmail: 'ingrid@frisorsalongen.no',
    body: 'Hei!\n\nJeg har problemer med å fullføre onboarding for frisørsalongen vår. Steg 3 (tjenester) laster ikke riktig. Kan dere hjelpe?\n\nMvh,\nIngrid',
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    type: MessageType.support,
  ),
  MessageThread(
    id: 'm003',
    subject: 'Ny bedrift registrert: Café Elvebris',
    senderName: 'System',
    senderEmail: 'system@dittodatto.no',
    body: 'En ny bedrift har registrert seg på plattformen:\n\n• Navn: Café Elvebris\n• Eier: Emma Larsen (emma@elvebris.no)\n• Sted: Drammen\n• Tier: Free\n\nOnboarding er påbegynt.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    type: MessageType.notification,
    isRead: true,
  ),
  MessageThread(
    id: 'm004',
    subject: 'Fakturaspørsmål — Premium-plan',
    senderName: 'Ole Hansen',
    senderEmail: 'ole@drammen-treningssenter.no',
    body: 'Hei DittoDatto-teamet,\n\nJeg lurer på om det er mulig å oppgradere fra Premium til Enterprise-plan. Vi trenger tilgang til analytics-modulen for å kunne rapportere til styret.\n\nHvilke kostnader er forbundet med dette?\n\nBeste hilsen,\nOle',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    type: MessageType.support,
    isRead: true,
  ),
];

/// Provider for inbox messages.
final inboxProvider = Provider<List<MessageThread>>((ref) => _mockMessages);

/// Inbox screen with message list and detail view.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  String? _selectedMessageId;

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(inboxProvider);
    final selectedMessage = _selectedMessageId != null
        ? messages.firstWhere((m) => m.id == _selectedMessageId)
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final windowClass = DittoWindowClass.of(constraints.maxWidth);

        if (windowClass.showPermanentSidebar) {
          // Two-pane layout
          return Row(
            children: [
              SizedBox(
                width: 360,
                child: _MessageList(
                  messages: messages,
                  selectedId: _selectedMessageId,
                  onSelected: (id) => setState(() => _selectedMessageId = id),
                ),
              ),
              VerticalDivider(
                width: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
              Expanded(
                child: selectedMessage != null
                    ? _MessageDetail(message: selectedMessage)
                    : const DittoEmptyView(
                        message: 'Select a message to read',
                        icon: Icons.mail_outline_rounded,
                      ),
              ),
            ],
          );
        }

        // Single-pane: list or detail
        if (selectedMessage != null) {
          return _MessageDetail(
            message: selectedMessage,
            onBack: () => setState(() => _selectedMessageId = null),
          );
        }

        return _MessageList(
          messages: messages,
          selectedId: null,
          onSelected: (id) => setState(() => _selectedMessageId = id),
        );
      },
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.selectedId,
    required this.onSelected,
  });

  final List<MessageThread> messages;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(DittoSpacing.lg),
          child: Text('Inbox', style: theme.textTheme.headlineMedium),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: messages.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isSelected = msg.id == selectedId;

              return AnimatedContainer(
                duration: DittoAnimationDuration.fast,
                color: isSelected
                    ? DittoColors.moodyBlue.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: ListTile(
                  leading: _TypeIcon(type: msg.type),
                  title: Text(
                    msg.subject,
                    style: TextStyle(
                      fontWeight: msg.isRead ? FontWeight.w400 : FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${msg.senderName} · ${formatRelativeDate(msg.timestamp)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  onTap: () => onSelected(msg.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MessageDetail extends StatelessWidget {
  const _MessageDetail({required this.message, this.onBack});

  final MessageThread message;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      children: [
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back'),
            ),
          ),
        Text(
          message.subject,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DittoSpacing.sm),
        Row(
          children: [
            _TypeIcon(type: message.type),
            const SizedBox(width: DittoSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.senderName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${message.senderEmail} · ${formatDate(message.timestamp)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: DittoSpacing.lg),
        const Divider(),
        const SizedBox(height: DittoSpacing.base),
        SelectableText(
          message.body,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final MessageType type;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      MessageType.system => (Icons.info_rounded, const Color(0xFF818cf8)),
      MessageType.support => (Icons.support_agent_rounded, const Color(0xFF34d399)),
      MessageType.notification => (Icons.notifications_rounded, const Color(0xFFfbbf24)),
    };

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: DittoBorderRadius.smallAll,
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
