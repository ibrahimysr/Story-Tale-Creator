import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/space_theme.dart';
import '../../../core/theme/widgets/starry_background.dart';
import '../../viewmodels/profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  bool _isLoading = false;
  String _selectedAvatar = 'boy (1).png';

  final List<String> _avatars = [
    'boy (1).png', 'boy (2).png', 'boy (3).png', 'boy (4).png', 'boy (5).png',
    'boy (6).png', 'boy (7).png', 'boy (8).png', 'boy (9).png', 'boy (10).png',
    'girl (1).png', 'girl (2).png', 'girl (3).png', 'girl (4).png', 'girl (5).png',
    'girl (6).png', 'girl (7).png', 'girl (8).png', 'girl (9).png', 'girl (10).png',
  ];

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ProfileViewModel>();
    final profile = viewModel.userProfile;
    
    _nameController = TextEditingController(text: profile?.name ?? '');
    _usernameController = TextEditingController(text: profile?.username ?? '');
    _selectedAvatar = profile?.avatar ?? 'boy (1).png';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
        child: Stack(
          children: [
            const StarryBackground(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 30),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: SpaceTheme.accentGold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text(
          'Profili Düzenle',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarSelector(),
                const SizedBox(height: 20),
                _buildInputField(
                  'İsim',
                  'Görünen adınızı girin',
                  _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İsim boş bırakılamaz';
                    }
                    if (value.length < 2) {
                      return 'İsim en az 2 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  'Kullanıcı Adı',
                  'Benzersiz kullanıcı adınızı girin',
                  _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kullanıcı adı boş bırakılamaz';
                    }
                    if (value.length < 3) {
                      return 'Kullanıcı adı en az 3 karakter olmalıdır';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'Sadece harf, rakam ve alt çizgi kullanılabilir';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentBlue),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Değişiklikleri Kaydet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avatar',
          style: TextStyle(
            color: SpaceTheme.accentGold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              final isSelected = avatar == _selectedAvatar;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? SpaceTheme.accentGold : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar/$avatar'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: SpaceTheme.accentGold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: SpaceTheme.accentGold.withOpacity(0.5),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.withOpacity(0.5),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.withOpacity(0.5),
                width: 2,
              ),
            ),
            errorStyle: TextStyle(
              color: Colors.red[300],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final viewModel = context.read<ProfileViewModel>();
      await viewModel.updateProfile(
        name: _nameController.text,
        username: _usernameController.text,
        avatar: _selectedAvatar,
      );

      if (!mounted) return;

      if (viewModel.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
} 