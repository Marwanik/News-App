import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/splash/splash_bloc.dart';
import 'package:newsapp/bloc/splash/splash_event.dart';
import 'package:newsapp/bloc/splash/splash_state.dart';
import 'package:newsapp/core/bloc/app_manger_bloc.dart';
import 'package:newsapp/design/colors.dart';
import 'package:newsapp/view/login/loginScreen.dart';
import 'package:newsapp/widget/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleScaleUpAnimation;
  late Animation<double> _circleScaleDownAnimation;
  late Animation<double> _imageFadeInAnimation;
  late Animation<Offset> _micMoveLeftAnimation;
  late Animation<Offset> _textSlideInAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _circleScaleUpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _circleScaleDownAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    _imageFadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    _micMoveLeftAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(-0.6, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 0.8, curve: Curves.easeOut),
      ),
    );

    _textSlideInAnimation = Tween<Offset>(begin: Offset(3, 0), end: Offset(0.3, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    _backgroundColorAnimation = ColorTween(
      begin: BackGround,
      end: PrimaryColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Start splash animation and check authorization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkLoginStatus();
      }
    });

    context.read<SplashBloc>().add(StartSplash());
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      context.read<AppManagerBloc>().add(HeLoggedIn());
    } else {
      context.read<AppManagerBloc>().add(LogOut());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            final appManagerState = context.read<AppManagerBloc>().state;
            if (mounted) {
              if (appManagerState is NavigateToHomePage) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AuthPage(),
                  ),
                );
              }
            }
          }
        },
        child: AnimatedBuilder(
          animation: _backgroundColorAnimation,
          builder: (context, child) {
            return Container(
              color: _backgroundColorAnimation.value,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _circleScaleUpAnimation,
                      builder: (context, child) {
                        double scaleValue = _circleScaleUpAnimation.value;
                        if (_circleScaleDownAnimation.value < 1) {
                          scaleValue = _circleScaleDownAnimation.value;
                        }
                        return Transform.scale(
                          scale: scaleValue,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _imageFadeInAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _imageFadeInAnimation,
                          child: SlideTransition(
                            position: _micMoveLeftAnimation,
                            child: Image.asset(
                              'assets/image/microphone.png',
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _textSlideInAnimation,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlideInAnimation,
                          child: Opacity(
                            opacity: _imageFadeInAnimation.value,
                            child: Image.asset(
                              'assets/image/Fram.png',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
