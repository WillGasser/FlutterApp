import 'package:flutter/material.dart';
import '../theme.dart';

/// 简单认证布局 - 适用于注册和忘记密码页面
class SimpleAuthLayout extends StatelessWidget {
  final bool isLoading;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback? onBackPressed;
  final double contentOffset;

  const SimpleAuthLayout({
    Key? key,
    required this.isLoading,
    required this.title,
    required this.subtitle,
    required this.children,
    this.onBackPressed,
    this.contentOffset = -0.5, // 默认向上偏移
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用主题
    final theme = Theme.of(context);

    // 获取认证页面的颜色
    final primaryColor = ThemeProvider.getAuthPrimaryColor(context);
    final textColor = ThemeProvider.getAuthTextColor(context);
    final hintColor = ThemeProvider.getAuthHintColor(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // 如果有返回处理函数则添加返回按钮
        leading: onBackPressed != null
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onBackPressed,
        )
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Align(
        alignment: Alignment(0, contentOffset),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // 添加子组件
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// 扩展认证布局 - 专门为登录页面设计
class ExtendedAuthLayout extends StatelessWidget {
  final bool isLoading;
  final String title;
  final String subtitle;
  final List<Widget> mainChildren; // 主要输入和按钮
  final List<Widget> socialLoginChildren; // 社交登录按钮
  final Widget divider; // 分隔线

  const ExtendedAuthLayout({
    Key? key,
    required this.isLoading,
    required this.title,
    required this.subtitle,
    required this.mainChildren,
    required this.socialLoginChildren,
    required this.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用主题
    final theme = Theme.of(context);

    // 获取认证页面的颜色
    final primaryColor = ThemeProvider.getAuthPrimaryColor(context);
    final textColor = ThemeProvider.getAuthTextColor(context);
    final hintColor = ThemeProvider.getAuthHintColor(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),

                // 标题部分
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: hintColor,
                  ),
                ),
                const SizedBox(height: 20),

                // 主要输入和按钮
                ...mainChildren,

                const SizedBox(height: 8),

                // 分隔线
                divider,

                const SizedBox(height: 16),

                // 社交登录按钮
                ...socialLoginChildren,

                // 底部间距
                SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// OR分隔线
class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = ThemeProvider.getAuthHintColor(context);
    final dividerColor = theme.dividerTheme.color ?? Colors.grey;

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("OR", style: TextStyle(color: hintColor, fontSize: 14)),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}

/// 社交登录按钮
class SocialLoginButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ThemeProvider.getAuthTextColor(context);
    final secondaryButtonBg = theme.outlinedButtonTheme.style?.backgroundColor?.resolve({})
        ?? Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: icon,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: secondaryButtonBg,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

/// 认证页面文本输入框
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? labelText;

  const AuthTextField({
    Key? key,
    required this.controller,
    this.hintText = '',
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
        ),
      ),
    );
  }
}

///Universal Button for primary button with green color, and secondary button with white bg
class UniversalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const UniversalButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true, // 默认为主按钮
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(ThemeProvider.authBorderRadius);
    final textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.3,
    );

    final padding = const EdgeInsets.symmetric(vertical: 14);

    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Text(text, style: textStyle),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Text(text, style: textStyle),
        ),
      );
    }
  }
}






