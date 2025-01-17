
class GetNotificationsResponse {

  GetNotificationsResponse({this.id, this.title, this.body, this.data, this.isRead, this.createdAt});

  GetNotificationsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    data = json['data'] != null ? DataNotification.fromJson(json['data']) : null;
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }
  int? id;
  String? title;
  String? body;
  DataNotification? data;
  bool? isRead;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    return data;
  }
}

class DataNotification {
  DataNotification({this.commentId});
  DataNotification.fromJson(Map<String, dynamic> json) { commentId = json['comment_id'];}
  String? commentId;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment_id'] = commentId;
    return data;
  }
}
