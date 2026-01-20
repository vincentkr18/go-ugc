import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'ugc_dashboard_screen.dart';
import '../config/env_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
    /// Handle Google OAuth Login
    Future<void> _handleGoogleLogin() async {
      setState(() => _isLoading = true);
      try {
        final user = await _authService.signInWithGoogle();
        if (!mounted) return;
        if (user != null) {
          _showSnackBar('Welcome ${user.email ?? 'Google User'}!', isError: false);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const UgcDashboardScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        } else {
          setState(() => _isLoading = false);
          _showSnackBar('Google sign-in cancelled', isError: true);
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showSnackBar('Google sign-in failed: \\${e.toString()}', isError: true);
      }
    }
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize Google Sign-In
    _authService.initialize();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle Fav Login (Dev Login for quick access)
  Future<void> _handleFavLogin() async {
    setState(() => _isLoading = true);
    
    try {
      // For development, skip login and go directly to dashboard
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      
      _showSnackBar('Welcome back! 🌟', isError: false);
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const UgcDashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Login failed: ${e.toString()}', isError: true);
    }
  }

  /// Handle Regular Login
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please enter email and password', isError: true);
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Simulate login delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;
      
      _showSnackBar('Welcome ${_emailController.text}!', isError: false);
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const UgcDashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Sign in failed: ${e.toString()}', isError: true);
    }
  }

  /// Show snackbar message
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.manrope()),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/34378264_v904-nunny-031-d.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0x15006FFF), // Slight blue tint
              BlendMode.srcOver,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Welcome Back\nto Rovio',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'E-mail',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'hello.nixto@gmail.com',
                            hintStyle: GoogleFonts.manrope(
                              color: const Color(0xFFB0B0B0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Password Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '••••••••••',
                            hintStyle: GoogleFonts.manrope(
                              color: const Color(0xFFB0B0B0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF5C5C5C),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showSnackBar('Password reset coming soon', isError: false);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Login Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Log in',
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        
                        // Fav Login Button (Dev Mode)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleFavLogin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            icon: const Icon(Icons.star, size: 18),
                            label: Text(
                              'Fav Login',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Google OAuth Button (if configured)
                    if (EnvConfig.googleWebClientId.isNotEmpty || EnvConfig.googleIosClientId.isNotEmpty || EnvConfig.googleAndroidClientId.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            icon: Image.asset(
                              'assets/images/google_logo.png',
                              height: 24,
                              width: 24,
                            ),
                            label: Text(
                              'Sign in with Google',
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: _isLoading ? null : _handleGoogleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 2,
                              side: const BorderSide(color: Color(0xFFDDDDDD)),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    
                    // Avatar Row - Curved Smile Pattern
                    SizedBox(
                      height: 80,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 24,
                            child: _buildAvatar('assets/images/eve-jyg_kpdbp6M-unsplash.jpg'),
                          ),
                          Positioned(
                            left: 75,
                            top: 10,
                            child: _buildAvatar('assets/images/mimo-FeNrGgQ1Tu8-unsplash.jpg'),
                          ),
                          Positioned(
                            left: 130,
                            top: 0,
                            child: _buildAvatar('assets/images/pawel-czerwinski-HNEzq0OxHSg-unsplash.jpg'),
                          ),
                          Positioned(
                            left: 185,
                            top: 10,
                            child: _buildAvatar('assets/images/nenad-novakovic-xuZTzyXCbTw-unsplash.jpg'),
                          ),
                          Positioned(
                            left: 240,
                            top: 24,
                            child: _buildAvatar('assets/images/dirk-lach-W1RV39u5K5M-unsplash.jpg'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Footer - Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New to Rovio? ',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _showSnackBar('Sign up coming soon', isError: false);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign up',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String imagePath) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}