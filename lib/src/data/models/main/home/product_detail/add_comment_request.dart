class AddCommentRequest {

  AddCommentRequest({this.content, this.replyTo, this.product});

  AddCommentRequest.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    replyTo = json['reply_to'];
    product = json['product'];
  }
  String? content;
  int? replyTo;
  int? product;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['reply_to'] = replyTo;
    data['product'] = product;
    return data;
  }
}
