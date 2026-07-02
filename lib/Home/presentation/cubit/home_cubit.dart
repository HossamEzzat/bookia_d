import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_books_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetBooksUseCase getBooksUseCase;

  HomeCubit({required this.getBooksUseCase}) : super(HomeInitialState());

  void loadHomeData() async {
    emit(HomeLoadingState());
    try {
      final books = await getBooksUseCase.execute();
      emit(HomeSuccessState(
        books: books,
        filteredBooks: books,
        bookmarkedBookIds: [],
        cartBookIds: [],
        searchQuery: '',
      ));
    } catch (e) {
      emit(HomeErrorState(e.toString().replaceAll('Exception:', '')));
    }
  }

  void searchBooks(String query) {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      if (query.trim().isEmpty) {
        emit(currentState.copyWith(
          filteredBooks: currentState.books,
          searchQuery: '',
        ));
      } else {
        final filtered = currentState.books.where((book) {
          final title = book.title.toLowerCase();
          final category = book.category.toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || category.contains(searchLower);
        }).toList();
        
        emit(currentState.copyWith(
          filteredBooks: filtered,
          searchQuery: query,
        ));
      }
    }
  }

  void toggleBookmark(int bookId) {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      final updatedBookmarks = List<int>.from(currentState.bookmarkedBookIds);
      if (updatedBookmarks.contains(bookId)) {
        updatedBookmarks.remove(bookId);
      } else {
        updatedBookmarks.add(bookId);
      }
      emit(currentState.copyWith(bookmarkedBookIds: updatedBookmarks));
    }
  }

  void addToCart(int bookId) {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      final updatedCart = List<int>.from(currentState.cartBookIds);
      if (!updatedCart.contains(bookId)) {
        updatedCart.add(bookId);
      }
      emit(currentState.copyWith(cartBookIds: updatedCart));
    }
  }

  void removeFromCart(int bookId) {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      final updatedCart = List<int>.from(currentState.cartBookIds);
      updatedCart.remove(bookId);
      emit(currentState.copyWith(cartBookIds: updatedCart));
    }
  }
}
