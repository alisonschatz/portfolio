import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

// SEÇÃO 1: MODELOS E CLASSES AUXILIARES
class TerminalEntry {
  final String command;
  final String response;
  final bool isError;

  TerminalEntry(this.command, this.response, {this.isError = false});
}

// SEÇÃO 2: WIDGET PRINCIPAL
class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

// SEÇÃO 3: STATE E GERENCIAMENTO DE ESTADO
class _AboutSectionState extends State<AboutSection> with SingleTickerProviderStateMixin {
  String _selectedFolder = 'personal-info';
  bool _isPersonalInfoExpanded = true;
  bool _isContactsExpanded = true;
  bool _isEducationExpanded = true;
  String _selectedFile = 'bio';
  bool _showEasterEgg = false;
  late AnimationController _ninjaRunController;

  final TextEditingController _terminalController = TextEditingController();
  final FocusNode _terminalFocus = FocusNode();
  final List<TerminalEntry> _terminalHistory = [];
  bool _showPowerLevel = false;
  int _powerLevel = 0;

  @override
  void initState() {
    super.initState();
    _ninjaRunController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ninjaRunController.dispose();
    _terminalController.dispose();
    _terminalFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 120,
      child: Row(
        children: [
          _buildSidebar(),
          _buildMainContent(),
        ],
      ),
    );
  }

  // SEÇÃO 4: SIDEBAR
  Widget _buildSidebar() {
    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF011627),
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildFolderSection(
            'personal-info',
            isExpanded: _isPersonalInfoExpanded,
            onToggle: () => setState(() => _isPersonalInfoExpanded = !_isPersonalInfoExpanded),
            children: [
              _buildFileItem('bio', '📝', isSelected: _selectedFile == 'bio'),
              _buildFileItem('interests', '🎮', isSelected: _selectedFile == 'interests'),
              _buildFileItem('anime', '🍜', isSelected: _selectedFile == 'anime'),
            ],
          ),
          _buildFolderSection(
            'contacts',
            isExpanded: _isContactsExpanded,
            onToggle: () => setState(() => _isContactsExpanded = !_isContactsExpanded),
            children: [
              _buildFileItem('email', '✉', content: 'alisonschatz1@gmail.com'),
              _buildFileItem('phone', '📞', content: '+55 47 9 9293-5133'),
            ],
          ),
        ],
      ),
    );
  }
  // SEÇÃO 5: COMPONENTES DA SIDEBAR
  Widget _buildFolderSection(String title, {
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  color: const Color(0xFF607B96),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF607B96),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _buildFileItem(String name, String icon, {String? content, bool isSelected = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Colors.tealAccent.withOpacity(0.5) : Colors.transparent,
          ),
        ),
        child: InkWell(
          onTap: () => setState(() {
            _selectedFile = name;
            _showEasterEgg = false;
          }),
          child: Row(
            children: [
              Text(icon),
              const SizedBox(width: 8),
              Text(
                content ?? name,
                style: TextStyle(
                  color: isSelected ? Colors.tealAccent : const Color(0xFF607B96),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SEÇÃO 6: CONTEÚDO PRINCIPAL
  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        height: double.infinity,
        color: const Color(0xFF011627),
        child: Column(
          children: [
            // Conteúdo principal com scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    if (_showEasterEgg) _buildEasterEgg(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFileHeader(),
                        const SizedBox(height: 20),
                        _buildSelectedContent(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Terminal fixo na parte inferior
            _buildTerminal(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileHeader() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _showEasterEgg = !_showEasterEgg),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.code,
                color: Color(0xFF607B96),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '${_selectedFile}.js',
                style: const TextStyle(
                  color: Color(0xFF607B96),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SEÇÃO 7: EASTER EGGS E ANIMAÇÕES
  Widget _buildEasterEgg() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _showEasterEgg ? 1.0 : 0.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Text(
              "🎉 You found a secret! 🎉",
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildRunningNinja(),
            const SizedBox(height: 10),
            const Text(
              "Ninja dev mode activated!",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunningNinja() {
    return AnimatedBuilder(
      animation: _ninjaRunController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            100 * math.sin(_ninjaRunController.value * 2 * math.pi),
            0,
          ),
          child: const Text(
            "🥷",
            style: TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }

  // SEÇÃO 8: TERMINAL
  Widget _buildTerminal() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTerminalHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: _buildTerminalContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.terminal,
            color: Color(0xFF607B96),
            size: 14,
          ),
          const SizedBox(width: 8),
          const Text(
            'Terminal',
            style: TextStyle(
              color: Color(0xFF607B96),
              fontSize: 12,
            ),
          ),
          const Spacer(),
          if (_showPowerLevel) Text(
            'Power Level: $_powerLevel',
            style: const TextStyle(
              color: Color(0xFF4EC9B0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_terminalHistory.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '// Tip: Type "help" to see available commands',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontFamily: 'monospace',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ..._buildTerminalHistory(),
          _buildTerminalInput(),
        ],
      ),
    );
  }

  List<Widget> _buildTerminalHistory() {
    return _terminalHistory.map((entry) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTerminalPrompt(entry.command),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 4, bottom: 8),
          child: Text(
            entry.response,
            style: TextStyle(
              color: entry.isError ? const Color(0xFFE06C75) : Colors.white70,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    )).toList();
  }

  Widget _buildTerminalPrompt([String? command]) {
    return Row(
      children: [
        const Text(
          '➜',
          style: TextStyle(
            color: Color(0xFF4EC9B0),
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '~/portfolio',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '\$${command != null ? ' $command' : ''}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildTerminalInput() {
    return Row(
      children: [
        _buildTerminalPrompt(),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _terminalController,
            focusNode: _terminalFocus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            onSubmitted: _handleTerminalCommand,
          ),
        ),
      ],
    );
  }

  void _handleTerminalCommand(String command) {
    String response;
    bool isError = false;

    switch (command.toLowerCase()) {
      case 'help':
        response = '''Available commands:
- help - Show this help message
- clear - Clear terminal
- whoami - Display user info
- power-up - Increase power level
- skills - List developer skills
- secret - Try to find out!
- coffee - Get coffee
- ping - Pong!''';
        break;

      case 'clear':
        setState(() {
          _terminalHistory.clear();
          _terminalController.clear();
        });
        return;

      case 'whoami':
        response = 'Alison Schatz - Front-end Developer & Anime Enthusiast 🎮';
        break;

      case 'power-up':
        _powerLevel += 1000;
        setState(() => _showPowerLevel = true);
        response = _powerLevel >= 9000 
            ? "IT'S OVER 9000!!!" 
            : 'Power Level increased to $_powerLevel';
        break;

      case 'skills':
        response = '''🚀 Developer Skills:
- JavaScript, Dart
- React, Flutter
- Git, Docker, Firebase''';
        break;

      case 'secret':
        response = '🤫 Shh... try typing "kamehameha"';
        break;

      case 'kamehameha':
        response = '💥 KAMEHAMEHA!!! You found a secret command!';
        setState(() => _showEasterEgg = true);
        break;

      case 'coffee':
        response = '☕ Here\'s your coffee! Warning: May contain code.';
        break;

      case 'ping':
        response = 'pong! 🏓';
        break;

      case 'sudo':
        response = 'Nice try! 😎';
        break;

      default:
        response = 'Command not found. Type "help" for available commands.';
        isError = true;
    }

    setState(() {
      _terminalHistory.add(TerminalEntry(command, response, isError: isError));
      _terminalController.clear();
    });
  }

  Color _getCodeColor(String text) {
    if (text.startsWith('//')) {
      return const Color(0xFF676E95);
    } else if (text.startsWith('class') || text.startsWith('function') || text.startsWith('const')) {
      return const Color(0xFFB31D6F);
    } else if (text.contains(':') && !text.contains('{') && !text.contains('[')) {
      return const Color(0xFF4876D9);
    } else if (text.contains('"')) {
      return const Color(0xFF89CA78);
    } else if (text.contains('{') || text.contains('}') || text.contains('[') || text.contains(']')) {
      return const Color(0xFFFFFFFF);
    }
    return const Color(0xFF607B96);
  }
Widget _buildSelectedContent() {
    if (_selectedFile == 'bio') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeLine('/**', 1),
          _buildCodeLine(' * About me', 2),
          _buildCodeLine(' */', 3),
          _buildCodeLine('', 4),
          _buildCodeLine('const developer = {', 5),
          _buildCodeLine('  name: "Alison Schatz",', 6),
          _buildCodeLine('  title: "Front-end Developer",', 7),
          _buildCodeLine('  location: "Blumenau, Santa Catarina",', 8),
          _buildCodeLine('  yearsOfExperience: 5,', 9),
          _buildCodeLine('', 10),
          _buildCodeLine('  skills: {', 11),
          _buildCodeLine('    languages: ["JavaScript", "Dart"],', 12),
          _buildCodeLine('    frameworks: ["React", "Flutter"],', 13),
          _buildCodeLine('    tools: ["Git", "Docker", "Firebase"],', 14),
          _buildCodeLine('  },', 15),
          _buildCodeLine('', 16),
          _buildCodeLine('  contacts: {', 17),
          _buildCodeLine('    email: "alisonschatz1@gmail.com",', 18),
          _buildCodeLine('    phone: "+55 47 9 9293-5133"', 19),
          _buildCodeLine('  }', 20),
          _buildCodeLine('};', 21),
        ],
      );
    } else if (_selectedFile == 'anime') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeLine('class AnimeLife {', 1),
          _buildCodeLine('  final String devMode = "Otaku Developer";', 2),
          _buildCodeLine('', 3),
          _buildCodeLine('  final Map<String, dynamic> favorites = {', 4),
          _buildCodeLine('    "HunterXHunter": {', 5),
          _buildCodeLine('      "why": "Best power system ever - Nen 💪",', 6),
          _buildCodeLine('      "favoriteChar": "Killua",', 7),
          _buildCodeLine('      "bestArc": "Chimera Ant"', 8),
          _buildCodeLine('    },', 9),
          _buildCodeLine('    "OnePiece": {', 10),
          _buildCodeLine('      "why": "Epic worldbuilding and freedom",', 11),
          _buildCodeLine('      "favoriteChar": "Luffy",', 12),
          _buildCodeLine('      "bestArc": "Wano"', 13),
          _buildCodeLine('    },', 14),
          _buildCodeLine('    "FullmetalAlchemist": {', 15),
          _buildCodeLine('      "why": "Perfect story and characters",', 16),
          _buildCodeLine('      "favoriteChar": "Roy Mustang",', 17),
          _buildCodeLine('      "bestMoment": "Equivalent Exchange"', 18),
          _buildCodeLine('    },', 19),
          _buildCodeLine('    "Frieren": {', 20),
          _buildCodeLine('      "why": "Beautiful story about time",', 21),
          _buildCodeLine('      "favoriteChar": "Frieren",', 22),
          _buildCodeLine('      "bestQuote": "Time flows differently for elves"', 23),
          _buildCodeLine('    },', 24),
          _buildCodeLine('    "Overlord": {', 25),
          _buildCodeLine('      "why": "Sasuga Ainz-sama!",', 26),
          _buildCodeLine('      "favoriteChar": "Demiurge",', 27),
          _buildCodeLine('      "bestMoment": "Splat. Splat. Splat."', 28),
          _buildCodeLine('    },', 29),
          _buildCodeLine('  };', 30),
          _buildCodeLine('', 31),
          _buildCodeLine('  void currentlyWatching() {', 32),
          _buildCodeLine('    if (newEpisodeAvailable) {', 33),
          _buildCodeLine('      watchNow("Shangri-la Frontier");', 34),
          _buildCodeLine('      print("MMO anime with great animation! 🎮");', 35),
          _buildCodeLine('    }', 36),
          _buildCodeLine('  }', 37),
          _buildCodeLine('', 38),
          _buildCodeLine('  Future<void> watchlist() async {', 39),
          _buildCodeLine('    await Future.forEach([', 40),
          _buildCodeLine('      "Arcane - League of Legends",', 41),
          _buildCodeLine('      "// Can\'t wait for season 2!"', 42),
          _buildCodeLine('    ], (anime) => addToList(anime));', 43),
          _buildCodeLine('  }', 44),
          _buildCodeLine('}', 45),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildCodeLine(String text, int lineNumber) {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Text(
                lineNumber.toString(),
                style: const TextStyle(
                  color: Color(0xFF607B96),
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _getCodeColor(text),
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}