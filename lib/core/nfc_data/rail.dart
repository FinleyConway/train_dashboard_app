import 'dart:typed_data';

enum RailType {
  horizontal,
  vertical,
  leftCurve,
  rightCurve
}

class Rail {
  late int railId;
  late RailType railType;  

  Uint8List serialise() {
    final bytes = Uint8List(8 + 1);
    final data = ByteData.sublistView(bytes);

    data.setInt64(0, railId, Endian.little); // esp uses little (and basically any modern phone)
    data.setUint8(8, railType.index);

    return bytes;
  }

  bool deserialise(Uint8List payload) {
    if (payload.length < 9) return false;

    final data = ByteData.sublistView(payload);

    railId = data.getInt64(0, Endian.little);

    final typeIndex = data.getUint8(8);
    if (typeIndex >= RailType.values.length) return false;
    railType = RailType.values[data.getUint8(8)]; 

    return true;
  }
}