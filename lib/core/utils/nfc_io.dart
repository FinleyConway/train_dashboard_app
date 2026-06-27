import 'dart:async';
import 'dart:typed_data';

import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

class NfcIo {
  static Future<bool> isAvailabile() async {
    NfcAvailability availability = await NfcManager.instance.checkAvailability();

    if (availability != NfcAvailability.enabled) {
      return false;
    }

    return true;
  }

  static Future<bool> writeTo(String mimeType, Uint8List payload) async {
    final completer = Completer<bool>();

    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (NfcTag tag) async {
        try {
          final Ndef? ndef = Ndef.from(tag);

          // tag is not compatible
          if (ndef == null) {
            await NfcManager.instance.stopSession();
            completer.complete(false);
            return;
          }

          final record = NdefRecord(
            typeNameFormat: TypeNameFormat.media,
            type: Uint8List.fromList(mimeType.codeUnits),
            identifier: Uint8List(0),
            payload: payload,
          );
          final message = NdefMessage(records: [record]);

          await ndef.write(message: message);
          await NfcManager.instance.stopSession();
          completer.complete(true);
        } catch (e) {
          await NfcManager.instance.stopSession();
          completer.complete(false);
        }
      },
    );

    return completer.future;
  }

  static Future<NdefRecord?> readFrom() async {
    final completer = Completer<NdefRecord?>();

    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (NfcTag tag) async {
        try {
          final Ndef? ndef = Ndef.from(tag);

          // tag is not compatible
          if (ndef == null) {
            await NfcManager.instance.stopSession();
            completer.complete(null);
            return;
          }

          final NdefMessage? message = await ndef.read();

          // tag is empty
          if (message == null || message.records.isEmpty) {
            await NfcManager.instance.stopSession();
            completer.complete(null);
            return;
          }

          await NfcManager.instance.stopSession();

          completer.complete(message.records.first);
        } catch (e) {
          await NfcManager.instance.stopSession();
          completer.complete(null);
        }
      },
    );

    return completer.future;
  }
}
