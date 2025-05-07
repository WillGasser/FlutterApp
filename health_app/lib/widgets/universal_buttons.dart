import 'package:flutter/material.dart';
import '../theme.dart';

/// Primary action button with themed styling
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height = 48.0,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = theme.elevatedButtonTheme.style;

    Widget buttonChild = Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );

    if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          SizedBox(width: 8),
          buttonChild,
        ],
      );
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle?.copyWith(
          padding: padding != null ? MaterialStateProperty.all(padding) : null,
        ),
        child: buttonChild,
      ),
    );
  }
}

/// Secondary action button with themed styling
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height = 48.0,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = theme.outlinedButtonTheme.style;

    Widget buttonChild = Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );

    if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          SizedBox(width: 8),
          buttonChild,
        ],
      );
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle?.copyWith(
          padding: padding != null ? MaterialStateProperty.all(padding) : null,
        ),
        child: buttonChild,
      ),
    );
  }
}

/// Text button with themed styling
class TextActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;

  const TextActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = false,
    this.padding,
    this.width,
    this.height,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = theme.textButtonTheme.style;

    Widget buttonChild = Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );

    if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: 8),
          buttonChild,
        ],
      );
    }

    Widget button = TextButton(
      onPressed: onPressed,
      style: buttonStyle?.copyWith(
        padding: padding != null ? MaterialStateProperty.all(padding) : null,
      ),
      child: buttonChild,
    );

    if (isFullWidth || width != null || height != null) {
      return SizedBox(
        width: isFullWidth ? double.infinity : width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}

/// Circular icon button with themed styling
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const CircleIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.size = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default colors based on theme
    final bgColor =
        backgroundColor ?? (isDark ? Colors.grey[800] : Colors.grey[200]);
    final fgColor =
        iconColor ?? (isDark ? Colors.white : theme.colorScheme.primary);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: fgColor,
          ),
        ),
      ),
    );
  }
}

/// Card-like button with themed styling
class CardButton extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool showArrow;

  const CardButton({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 12.0,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Color(0xFF4A4A40),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
