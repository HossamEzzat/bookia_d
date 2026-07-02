import '../../domain/entities/book_entity.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<BookEntity> books;
  final List<BookEntity> filteredBooks;
  final List<int> bookmarkedBookIds;
  final List<int> cartBookIds;
  final String searchQuery;

  HomeSuccessState({
    required this.books,
    required this.filteredBooks,
    required this.bookmarkedBookIds,
    required this.cartBookIds,
    required this.searchQuery,
  });

  HomeSuccessState copyWith({
    List<BookEntity>? books,
    List<BookEntity>? filteredBooks,
    List<int>? bookmarkedBookIds,
    List<int>? cartBookIds,
    String? searchQuery,
  }) {
    return HomeSuccessState(
      books: books ?? this.books,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      bookmarkedBookIds: bookmarkedBookIds ?? this.bookmarkedBookIds,
      cartBookIds: cartBookIds ?? this.cartBookIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HomeErrorState extends HomeStates {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}
