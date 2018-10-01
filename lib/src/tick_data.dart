import 'package:meta/meta.dart';

@immutable
class TickData {
  const TickData({
    this.hasTick1 = false,
    this.hasTick2 = false,
    this.hasTick3 = false,
  })  : assert(hasTick1 != null),
        assert(hasTick2 != null),
        assert(hasTick3 != null);

  final bool hasTick1;

  final bool hasTick2;

  final bool hasTick3;

  TickData copyWith({
    bool hasTick1,
    bool hasTick2,
    bool hasTick3,
  }) {
    return new TickData(
      hasTick1: hasTick1 ?? this.hasTick1,
      hasTick2: hasTick2 ?? this.hasTick2,
      hasTick3: hasTick3 ?? this.hasTick3,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TickData &&
          runtimeType == other.runtimeType &&
          hasTick1 == other.hasTick1 &&
          hasTick2 == other.hasTick2 &&
          hasTick3 == other.hasTick3;

  @override
  int get hashCode => hasTick1.hashCode ^ hasTick2.hashCode ^ hasTick3.hashCode;
}
