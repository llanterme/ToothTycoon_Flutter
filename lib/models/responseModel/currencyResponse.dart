class CurrencyResponse {
  int status;
  String message;
  List<CurrencyData> data;

  CurrencyResponse({this.status, this.message, this.data});

  CurrencyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CurrencyData>();
      json['data'].forEach((v) {
        data.add(new CurrencyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyData {
  int id;
  String currency;
  String code;
  String symbol;

  CurrencyData({this.id, this.currency, this.code, this.symbol});

  CurrencyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    code = json['code'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currency'] = this.currency;
    data['code'] = this.code;
    data['symbol'] = this.symbol;
    return data;
  }
}