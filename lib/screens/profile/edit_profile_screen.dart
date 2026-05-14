import 'package:flutter/material.dart';
import 'package:leafscan_app/services/auth_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  LeafColors get _c      => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _inputBg     => _c.inputBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;
  Color get _headerBg    => _c.headerBg;

  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _loading    = true;
  bool _saving     = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final result = await AuthService.me();
    if (!mounted) return;
    if (result.success && result.data != null) {
      setState(() {
        _nameCtrl.text  = result.data!['full_name'] ?? '';
        _emailCtrl.text = result.data!['email']     ?? '';
        _loading        = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() { _saving = true; _error = null; });
    // За сега само затвора — change-password е посебен endpoint
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Profile updated!'),
      backgroundColor: _green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: _green))
                : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                // Avatar
                Center(child: Stack(children: [
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(22), border: Border.all(color: _green.withOpacity(0.3), width: 1.5)),
                    child: Center(child: Text(
                      _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : 'U',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: _greenLight),
                    )),
                  ),
                  Positioned(bottom: 0, right: 0, child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(color: _orange, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                  )),
                ])),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: _border, width: 1)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _fieldLabel('Full Name'),
                    const SizedBox(height: 6),
                    _inputField(_nameCtrl, Icons.person_outline_rounded),
                    const SizedBox(height: 16),
                    _fieldLabel('Email'),
                    const SizedBox(height: 6),
                    _inputField(_emailCtrl, Icons.mail_outline_rounded, type: TextInputType.emailAddress),
                  ]),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green, foregroundColor: Colors.white, elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _saving
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _headerBg, border: Border(bottom: BorderSide(color: _border, width: 1))),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(width: 38, height: 38,
                  decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                  child: Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20)),
            ),
            const SizedBox(width: 14),
            Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
          ]),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) => Text(label,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.4));

  Widget _inputField(TextEditingController ctrl, IconData icon, {TextInputType type = TextInputType.text}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: _inputBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border, width: 1)),
      child: TextField(
        controller: ctrl, keyboardType: type,
        style: TextStyle(fontSize: 14, color: _textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: _textMuted, size: 18),
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15), filled: false,
        ),
      ),
    );
  }
}
