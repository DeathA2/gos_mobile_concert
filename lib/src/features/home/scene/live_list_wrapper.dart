import 'package:flutter/material.dart';
import 'package:tencent_live_uikit/tencent_live_uikit.dart';

class LiveListWrapper extends StatefulWidget {
  final Function(String roomId)? onRoomEntered;
  
  const LiveListWrapper({
    super.key,
    this.onRoomEntered,
  });

  @override
  State<LiveListWrapper> createState() => _LiveListWrapperState();
}

class _LiveListWrapperState extends State<LiveListWrapper> {
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Ensure widget is mounted and context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Unable to load live streams',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = '';
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Wrap in ErrorBoundary
    return Container(
      constraints: const BoxConstraints.expand(),
      child: ErrorBoundary(
        onError: (error, stackTrace) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Error loading live content. Please try again later.';
          });
        },
        child: const LiveListWidget(),
      ),
    );
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Function(Object error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted && widget.onError != null) {
        widget.onError!(details.exception, details.stack ?? StackTrace.current);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return const Center(
        child: Text('Something went wrong'),
      );
    }

    return widget.child;
  }
}