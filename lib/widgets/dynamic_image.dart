import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// A cross-platform image widget
class DynamicImage extends StatelessWidget {
  final String src;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isAsset;
  final Widget? placeholder;
  final Widget? errorWidget;

  const DynamicImage({
    super.key,
    required this.src,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.isAsset = false,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = isAsset
        ? Image.asset(
            src,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: _errorBuilder,
          )
        : Image.network(
            src,
            fit: fit,
            width: width,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return placeholder ??
                  Center(
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator(),
                  );
            },
            errorBuilder: _errorBuilder,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return errorWidget ??
        Container(
          color: Colors.grey.shade200,
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image,
            size: 32,
            color: Colors.grey.shade500,
          ),
        );
  }
}
