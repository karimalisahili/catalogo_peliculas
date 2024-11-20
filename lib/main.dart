//En esta pagina se encuentra el codigo principal de la aplicacion, 
//en el cual se importan las librerias necesarias para el funcionamiento de la aplicacion, 
//se inicializa la aplicacion y se crea la clase principal de la aplicacion.
//ademas se encuentra la funcionalidad del manejo de rutas de la aplicacion.
import 'package:catalogo_peliculas/add_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'firebase_options.dart';
import 'app_state.dart';
import 'splash_screen.dart';
import 'home_page.dart';

final _router = GoRouter(
  initialLocation: '/', // Comienza con la ruta raíz
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreenWrapper(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
              actions: [
                ForgotPasswordAction((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: {'email': email},
                  );
                  context.push(uri.toString());
                }),
                AuthStateChangeAction<SignedIn>((context, state) {
                  context.pushReplacement('/home');
                }),
                AuthStateChangeAction<UserCreated>((context, state) {
                  final user = state.credential.user;
                  if (user != null) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                    if (!user.emailVerified) {
                      user.sendEmailVerification();
                      const snackBar = SnackBar(
                          content: Text(
                              'Please check your email to verify your email address'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    context.pushReplacement('/home');
                  }
                }),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/sign-in');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'agregar-pelicula',
          builder: (context, state) => AddMovieScreen(),
        )
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationState()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie Catalog',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  _navigateToSignIn() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Simula carga de 3 segundos
    context.go('/sign-in'); // Usa `go` para navegar al Sign In Screen
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
