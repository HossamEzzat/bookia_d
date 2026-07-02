import '../entities/book_entity.dart';

abstract class HomeRepository {
  Future<List<BookEntity>> getBooks();
  Future<BookEntity> getBookDetails(int id);
}
