import 'package:hive/hive.dart';

import '../models/reading_goal.dart';
import '../core/extensions/hive_date_extensions.dart';

class ReadingGoalAdapter extends TypeAdapter<ReadingGoal> {
  @override
  final int typeId = 7;

  @override
  ReadingGoal read(BinaryReader reader) {
    return ReadingGoal(
      goalId: reader.readString(),
      goalType: GoalType.values[reader.readInt()],
      targetValue: reader.readInt(),
      currentValue: reader.readInt(),
      isCompleted: reader.readBool(),
      createdAt: reader.readDateTimeSafe(),
      completedAt: reader.readBool()
          ? reader.readDateTimeSafe()
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, ReadingGoal obj) {
    writer.writeString(obj.goalId);
    writer.writeInt(obj.goalType.index);
    writer.writeInt(obj.targetValue);
    writer.writeInt(obj.currentValue);
    writer.writeBool(obj.isCompleted);
    writer.writeDateTimeSafe(obj.createdAt);

    writer.writeBool(obj.completedAt != null);

    if (obj.completedAt != null) {
      writer.writeDateTimeSafe(obj.completedAt!);
    }
  }
}