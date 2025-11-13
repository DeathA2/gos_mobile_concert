import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class XSocialPostSkeleton extends StatelessWidget {
  const XSocialPostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User info skeleton
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 28, height: 28, color: Colors.white),
              ),
            ],
          ),
        ),
        // Media skeleton
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        // Reaction skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(width: 50, height: 12, color: Colors.white),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
