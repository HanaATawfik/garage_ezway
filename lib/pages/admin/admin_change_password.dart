import 'package:flutter/material.dart';
  import '../../utils/admin_credentials.dart'; // Adjusted import path

  class ChangePasswordPage extends StatefulWidget {
    @override
    _ChangePasswordPageState createState() => _ChangePasswordPageState();
  }

  class _ChangePasswordPageState extends State<ChangePasswordPage> {
    final _formKey = GlobalKey<FormState>();
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    bool _obscureCurrentPassword = true;
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;
    bool _isLoading = false;
    String? _currentStoredPassword;

    @override
    void initState() {
      super.initState();
      _loadCurrentPassword();
    }

    Future<void> _loadCurrentPassword() async {
      // Load the current password for later verification
      _currentStoredPassword = await AdminCredentials.getPassword();
    }

    @override
    void dispose() {
      _currentPasswordController.dispose();
      _newPasswordController.dispose();
      _confirmPasswordController.dispose();
      super.dispose();
    }

    Future<void> _submitForm() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);

      // Verify current password using the stored password
      final currentStoredPassword = await AdminCredentials.getPassword();
      if (_currentPasswordController.text != currentStoredPassword) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Current password is incorrect')),
        );
        return;
      }

      await Future.delayed(Duration(seconds: 2));
      await AdminCredentials.updatePassword(_newPasswordController.text);

      setState(() => _isLoading = false);
      _showSuccessDialog();
    }

    void _showSuccessDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Password Changed",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Text(
            "Your password has been updated successfully.",
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFF25303B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFF25303B),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [SizedBox(height: 20), _buildPasswordForm()],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildHeader(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 26),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 48),
          ],
        ),
      );
    }

    Widget _buildPasswordForm() {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(
              "CURRENT PASSWORD",
              _currentPasswordController,
              _obscureCurrentPassword,
              () => setState(
                () => _obscureCurrentPassword = !_obscureCurrentPassword,
              ),
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildPasswordField(
              "NEW PASSWORD",
              _newPasswordController,
              _obscureNewPassword,
              () => setState(() => _obscureNewPassword = !_obscureNewPassword),
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                final strongPasswordRegex = RegExp(
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$',
                );
                if (!strongPasswordRegex.hasMatch(value)) {
                  return 'Password must contain:\n- 8+ characters\n- 1 uppercase\n- 1 lowercase\n- 1 number\n- 1 special character';
                }
                if (value == _currentPasswordController.text) {
                  return 'New password must be different from the current password';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            SizedBox(height: 16),
            _buildPasswordField(
              "CONFIRM NEW PASSWORD",
              _confirmPasswordController,
              _obscureConfirmPassword,
              () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            _buildUpdateButton(),
          ],
        ),
      );
    }

    Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      bool obscureText,
      VoidCallback onToggleVisibility,
      FormFieldValidator<String> validator,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: onToggleVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red),
              ),
              errorStyle: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      );
    }

    Widget _buildUpdateButton() {
      return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF25303B),
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "UPDATE PASSWORD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    }
  }