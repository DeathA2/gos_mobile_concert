import 'package:flutter/material.dart';
import 'package:tencent_live_uikit/component/live_info/index.dart';

class SafeLiveInfoWidget extends StatefulWidget {
  final String roomId;

  const SafeLiveInfoWidget({super.key, required this.roomId});

  @override
  State<SafeLiveInfoWidget> createState() => _SafeLiveInfoWidgetState();
}

class _SafeLiveInfoWidgetState extends State<SafeLiveInfoWidget> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildFallbackUI();
    }
    return Builder(
      builder: (context) {
        try {
          return FutureBuilder<bool>(
            future: _ensureContextReady(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return ErrorBoundary(
                  onError: (error) {
                    if (mounted) {
                      setState(() {
                        _hasError = true;
                      });
                    }
                  },
                  child: LiveInfoWidget(roomId: widget.roomId),
                );
              }
              return _buildLoadingUI();
            },
          );
        } catch (e) {
          debugPrint('Error in SafeLiveInfoWidget: $e');
          return _buildFallbackUI();
        }
      },
    );
  }

  Future<bool> _ensureContextReady() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mounted;
  }

  Widget _buildLoadingUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Room ${widget.roomId}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Room ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Room ${widget.roomId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 20,
            color: Colors.white.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),

          // Viewer count
          Row(
            children: [
              const Icon(Icons.visibility, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '0',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Follow feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final void Function(dynamic error)? onError;

  const ErrorBoundary({super.key, required this.child, this.onError});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return SizedBox();
    }

    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (mounted && !_hasError) {
        setState(() {
          _hasError = true;
        });
        widget.onError?.call(details.exception);
      }
      return Container();
    };

    return widget.child;
  }
}
