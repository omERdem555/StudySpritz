import '../models/app_settings.dart';
import 'package:hive/hive.dart';
class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 3;

  @override
  AppSettings read(BinaryReader reader) {
    return AppSettings(
      themeMode: reader.readString(),
      language: reader.readString(),
      wpmSpeed: reader.readInt(),
      animationSpeed: reader.readInt(),
      fontSize: reader.readInt(),
      rsvpHighlightColor: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer.writeString(obj.themeMode);
    writer.writeString(obj.language);
    writer.writeInt(obj.wpmSpeed);
    writer.writeInt(obj.animationSpeed);
    writer.writeInt(obj.fontSize);
    writer.writeString(obj.rsvpHighlightColor);
  }
}