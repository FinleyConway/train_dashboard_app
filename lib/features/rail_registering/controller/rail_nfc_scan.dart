

int generateId64() {
  final random = Random.secure();
  final bytes = ByteData(8);

  for (int i = 0; i < 8; i++) {
    bytes.setUint8(i, random.nextInt(256));
  }

  return bytes.getInt64(0, Endian.little); // esp32 is small endians
}
