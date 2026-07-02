import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/authcubit_cubit.dart';
import '../cubit/authcubit_state.dart';
import 'WelcomeView.dart';

import '../../../Home/data/data_sources/home_remote_data_source.dart';
import '../../../Home/data/repository_impl/home_repository_impl.dart';
import '../../../Home/domain/use_cases/get_books_use_case.dart';
import '../../../Home/presentation/cubit/home_cubit.dart';
import '../../../Home/presentation/pages/MainDashboardView.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        if (state is AuthSuccessState) {
          return BlocProvider(
            create: (context) {
              final remoteDataSource = HomeRemoteDataSource();
              final repository = HomeRepositoryImpl(remoteDataSource);
              return HomeCubit(
                getBooksUseCase: GetBooksUseCase(repository),
              );
            },
            child: MainDashboardView(
              userName: state.user.name,
              token: state.user.token,
            ),
          );
        }
        
        if (state is AuthLoadingState) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC3A15C),
              ),
            ),
          );
        }

        // Return WelcomeView if user is not authenticated
        return const WelcomeView();
      },
    );
  }
}
