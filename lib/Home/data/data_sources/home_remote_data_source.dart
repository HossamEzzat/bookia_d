import 'package:dio/dio.dart';
import '../model/book_model.dart';

class HomeRemoteDataSource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.codingarabic.online/api/',
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));

  Future<List<BookModel>> getBooks() async {
    try {
      final response = await _dio.get(
        'books',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      
      final resMap = response.data as Map<String, dynamic>;
      final dataList = resMap['data'] as List<dynamic>? ?? [];
      
      return dataList.map((json) => BookModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<BookModel> getBookDetails(int id) async {
    try {
      final response = await _dio.get(
        'books/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      
      final resMap = response.data as Map<String, dynamic>;
      final dataBlock = resMap['data'] as Map<String, dynamic>;
      
      return BookModel.fromJson(dataBlock);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return Exception(e.response?.data['message'] ?? 'حدث خطأ أثناء تحميل البيانات من الخادم.');
    }
    return Exception('مشكلة في الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت.');
  }
}
