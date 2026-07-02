import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookia/Home/domain/entities/book_entity.dart';
import 'package:bookia/Home/presentation/cubit/home_cubit.dart';
import 'package:bookia/Home/presentation/cubit/home_state.dart';
import 'package:bookia/Home/presentation/pages/BookDetailsView.dart';

class FakeHomeCubit extends Cubit<HomeStates> implements HomeCubit {
  FakeHomeCubit(super.initialState);

  final List<int> toggledBookmarkIds = [];
  final List<int> addedToCartIds = [];
  final List<int> removedFromCartIds = [];

  @override
  void toggleBookmark(int bookId) {
    toggledBookmarkIds.add(bookId);
  }

  @override
  void addToCart(int bookId) {
    addedToCartIds.add(bookId);
  }

  @override
  void removeFromCart(int bookId) {
    removedFromCartIds.add(bookId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late BookEntity testBook;
  late FakeHomeCubit fakeCubit;

  setUp(() {
    testBook = BookEntity(
      id: 42,
      title: 'Test Book Title',
      category: 'Science',
      description: 'This is a test book description that describes the test book in detail.',
      price: '\$9.99',
      imageUrl: '', // testing empty URL resiliency
    );

    fakeCubit = FakeHomeCubit(
      HomeSuccessState(
        books: [testBook],
        filteredBooks: [testBook],
        bookmarkedBookIds: [],
        cartBookIds: [],
        searchQuery: '',
      ),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HomeCubit>.value(
        value: fakeCubit,
        child: BookDetailsView(book: testBook),
      ),
    );
  }

  testWidgets('renders book details correctly (title, category, price, description)', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Book Title'), findsOneWidget);
    expect(find.text('SCIENCE'), findsOneWidget); // category is upper-cased
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text('This is a test book description that describes the test book in detail.'), findsOneWidget);
    expect(find.byIcon(Icons.book_rounded), findsOneWidget); // placeholder since imageUrl is empty
  });

  testWidgets('handles bookmark interaction: starts not bookmarked, can toggle bookmark', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Initially bookmark outline is shown
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);

    // Tap bookmark button
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pump();

    // Verify cubit toggleBookmark was triggered
    expect(fakeCubit.toggledBookmarkIds, contains(42));
  });

  testWidgets('renders as bookmarked when state contains bookId in bookmarkedBookIds', (WidgetTester tester) async {
    fakeCubit = FakeHomeCubit(
      HomeSuccessState(
        books: [testBook],
        filteredBooks: [testBook],
        bookmarkedBookIds: [42],
        cartBookIds: [],
        searchQuery: '',
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    // Filled bookmark is shown
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsNothing);

    // Tap bookmark
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pump();

    expect(fakeCubit.toggledBookmarkIds, contains(42));
  });

  testWidgets('handles cart interaction: add to cart', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Should say Add To Cart
    expect(find.text('Add To Cart'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

    // Tap Add to Cart
    await tester.tap(find.text('Add To Cart'));
    await tester.pump();

    expect(fakeCubit.addedToCartIds, contains(42));
  });

  testWidgets('handles cart interaction: remove from cart when already in cart', (WidgetTester tester) async {
    fakeCubit = FakeHomeCubit(
      HomeSuccessState(
        books: [testBook],
        filteredBooks: [testBook],
        bookmarkedBookIds: [],
        cartBookIds: [42],
        searchQuery: '',
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    // Should say Added To Cart
    expect(find.text('Added To Cart'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

    // Tap Added To Cart to remove it
    await tester.tap(find.text('Added To Cart'));
    await tester.pump();

    expect(fakeCubit.removedFromCartIds, contains(42));
  });
}
