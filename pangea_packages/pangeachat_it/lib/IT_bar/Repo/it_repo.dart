import 'dart:convert';

import '../models/initial_send_model.dart';
import '../models/receive_text_model.dart';
import '../models/subsequent_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';
import 'package:http/http.dart';
import 'dart:math';

class ItRepo {
  static Future<ReceiveTextModel> firstCall(InitialTextModel initalText) async {
    final Requests req = Requests(Urls.baseUrl);

    final Response res =
        await req.post(url: Urls.firstStep, body: initalText.toJson());

    ReceiveTextModel receiveText = new ReceiveTextModel()
      ..fromJson(jsonDecode(res.body));
    for (int i = 0; i < receiveText.continuances!.length; i++) {
      receiveText.continuances![i].index =
          receiveText.continuances![i].level! - 1;
    }
    return receiveText;
  }

  static Future<ReceiveTextModel> subsequentCall(
      SubsequentTextModel subseqText) async {
    final Requests req = Requests(Urls.baseUrl);

    final Response res =
        await req.post(url: Urls.subseqStep, body: subseqText.toJson());
    print(res.body);

    // TODO
    final decodedBody = jsonDecode(res.body);
    ReceiveTextModel receiveText = new ReceiveTextModel();
    if (decodedBody['continuances'].runtimeType == String) {
      receiveText.isFinal = true;
    }

    receiveText.fromJson(decodedBody);

    if (!receiveText.isFinal) {
      for (int i = 0; i < receiveText.continuances!.length; i++) {
        receiveText.continuances![i].index =
            receiveText.continuances![i].level! - 1;
      }
    }

    return receiveText;
  }
}
