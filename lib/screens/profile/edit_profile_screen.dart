import 'package:flutter/material.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark          => _c.cardBg;
  Color get _inputBg          => _c.inputBg;
  Color get _green          => _c.green;
  Color get _greenLight          => _c.greenLight;
  Color get _textPrimary          => _c.textPrimary;
  Color get _textMuted          => _c.textMuted;
  Color get _orange          => _c.orange;
  Color get _border          => _c.border;
  Color get _headerBg    => _c.headerBg;

  final _nameCtrl     = TextEditingController(text: 'Sarah Johnson');
  final _emailCtrl    = TextEditingController(text: 'sarah.j@email.com');
  final _phoneCtrl    = TextEditingController(text: '+1 (555) 123-4567');
  final _locationCtrl = TextEditingController(text: 'San Francisco, CA');

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); _locationCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                // Avatar
                Center(child: Stack(children: [
                  Container(width: 88, height: 88,
                      decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(22), border: Border.all(color: _green.withOpacity(0.3), width: 1.5)),
                      child: Icon(Icons.eco_rounded, color: _greenLight, size: 42)),
                  Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: _orange, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14))),
                ])),
                const SizedBox(height: 28),
                // Fields
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: _border, width: 1)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _fieldLabel('Full Name'),   const SizedBox(height: 6),
                    _inputField(_nameCtrl,     Icons.person_outline_rounded),
                    const SizedBox(height: 16),
                    _fieldLabel('Email'),        const SizedBox(height: 6),
                    _inputField(_emailCtrl,    Icons.mail_outline_rounded,    type: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _fieldLabel('Phone'),        const SizedBox(height: 6),
                    _inputField(_phoneCtrl,    Icons.phone_outlined,           type: TextInputType.phone),
                    const SizedBox(height: 16),
                    _fieldLabel('Location'),     const SizedBox(height: 6),
                    _inputField(_locationCtrl, Icons.location_on_outlined),
                  ]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green, foregroundColor: Colors.white, elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
              child: Container(width: 38, height: 38, decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                  child: Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20)),
            ),
            const SizedBox(width: 14),
            Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
          ]),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) => Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.4));

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