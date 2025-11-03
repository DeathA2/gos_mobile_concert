import 'package:flutter_dotenv/flutter_dotenv.dart';

class ENV {
  static final ENV _instance = ENV._internal();
  ENV._internal();

  factory ENV() => _instance;

  static ENV get instance => _instance;
  static ENV get I => instance;

  Future load(String fileName) => dotenv.load(fileName: fileName);

  String get imageURL => dotenv.env['IMAGE_URL'] ?? '';
}
