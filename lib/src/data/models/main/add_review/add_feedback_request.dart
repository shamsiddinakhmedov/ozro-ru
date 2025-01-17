import 'package:dio/dio.dart';

class AddFeedbackRequest {
  AddFeedbackRequest({
    this.product,
    this.sourceId,
    this.content,
    this.rating,
    this.replyTo,
    required this.file,
    this.fileType = '',
  });

  final num? product;
  final num? sourceId;
  final String? content;
  final num? rating;
  final num? replyTo;
  final MultipartFile? file;
  final String fileType;

  Map<String, dynamic> toJson() => {
        'product': product,
        'source_id': sourceId,
        'content': content,
        'rating': rating,
        'reply_to': replyTo,
        if (file != null) ...{
          'file': file,
          'file_type': fileType,
        }
      };
}
