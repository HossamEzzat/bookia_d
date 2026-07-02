import '../../domain/entities/book_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BookEntity>> getBooks() {
    return remoteDataSource.getBooks();
  }

  @override
  Future<BookEntity> getBookDetails(int id) {
    return remoteDataSource.getBookDetails(id);
  }
}
