import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.child,
    this.color = Colors.blue,
    this.margin,
    this.padding,
    this.borderRadius,
    this.onPressed,
    this.border,
    this.isLoading = false,
    this.loadingColor = Colors.white,
    this.boxShadow,
    this.height,
    this.width,
    this.isDisabled = false,
  });

  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;
  final Color color;
  final BorderRadius? borderRadius;
  final VoidCallback? onPressed;
  final BoxBorder? border;
  final bool isLoading;
  final Color loadingColor;
  final List<BoxShadow>? boxShadow;
  final double? height;
  final double? width;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48.0,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: isDisabled || isLoading ? Colors.grey.shade200 : color,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          onTap: isDisabled || isLoading ? null : onPressed,
          enableFeedback: isDisabled || isLoading ? false : true,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(6),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator(
                              color: loadingColor,
                            )
                          : CircularProgressIndicator(
                              color: loadingColor,
                            ),
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
