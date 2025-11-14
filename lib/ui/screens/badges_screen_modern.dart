import 'package:flutter/material.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

/// Modern badges screen displaying earned badges in grid layout
class BadgesScreenModern extends StatefulWidget {
  const BadgesScreenModern({super.key});

  @override
  State<BadgesScreenModern> createState() => _BadgesScreenModernState();
}

class _BadgesScreenModernState extends State<BadgesScreenModern> {
  List<Badges>? _badgesList;
  bool _isDataAvail = true;

  @override
  void initState() {
    super.initState();
    if (CommonResponse.pullHistoryData != null) {
      if (CommonResponse.pullHistoryData!.badges != null &&
          CommonResponse.pullHistoryData!.badges!.isNotEmpty) {
        _badgesList = CommonResponse.pullHistoryData!.badges;
      }
    } else {
      _isDataAvail = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isDataAvail || _badgesList == null || _badgesList!.isEmpty) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Spacing.radiusXl),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/ic_no_data.png',
                height: 200,
                width: 200,
              ),
              Spacing.gapVerticalMd,
              Text(
                'No badges found',
                style: TextStyle(
                  fontSize: 19,
                  color: colorScheme.onSurface,
                  fontFamily: 'Avenir',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Spacing.radiusXl),
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(Spacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: Spacing.md,
            mainAxisSpacing: Spacing.md,
            childAspectRatio: 0.75,
          ),
          itemCount: _badgesList!.length,
          itemBuilder: (context, index) => _buildBadgeCard(
            colorScheme,
            _badgesList![index],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(ColorScheme colorScheme, Badges badge) {
    return AppCard(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(Spacing.md),
              child: Image.asset(
                'assets/icons/ic_badges_list.gif',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Spacing.radiusMd),
                bottomRight: Radius.circular(Spacing.radiusMd),
              ),
            ),
            child: Column(
              children: [
                Text(
                  badge.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                    fontFamily: 'Avenir',
                  ),
                ),
                Spacing.gapVerticalXs,
                Text(
                  badge.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onPrimaryContainer,
                    fontFamily: 'Avenir',
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
