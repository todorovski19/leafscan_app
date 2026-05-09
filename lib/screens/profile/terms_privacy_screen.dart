import 'package:flutter/material.dart';

class TermsPrivacyScreen extends StatefulWidget {
  const TermsPrivacyScreen({super.key});

  @override
  State<TermsPrivacyScreen> createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _border      = Color(0xFF243028);

  static const String _lastUpdated = 'Last updated: May 9, 2026';

  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildPage(_termsSections),
                _buildPage(_privacySections),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A211D),
          border: Border(bottom: BorderSide(color: Color(0xFF243028), width: 1)),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
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
                      child: const Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text('Terms & Privacy',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
                ]),
              ),
              TabBar(
                controller: _tabs,
                indicatorColor: _greenLight,
                indicatorWeight: 2.5,
                labelColor: _textPrimary,
                unselectedLabelColor: _textMuted,
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Terms of Service'),
                  Tab(text: 'Privacy Policy'),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildPage(List<_Section> sections) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _green.withOpacity(0.25)),
          ),
          child: Row(children: [
            const Icon(Icons.update_rounded, color: _greenLight, size: 16),
            const SizedBox(width: 10),
            Text(_lastUpdated,
                style: const TextStyle(fontSize: 12, color: _greenLight, fontWeight: FontWeight.w600)),
          ]),
        ),
        const SizedBox(height: 20),
        ...sections.map(_buildSection),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'PlantCare AI · v1.0.0',
            style: const TextStyle(fontSize: 11, color: _textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(_Section s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, color: _textPrimary)),
        const SizedBox(height: 8),
        Text(s.body,
            style: const TextStyle(fontSize: 13, color: _textMuted, height: 1.55)),
      ]),
    );
  }

  // ── Terms of Service ──────────────────────────────────────────────────────
  static const List<_Section> _termsSections = [
    _Section(
      title: '1. Acceptance of Terms',
      body:
          'By creating an account or using the PlantCare AI mobile application ("the App"), you '
          'agree to be bound by these Terms of Service. If you do not agree, do not install or '
          'continue to use the App.',
    ),
    _Section(
      title: '2. Description of Service',
      body:
          'PlantCare AI provides image-based plant disease detection, care recommendations, and '
          'related educational content. The App is intended as a guidance tool only and is not a '
          'substitute for professional agronomic advice, laboratory diagnosis, or veterinary or '
          'medical care for animals or humans.',
    ),
    _Section(
      title: '3. Eligibility',
      body:
          'You must be at least 13 years old to use the App. If you are under the age of majority '
          'in your jurisdiction, you must use the App under the supervision of a parent or legal '
          'guardian who agrees to these Terms on your behalf.',
    ),
    _Section(
      title: '4. Account Registration',
      body:
          'You are responsible for keeping your account credentials secure. You agree to provide '
          'accurate registration information and to notify us promptly of any unauthorized use of '
          'your account. You are responsible for all activity that occurs under your account.',
    ),
    _Section(
      title: '5. User Content',
      body:
          'You retain ownership of the photos, text, and other content you upload to the App '
          '("User Content"). By submitting User Content, you grant PlantCare AI a worldwide, '
          'non-exclusive, royalty-free license to host, store, process, and display that content '
          'solely for the purpose of operating, improving, and securing the Service.',
    ),
    _Section(
      title: '6. Acceptable Use',
      body:
          'You agree not to: (a) use the App for any unlawful purpose; (b) upload content that '
          'infringes the rights of others or contains malware; (c) attempt to reverse engineer, '
          'decompile, or interfere with the App or its underlying models; (d) use automated means '
          'to access the Service in a way that places undue load on our infrastructure.',
    ),
    _Section(
      title: '7. Intellectual Property',
      body:
          'The App, including its software, models, branding, and content (excluding User '
          'Content), is owned by PlantCare AI and its licensors and is protected by copyright, '
          'trademark, and other laws. You are granted a limited, revocable, non-transferable '
          'license to use the App for personal, non-commercial purposes.',
    ),
    _Section(
      title: '8. Disclaimer of Warranties',
      body:
          'The App is provided on an "as is" and "as available" basis. PlantCare AI disclaims all '
          'warranties, express or implied, including merchantability, fitness for a particular '
          'purpose, and non-infringement. We do not warrant that disease detection results are '
          'accurate, complete, or suitable for any particular crop or situation.',
    ),
    _Section(
      title: '9. Limitation of Liability',
      body:
          'To the maximum extent permitted by law, PlantCare AI shall not be liable for any '
          'indirect, incidental, special, consequential, or punitive damages, including loss of '
          'crops, profits, data, or goodwill, arising out of or related to your use of the App.',
    ),
    _Section(
      title: '10. Termination',
      body:
          'We may suspend or terminate your access to the App at any time if you violate these '
          'Terms. You may stop using the App and delete your account at any time. Sections that '
          'by their nature should survive termination (e.g., intellectual property, disclaimers, '
          'limitations of liability) will survive.',
    ),
    _Section(
      title: '11. Changes to These Terms',
      body:
          'We may update these Terms from time to time. When we make material changes, we will '
          'notify you in the App or by email. Continued use of the App after the effective date '
          'of the updated Terms constitutes acceptance of the changes.',
    ),
    _Section(
      title: '12. Governing Law',
      body:
          'These Terms are governed by the laws of the jurisdiction in which PlantCare AI is '
          'established, without regard to its conflict of laws principles. Any disputes arising '
          'out of these Terms shall be resolved in the competent courts of that jurisdiction.',
    ),
    _Section(
      title: '13. Contact',
      body:
          'Questions about these Terms can be sent to support@plantcare-ai.app.',
    ),
  ];

  // ── Privacy Policy ────────────────────────────────────────────────────────
  static const List<_Section> _privacySections = [
    _Section(
      title: '1. Introduction',
      body:
          'This Privacy Policy describes how PlantCare AI collects, uses, and protects your '
          'personal information when you use the App. By using the App, you consent to the '
          'practices described here.',
    ),
    _Section(
      title: '2. Information We Collect',
      body:
          'We collect: (a) account information you provide, such as name, email, and password; '
          '(b) content you upload, including plant photos and notes; (c) usage data, such as '
          'features used and crash reports; (d) device data, such as device model, OS version, '
          'and approximate region.',
    ),
    _Section(
      title: '3. How We Use Your Information',
      body:
          'We use your information to: (a) operate and improve the App and its disease detection '
          'models; (b) authenticate you and protect your account; (c) personalize your scan '
          'history and recommendations; (d) communicate important updates, security notices, and '
          'optional product news; (e) detect, prevent, and address abuse, fraud, and technical '
          'issues.',
    ),
    _Section(
      title: '4. Camera and Photos',
      body:
          'The App requests access to your camera and photo library so you can submit plant '
          'images for analysis. Photos are processed on our servers to generate scan results and '
          'are stored against your account so you can review your history. You can delete '
          'individual scans at any time.',
    ),
    _Section(
      title: '5. Data Sharing',
      body:
          'We do not sell your personal information. We share data only with: (a) service '
          'providers who host our infrastructure and run our models, under strict contractual '
          'safeguards; (b) authorities when required by law or to protect rights and safety. '
          'Aggregated, de-identified data may be used for research and to improve the App.',
    ),
    _Section(
      title: '6. Data Retention',
      body:
          'We keep your account information and scan history while your account is active. If '
          'you delete your account, we delete or anonymize your personal data within 30 days, '
          'except where we are required to retain it for legal, security, or fraud-prevention '
          'reasons.',
    ),
    _Section(
      title: '7. Security',
      body:
          'We use industry-standard measures including encryption in transit, encrypted storage, '
          'and access controls to protect your data. No system is perfectly secure — please '
          'choose a strong password and notify us immediately if you suspect unauthorized access.',
    ),
    _Section(
      title: '8. Your Rights',
      body:
          'Depending on your jurisdiction, you may have the right to access, correct, delete, or '
          'export your personal data, and to object to or restrict certain processing. Contact us '
          'using the email below to exercise any of these rights.',
    ),
    _Section(
      title: '9. Children\'s Privacy',
      body:
          'The App is not directed to children under 13. We do not knowingly collect personal '
          'information from children under 13. If you believe a child has provided us with '
          'personal information, please contact us so we can delete it.',
    ),
    _Section(
      title: '10. International Transfers',
      body:
          'Your data may be processed in countries other than where you live. We take steps to '
          'ensure that any cross-border transfer is governed by appropriate safeguards consistent '
          'with applicable law.',
    ),
    _Section(
      title: '11. Changes to This Policy',
      body:
          'We may update this Privacy Policy. We will post the new effective date at the top of '
          'this page and, when changes are material, notify you in the App or by email.',
    ),
    _Section(
      title: '12. Contact',
      body:
          'For privacy-related questions or requests, email privacy@plantcare-ai.app.',
    ),
  ];
}

class _Section {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});
}
