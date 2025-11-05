class CurrencyResponse {
  late int status;
  late String message;
  List<CurrencyData>? data;

  CurrencyResponse({required this.status, required this.message, this.data});

  CurrencyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CurrencyData>[];
      json['data'].forEach((v) {
        data!.add(CurrencyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyData {
  late int id;
  late String currency;
  late String code;
  late String symbol;

  CurrencyData({required this.id, required this.currency, required this.code, required this.symbol});

  CurrencyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    code = json['code'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currency'] = currency;
    data['code'] = code;
    data['symbol'] = symbol;
    return data;
  }
}