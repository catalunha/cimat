import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/core/authentication/bloc/authentication_bloc.dart';
import 'app/core/models/user_model.dart';
import 'app/core/repositories/user_repository.dart';
import 'app/data/b4a/table/user/user_b4a.dart';
import 'app/feature/caution/delivery/caution_delivery_page.dart';
import 'app/feature/caution/giveback/caution_giveback_page.dart';
import 'app/feature/caution/receiver/caution_receiver_page.dart';
import 'app/feature/caution/search/caution_search_page.dart';
import 'app/feature/home/home_page.dart';
import 'app/feature/image/search/image_search_page.dart';
import 'app/feature/item/addedit/item_addedit_page.dart';
import 'app/feature/item/search/item_search_page.dart';
import 'app/feature/splash/splash_page.dart';
import 'app/feature/user/login/login_page.dart';
import 'app/feature/user/register/email/user_register_email.page.dart';
import 'app/feature/userprofile/edit/user_profile_edit_page.dart';
import 'app/feature/userprofile/search/user_profile_search_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository(userB4a: UserB4a());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          userRepository: _userRepository,
        )..add(AuthenticationEventInitial()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(), (route) => false);
            } else if (state.status == AuthenticationStatus.unauthenticated) {
              _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(), (route) => false);
            } else {
              return;
            }
          },
          child: child,
        );
      },
      routes: {
        '/': (_) => const SplashPage(),
        '/register/email': (_) => const UserRegisterEmailPage(),
        '/userProfile/edit': (context) {
          UserModel user =
              ModalRoute.of(context)!.settings.arguments as UserModel;

          return UserProfileEditPage(
            userModel: user,
          );
        },
        '/userProfile/search': (_) => const UserProfileSearchPage(),
        '/image/search': (_) => const ImageSearchPage(),
        // '/image/addedit': (context) {
        //   ImageModel? imageModel =
        //       ModalRoute.of(context)!.settings.arguments as ImageModel?;

        //   return ImageAddEditPage(
        //     imageModel: imageModel,
        //   );
        // },
        '/item/addedit': (_) => const ItemAddEditPage(),
        '/item/search': (_) => const ItemSearchPage(),
        '/caution/delivery': (_) => const CautionDeliveryPage(),
        '/caution/search': (context) {
          bool isOperator = ModalRoute.of(context)!.settings.arguments as bool;
          return CautionSearchPage(isOperator: isOperator);
        },
        '/caution/receiver': (_) => const CautionReceiverPage(),
        '/caution/giveback': (_) => const CautionGivebackPage(),
      },
      initialRoute: '/',
    );
  }
}
