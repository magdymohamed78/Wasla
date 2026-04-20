import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../networking/logo_cache_manager.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/url_utils.dart';

class CompanyLogoWidget extends StatelessWidget {
  final String? logoUrl;
  final double size;
  final double borderRadius;
  final BoxFit fit;

  const CompanyLogoWidget({
    super.key,
    required this.logoUrl,
    this.size = AppDimensions.logoSizeSmall,
    this.borderRadius = AppDimensions.borderRadiusSm,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = UrlUtils.resolveLogoUrl(logoUrl);

    if (resolvedUrl == null) {
      return _buildPlaceholder();
    }

    final cacheDimension = _cacheDimension(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: resolvedUrl,
        cacheManager: LogoCacheManager.instance,
        width: size,
        height: size,
        fit: fit,
        memCacheWidth: cacheDimension,
        memCacheHeight: cacheDimension,
        placeholder: (context, imageUrl) => _buildLoadingPlaceholder(),
        errorWidget: (context, imageUrl, error) => _buildPlaceholder(),
      ),
    );
  }

  int _cacheDimension(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final dimension = (size * pixelRatio).round();
    return dimension < 1 ? 1 : dimension;
  }

  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.buttonSecondary,
      highlightColor: AppColors.cardShadow,
      child: _buildContainer(),
    );
  }

  Widget _buildPlaceholder() {
    return _buildContainer(
      child: Icon(
        Icons.business_rounded,
        size: size * 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildContainer({Widget? child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
