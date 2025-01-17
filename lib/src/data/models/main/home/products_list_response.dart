class ProductsListResponse {

  ProductsListResponse(
      {this.id,
        this.title,
        this.sourceId,
        this.liked,
        this.favorite,
        this.likes,
        this.promoted,
        this.image,
        this.link});

  ProductsListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sourceId = json['source_id'];
    liked = json['liked'];
    favorite = json['favorite'];
    likes = json['likes'];
    promoted = json['promoted'];
    image = json['image'] != null ? new ImageResponse.fromJson(json['image']) : null;
    link = json['link'];
  }
  int? id;
  String? title;
  int? sourceId;
  bool? liked;
  bool? favorite;
  int? likes;
  bool? promoted;
  ImageResponse? image;
  String? link;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['source_id'] = sourceId;
    data['liked'] = liked;
    data['favorite'] = favorite;
    data['likes'] = likes;
    data['promoted'] = promoted;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['link'] = link;
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
