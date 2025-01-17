class CategoriesListResponse {
  int? id;
  String? title;
  int? sourceId;

  CategoriesListResponse({this.id, this.title, this.sourceId});

  CategoriesListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sourceId = json['source_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['source_id'] = sourceId;
    return data;
  }
}
