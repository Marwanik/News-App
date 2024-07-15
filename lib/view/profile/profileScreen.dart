import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = 'contact.rohanart@gmail.com'; // Default email if not fetched

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'Username';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/image/navbar/profile.png'), // Your uploaded image
            ),
            SizedBox(height: 16),
            Text(
              _userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _userEmail,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32),
            _buildProfileOption(Icons.person, 'My Profile'),
            _buildProfileOption(Icons.settings, 'Settings'),
            _buildProfileOption(Icons.notifications, 'Notifications'),
            _buildProfileOption(Icons.language, 'Language'),
            _buildProfileOption(Icons.help, 'FAQ'),
            _buildProfileOption(Icons.info, 'About App'),
            _buildProfileOption(Icons.logout, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Handle the tap event if needed
      },
    );
  }
}
