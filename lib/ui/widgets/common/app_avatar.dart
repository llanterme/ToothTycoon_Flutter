import 'package:flutter/material.dart';

/// Modern avatar component with multiple variants
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? badge;
  final VoidCallback? onTap;
  final bool showBorder;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.imagePath,
    this.initials,
    this.size = 48,
    this.backgroundColor,
    this.foregroundColor,
    this.badge,
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget avatarContent = _buildAvatarContent(context, colorScheme);

    // Add border if requested
    if (showBorder) {
      avatarContent = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: avatarContent,
      );
    }

    // Add badge if provided
    if (badge != null) {
      avatarContent = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarContent,
          Positioned(
            right: 0,
            bottom: 0,
            child: badge!,
          ),
        ],
      );
    }

    // Add tap functionality
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: avatarContent,
      );
    }

    return avatarContent;
  }

  Widget _buildAvatarContent(BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    final bgColor = backgroundColor ?? colorScheme.primaryContainer;
    final fgColor = foregroundColor ?? colorScheme.onPrimaryContainer;

    // Image from URL
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) {},
        child: const SizedBox(),
      );
    }

    // Image from asset path
    if (imagePath != null && imagePath!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        backgroundImage: AssetImage(imagePath!),
        onBackgroundImageError: (_, __) {},
        child: const SizedBox(),
      );
    }

    // Initials
    if (initials != null && initials!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: bgColor,
        child: Text(
          initials!.toUpperCase(),
          style: textTheme.titleMedium?.copyWith(
            color: fgColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Default icon
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bgColor,
      child: Icon(
        Icons.person_outline,
        size: size * 0.5,
        color: fgColor,
      ),
    );
  }
}
