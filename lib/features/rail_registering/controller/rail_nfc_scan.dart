import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';
import 'package:train_dashboard_app/core/utils/nfc_io.dart';

class RailNfcScan extends ChangeNotifier {
  Future<bool> registerRail(RailType type) async {
    final rail = Rail(_generateId64(), type);

    return await NfcIo.writeTo("rail", rail.serialise());
  } 

  Future<Rail?> readRail() async {
    final NdefRecord? record = await NfcIo.readFrom();

    if (record == null) return null;

    if (ascii.decode(record.type) == "rail") {
      return Rail.deserialise(record.payload);
    }

    return null;
  }

  Future<void> stopReadScan() async {
    await NfcIo.stop();
  }

  BigInt _generateId64() {
    final random = Random.secure();
    final bytes = ByteData(8);

    for (int i = 0; i < 8; i++) {
      bytes.setUint8(i, random.nextInt(256));
    }

    return BigInt.from(bytes.getUint64(0, Endian.little)); // esp32 is small endians
  }
}