class CommentListResponse {

  CommentListResponse(
      {this.id,
        this.user,
        this.product,
        this.content,
        this.replyTo,
        this.sourceDate,
        this.promo,
        this.repliedComments,
        this.files,
        this.isOwn,
        this.productName,
        this.productImage});

  CommentListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    product = json['product'];
    content = json['content'];
    replyTo = json['reply_to'];
    sourceDate = json['source_date'];
    promo = json['promo'];
    repliedComments = json['replied_comments'].cast<String>();
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    isOwn = json['is_own'];
    productName = json['product_name'];
    productImage = json['product_image'] != null
        ? new Files.fromJson(json['product_image'])
        : null;
  }
  int? id;
  String? user;
  int? product;
  String? content;
  int? replyTo;
  String? sourceDate;
  bool? promo;
  List<String>? repliedComments;
  List<Files>? files;
  bool? isOwn;
  String? productName;
  Files? productImage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['product'] = product;
    data['content'] = content;
    data['reply_to'] = replyTo;
    data['source_date'] = sourceDate;
    data['promo'] = promo;
    data['replied_comments'] = repliedComments;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    data['is_own'] = isOwn;
    data['product_name'] = productName;
    if (productImage != null) {
      data['product_image'] = productImage!.toJson();
    }
    return data;
  }
}

class Files {

  Files({this.link, this.type, this.stream});

  Files.fromJson(Map<String, dynamic> json) {
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
