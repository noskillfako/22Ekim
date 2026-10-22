import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/avatar_service.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final AppState state;

  const AuthScreen({
    super.key,
    required this.state,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isRegister = true;
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController(text: 'Demir Kaya');
  final _emailCtrl = TextEditingController(text: 'berat@habitchain.com');
  final _passwordCtrl = TextEditingController(text: '123456');

  int _age = 24;
  String _gender = 'male'; // 'male', 'female', 'unisex'
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isRegister) {
      widget.state.register(
        fullName: _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        age: _age,
        gender: _gender,
      );
    } else {
      widget.state.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        rememberMe: _rememberMe,
      );
    }
  }

  void _demoQuickLogin() {
    widget.state.login(
      email: 'berat@habitchain.com',
      password: 'demo',
      rememberMe: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewAvatarId = AvatarService.getAvatarId(_age, _gender);
    final avatarData = AvatarService.getAvatarData(previewAvatarId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Logo & Header
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF0284C7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.link_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'HabitChain',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Alışkanlık ve Yaşam Takip Platformu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Auth Switcher Tab (Kayıt Ol vs Giriş Yap)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildAuthTabButton(
                              title: 'Kayıt Ol',
                              isSelected: _isRegister,
                              onTap: () => setState(() => _isRegister = true),
                            ),
                          ),
                          Expanded(
                            child: _buildAuthTabButton(
                              title: 'Giriş Yap',
                              isSelected: !_isRegister,
                              onTap: () => setState(() => _isRegister = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Avatar Preview in Register Mode (avatarskill.md)
                    if (_isRegister) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Yaş ve Cinsiyete Göre Otomatik Avatar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            UserAvatarWidget(
                              avatarId: previewAvatarId,
                              radius: 40,
                              showBadge: true,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              avatarData.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              avatarData.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Form Fields Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_isRegister) ...[
                            TextFormField(
                              controller: _fullNameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Ad Soyad',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Lütfen geçerli bir değer giriniz.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-posta Adresi',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (val) {
                              if (val == null || !val.contains('@') || !val.contains('.')) {
                                return 'Lütfen geçerli bir e-posta adresi giriniz.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.length < 6) {
                                return 'Şifre en az 6 karakter olmalıdır.';
                              }
                              return null;
                            },
                          ),

                          if (_isRegister) ...[
                            const SizedBox(height: 16),
                            // Age Slider / Counter (authskill.md 10-99)
                            Row(
                              children: [
                                const Icon(Icons.cake_outlined, color: AppTheme.textSecondary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Yaşınız: $_age',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline_rounded),
                                  onPressed: _age > 10 ? () => setState(() => _age--) : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceMuted,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('$_age', style: const TextStyle(fontWeight: FontWeight.w700)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline_rounded),
                                  onPressed: _age < 99 ? () => setState(() => _age++) : null,
                                ),
                              ],
                            ),
                            Slider(
                              value: _age.toDouble(),
                              min: 10,
                              max: 99,
                              divisions: 89,
                              activeColor: AppTheme.primary,
                              onChanged: (val) => setState(() => _age = val.toInt()),
                            ),

                            const SizedBox(height: 8),

                            // Gender Selector (authskill.md)
                            DropdownButtonFormField<String>(
                              initialValue: _gender,
                              decoration: const InputDecoration(
                                labelText: 'Cinsiyet',
                                prefixIcon: Icon(Icons.wc_rounded),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'male', child: Text('Erkek')),
                                DropdownMenuItem(value: 'female', child: Text('Kadın')),
                                DropdownMenuItem(value: 'unisex', child: Text('Belirtmek İstemiyorum')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _gender = val);
                              },
                            ),
                          ],

                          if (!_isRegister) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: AppTheme.primary,
                                  onChanged: (val) => setState(() => _rememberMe = val ?? true),
                                ),
                                const Text('Beni Hatırla', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              _isRegister ? 'Kayıt Ol ve Başla' : 'Giriş Yap',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Demo Login Button
                    OutlinedButton.icon(
                      onPressed: _demoQuickLogin,
                      icon: const Icon(Icons.flash_on_rounded, color: Color(0xFFEA580C), size: 18),
                      label: const Text('Demo Hesapla Tek Tıkla Keşfet'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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

  Widget _buildAuthTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
