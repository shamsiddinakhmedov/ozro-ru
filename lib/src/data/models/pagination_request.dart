class PaginationRequest {
  const PaginationRequest({
    this.page,
    this.count,
    this.search,
    this.sourceId,
    this.parentId,
    this.feedbackId,
  });

  final num? page;
  final num? count;
  final String? search;
  final String? sourceId;
  final String? parentId;
  final String? feedbackId;

  Map<String, dynamic> toJson() => {
        if (page != null) 'page': page,
        if (count != null) 'count': count,
        if (search != null) 'search': search,
        if (sourceId != null) 'source_id': sourceId,
        if (parentId != null) 'parent_id': parentId,
        if (feedbackId != null && feedbackId!.isNotEmpty) 'feedback_id': feedbackId,
      };
}
