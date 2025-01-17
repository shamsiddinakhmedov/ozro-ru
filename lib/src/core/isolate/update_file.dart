import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<String> uploadFile(File file) async => Isolate.run<String>(
      () async {
        try {
          RequestOptions setStreamType<T>(RequestOptions requestOptions) {
            if (T != dynamic &&
                !(requestOptions.responseType == ResponseType.bytes ||
                    requestOptions.responseType == ResponseType.stream)) {
              if (T == String) {
                requestOptions.responseType = ResponseType.plain;
              } else {
                requestOptions.responseType = ResponseType.json;
              }
            }
            return requestOptions;
          }

          final Dio dio = Dio();
          const extra = <String, dynamic>{};
          final data = FormData();

          final String fileName = file.path.split('/').last;
          final String type = file.path.split('.').last;
          data.files.add(
            MapEntry(
              'file',
              MultipartFile.fromBytes(
                file.readAsBytesSync(),
                filename: fileName,
                contentType: MediaType(
                  'image',
                  type,
                ),
              ),
            ),
          );
          final result = await dio.fetch<Map<String, dynamic>>(
            setStreamType<void>(
              Options(
                method: 'POST',
                headers: {},
                extra: extra,
              )
                  .compose(
                    dio.options,
                    'upload',
                    data: data,
                  )
                  .copyWith(
                    baseUrl: '',
                  ),
            ),
          );
          if (result.statusCode == 200 || result.statusCode == 201) {
            return result.data?['data']['filename'];
          } else {
            return '';
          }
        } on Exception catch (e, s) {
          log('uploadFile error: $e $s');
          return '';
        }
      },
    );
