import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_concert/src/router/route_name.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 100),
              Card(
                child: SizedBox(
                  width: 200,
                  child: MenuItemWidget(
                    iconUrl: 'assets/images/app_start_live.png',
                    title: 'app_video',
                    description: 'App video',
                    onTap: () => _enterVideoLiveWidget(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _enterVideoLiveWidget(BuildContext context) {
    // Using GoRouter for navigation with push to maintain back stack
    context.push(AppRouteNames.videoLive.path);
  }
}

class MenuItemWidget extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String description;
  final void Function()? onTap;

  const MenuItemWidget({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD9E8FE), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Image.asset(iconUrl, width: 24, height: 24),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        title,
                        style: const TextStyle(color: Color(0xFF262b32)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, right: 16),
                        child: Image.asset(
                          'assets/images/app_arrow.png',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  style: const TextStyle(color: Color(0xFF626e84)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
