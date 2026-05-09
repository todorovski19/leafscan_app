import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark          => _c.cardBg;
  Color get _inputBg          => _c.inputBg;
  Color get _green          => _c.green;
  Color get _greenLight          => _c.greenLight;
  Color get _textPrimary          => _c.textPrimary;
  Color get _textMuted          => _c.textMuted;
  Color get _border          => _c.border;
  Color get _headerBg    => _c.headerBg;

  static const String _supportEmail = 'support@plantcare-ai.app';

  static const List<_Faq> _faqs = [
    _Faq(
      question: 'How does PlantCare AI identify plant diseases?',
      answer:
          'Take or upload a clear photo of the affected plant leaf. Our AI model analyzes the image '
          'and compares it against thousands of known disease patterns to identify the most likely '
          'condition, along with treatment recommendations.',
    ),
    _Faq(
      question: 'How accurate are the scan results?',
      answer:
          'The model is highly accurate for common diseases under good lighting conditions, but '
          'results should be treated as guidance, not a final diagnosis. For high-value crops or '
          'unusual symptoms, consult a local agronomist or extension service.',
    ),
    _Faq(
      question: 'What makes a good scan photo?',
      answer:
          'Use natural daylight, fill the frame with the affected leaf, hold the camera steady, '
          'and avoid heavy shadows. Photographing both the top and underside of the leaf can also '
          'improve detection of certain pests and fungi.',
    ),
    _Faq(
      question: 'Are my photos and data private?',
      answer:
          'Your scans are linked to your account and used to power your personal history. We do '
          'not share your images with third parties. See our Terms & Privacy page for full '
          'details on data handling.',
    ),
    _Faq(
      question: 'Why does a scan sometimes fail?',
      answer:
          'Scans can fail when the photo is blurry, too dark, too far from the plant, or when the '
          'subject is not a leaf. Re-take the photo following the tips above, and make sure you '
          'have a stable internet connection.',
    ),
    _Faq(
      question: 'How do I delete my account?',
      answer:
          'Go to Settings → Security to manage your account. To fully delete your account and '
          'data, contact our support team using the form below.',
    ),
  ];

  final TextEditingController _reportCtrl = TextEditingController();
  bool _submittingReport = false;

  @override
  void dispose() {
    _reportCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? const Color(0xFFE05252) : _green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<void> _copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: _supportEmail));
    _snack('Email copied to clipboard');
  }

  Future<void> _submitReport() async {
    final text = _reportCtrl.text.trim();
    if (text.length < 10) {
      _snack('Please describe the issue (at least 10 characters)', error: true);
      return;
    }
    setState(() => _submittingReport = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _submittingReport = false;
      _reportCtrl.clear();
    });
    _snack('Report sent. Thanks for the feedback!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                _buildHeroCard(),
                const SizedBox(height: 24),
                _sectionLabel('Frequently Asked Questions'),
                const SizedBox(height: 10),
                _card(
                  children: List.generate(_faqs.length, (i) {
                    return Column(
                      children: [
                        _FaqTile(faq: _faqs[i]),
                        if (i != _faqs.length - 1) _divider(),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 24),
                _sectionLabel('Contact Us'),
                const SizedBox(height: 10),
                _card(children: [
                  _contactRow(
                    icon: Icons.mail_outline_rounded,
                    title: 'Email Support',
                    value: _supportEmail,
                    actionIcon: Icons.copy_rounded,
                    onTap: _copyEmail,
                  ),
                  _divider(),
                  _contactRow(
                    icon: Icons.schedule_rounded,
                    title: 'Response Time',
                    value: 'Within 24-48 hours',
                  ),
                ]),
                const SizedBox(height: 24),
                _sectionLabel('Report a Problem'),
                const SizedBox(height: 10),
                _buildReportCard(),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'PlantCare AI · v1.0.0',
                    style: TextStyle(fontSize: 11, color: _textMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _headerBg,
          border: Border(bottom: BorderSide(color: _border, width: 1)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Text('Help Center',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
            ]),
          ),
        ),
      );

  Widget _buildHeroCard() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border, width: 1),
        ),
        child: Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _green.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _green.withOpacity(0.3)),
            ),
            child: Icon(Icons.support_agent_rounded, color: _greenLight, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('How can we help?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _textPrimary)),
              SizedBox(height: 4),
              Text('Browse common questions or send us a message — we usually reply within a day.',
                  style: TextStyle(fontSize: 12, color: _textMuted, height: 1.4)),
            ]),
          ),
        ]),
      );

  Widget _sectionLabel(String text) => Text(text,
      style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5));

  Widget _card({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border, width: 1),
        ),
        child: Column(children: children),
      );

  Widget _divider() => Divider(height: 1, thickness: 0.8, indent: 16, endIndent: 16, color: _border);

  Widget _contactRow({
    required IconData icon,
    required String title,
    required String value,
    IconData? actionIcon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _green.withOpacity(0.13),
              shape: BoxShape.circle,
              border: Border.all(color: _green.withOpacity(0.2)),
            ),
            child: Icon(icon, color: _greenLight, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 12, color: _textMuted)),
            ]),
          ),
          if (actionIcon != null) Icon(actionIcon, color: _textMuted, size: 18),
        ]),
      ),
    );
  }

  Widget _buildReportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tell us what went wrong',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
        const SizedBox(height: 4),
        Text('Share as much detail as you can — steps to reproduce, what you expected, etc.',
            style: TextStyle(fontSize: 12, color: _textMuted, height: 1.4)),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border, width: 1),
          ),
          child: TextField(
            controller: _reportCtrl,
            minLines: 4,
            maxLines: 8,
            maxLength: 1000,
            style: TextStyle(fontSize: 14, color: _textPrimary),
            decoration: InputDecoration(
              hintText: 'Describe the issue…',
              hintStyle: TextStyle(color: _textMuted, fontSize: 14),
              counterStyle: TextStyle(color: _textMuted, fontSize: 11),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _submittingReport ? null : _submitReport,
            icon: _submittingReport
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_submittingReport ? 'Sending…' : 'Send Report',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Faq {
  final String question;
  final String answer;
  const _Faq({required this.question, required this.answer});
}

class _FaqTile extends StatelessWidget {
  final _Faq faq;
  const _FaqTile({required this.faq});

  @override
  Widget build(BuildContext context) {
    final c = LeafColors.of(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: c.textMuted,
        collapsedIconColor: c.textMuted,
        title: Text(
          faq.question,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              faq.answer,
              style: TextStyle(
                fontSize: 13,
                color: c.textMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
