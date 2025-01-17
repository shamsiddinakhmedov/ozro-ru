import 'package:ozro_mobile/src/data/models/main/home/products_list_response.dart';

class FavoriteProductsListResponse {

  FavoriteProductsListResponse({this.id, this.product});

  FavoriteProductsListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? new ProductsListResponse.fromJson(json['product']) : null;
  }
  int? id;
  ProductsListResponse? product;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}


class ImageResponse {

  ImageResponse({this.link, this.type, this.stream});

  ImageResponse.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    type = json['type'];
    stream = json['stream'];
  }
  String? link;
  String? type;
  bool? stream;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['type'] = type;
    data['stream'] = stream;
    return data;
  }
}
