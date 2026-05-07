import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';
import '../widgets/chat_history_drawer.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatbotCubit>().loadSession();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<ChatbotCubit, ChatbotState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty) {
          _scrollToBottom();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        drawer: BlocBuilder<ChatbotCubit, ChatbotState>(
          builder: (context, state) {
            return ChatHistoryDrawer(
              chatSummaries: state.chatSummaries,
              activeSessionId: state.sessionId,
              onNewChat: () {
                context.read<ChatbotCubit>().startNewConversation();
              },
              onSelectChat: (sessionId) {
                context.read<ChatbotCubit>().selectChat(sessionId);
              },
              onDeleteChat: (sessionId) {
                context.read<ChatbotCubit>().deleteChat(sessionId);
              },
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          leading: Builder(
            builder: (innerContext) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(innerContext).openDrawer(),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.brandRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(localizations.chatbotTitle, style: AppTypography.heading3),
            ],
          ),
        ),
        body: BlocBuilder<ChatbotCubit, ChatbotState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: !state.isSessionLoaded
                      ? const Center(child: CircularProgressIndicator())
                      : !state.hasConversation
                      ? _EmptyConversationView(
                          onSuggestionTap: (text) {
                            context.read<ChatbotCubit>().sendMessage(text);
                          },
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spacingSm,
                          ),
                          itemCount:
                              state.messages.length + (state.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.messages.length) {
                              return const TypingIndicator();
                            }
                            return ChatMessageBubble(
                              message: state.messages[index],
                            );
                          },
                        ),
                ),
                if (!state.hasConversation)
                  _SuggestionChips(
                    onSuggestionTap: (text) {
                      context.read<ChatbotCubit>().sendMessage(text);
                    },
                  ),
                ChatInputField(
                  isLoading: state.isLoading,
                  onSubmitted: (text) {
                    context.read<ChatbotCubit>().sendMessage(text);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  final ValueChanged<String> onSuggestionTap;

  const _SuggestionChips({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final suggestions = [
      l.chatbotSuggestionHelp,
      l.chatbotSuggestionExploreServices,
      l.chatbotSuggestionViewOffers,
      l.chatbotSuggestionFindCompany,
      l.chatbotSuggestionCreateRequest,
      l.chatbotSuggestionTrackStatus,
    ];

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.spacingXs,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(
                end: AppDimensions.spacingSm,
              ),
              child: ActionChip(
                label: Text(
                  suggestion,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                side: const BorderSide(color: AppColors.surface),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusXl,
                  ),
                ),
                backgroundColor: AppColors.brandRed,
                onPressed: () => onSuggestionTap(suggestion),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EmptyConversationView extends StatelessWidget {
  final ValueChanged<String> onSuggestionTap;

  const _EmptyConversationView({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.brandRed,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              localizations.chatbotTitle,
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              localizations.chatbotWelcomeMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
