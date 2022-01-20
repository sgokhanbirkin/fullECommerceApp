import 'package:flutter/material.dart';
import 'package:full_ecommerce_app/screens/auth/login_screen.dart';
import 'package:full_ecommerce_app/screens/auth/signup_screen.dart';
import 'package:full_ecommerce_app/screens/bottom_nav_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  static const routeName = '/landing-screen';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _images = [
    'assets/images/shopping1.jpeg',
    'assets/images/shopping2.jpeg',
  ];

  @override
  void initState() {
    _images.shuffle();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            _images[0],
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'Welcome to',
                style: TextStyle(fontSize: 45),
              ),
            ),
            Center(
              child: Text(
                'Flutter Shop ',
                style: TextStyle(fontSize: 65),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: const Text('Login',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Continue with Google',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(BottomNavScreen.routeName);
                    },
                    child: const Text('Go to Guest',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    ));
  }
}