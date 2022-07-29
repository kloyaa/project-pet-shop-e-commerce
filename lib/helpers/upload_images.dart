import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:dio/dio.dart' as http;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

Future<List<Map>> uploadImages(images) async {
  try {
    final _profile = Get.put(ProfileController());
    List<Map> _images = [];

    for (final image in images) {
      final _uploadResponse = await http.Dio().post(
        baseUrl + "/merchant/listing/upload",
        data: http.FormData.fromMap({
          "merchantName": _profile.data["merchantName"],
          "img": await http.MultipartFile.fromFile(
            image["path"],
            filename: image["name"],
            contentType: MediaType("image", "jpeg"), //important
          ),
        }),
      );
      _images.add(_uploadResponse.data);
    }

    return _images;
  } on http.DioError catch (e) {
    print(e.response!.data);
    throw Error();
  }
}
