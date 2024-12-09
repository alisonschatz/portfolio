
// lib/pages/sections/about_section.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

// SEÇÃO PRINCIPAL - WIDGET
class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

// SEÇÃO PRINCIPAL - STATE
class _AboutSectionState extends State<AboutSection> with SingleTickerProviderStateMixin {
  // Variáveis de estado
  String _selectedFolder = 'personal-info';
  bool _isPersonalInfoExpanded = true;
  bool _isContactsExpanded = true;
  bool _isEducationExpanded = true;
  String _selectedFile = 'bio';
  bool _showEasterEgg = false;
  late AnimationController _ninjaRunController;

  // Inicialização e Limpeza
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
    super.dispose();
  }

  // CONSTRUTOR PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSidebar(),
        _buildMainContent(),
      ],
    );
  }

  // SEÇÃO 1: SIDEBAR
  Widget _buildSidebar() {
    return Container(
      width: 250,
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
              _buildFileItem('email', '✉', content: 'user@gmail.com'),
              _buildFileItem('phone', '📞', content: '+3598246359'),
            ],
          ),
        ],
      ),
    );
  }

  // SEÇÃO 2: CONTEÚDO PRINCIPAL
  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        color: const Color(0xFF011627),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              if (_showEasterEgg) _buildEasterEgg(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFileHeader(),
                  const SizedBox(height: 20),
                  _buildSelectedContent(),
                  _buildTerminal(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SEÇÃO 3: COMPONENTES DA SIDEBAR
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

  // SEÇÃO 4: EASTER EGG
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

  // SEÇÃO 5: HEADER E CONTEÚDO DO ARQUIVO
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

  // SEÇÃO 6: CÓDIGO E SYNTAX HIGHLIGHTING
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

  // SEÇÃO 7: CONTEÚDO DOS ARQUIVOS
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
          _buildCodeLine('  location: "São Paulo, Brasil",', 8),
          _buildCodeLine('  yearsOfExperience: 5,', 9),
          _buildCodeLine('', 10),
          _buildCodeLine('  skills: {', 11),
          _buildCodeLine('    languages: ["JavaScript", "Dart", "Python"],', 12),
          _buildCodeLine('    frameworks: ["React", "Flutter", "Vue.js"],', 13),
          _buildCodeLine('    databases: ["MongoDB", "PostgreSQL"],', 14),
          _buildCodeLine('    tools: ["Git", "Docker", "AWS"]', 15),
          _buildCodeLine('  },', 16),
          _buildCodeLine('', 17),
          _buildCodeLine('  anime: {', 18),
          _buildCodeLine('    favorites: [', 19),
          _buildCodeLine('      "One Piece",', 20),
          _buildCodeLine('      "Attack on Titan",', 21),
          _buildCodeLine('      "Demon Slayer",', 22),
          _buildCodeLine('      "Jujutsu Kaisen"', 23),
          _buildCodeLine('    ],', 24),
          _buildCodeLine('    currentlyWatching: "Chainsaw Man",', 25),
          _buildCodeLine('    watchlist: [', 26),
          _buildCodeLine('      "Bleach: Thousand-Year Blood War",', 27),
          _buildCodeLine('      "Blue Lock",', 28),
          _buildCodeLine('      "Solo Leveling"', 29),
          _buildCodeLine('    ],', 30),
          _buildCodeLine('    genres: ["Shounen", "Action", "Adventure"]', 31),
          _buildCodeLine('  },', 32),
          _buildCodeLine('', 33),
          _buildCodeLine('  hobbies: [', 34),
          _buildCodeLine('    "🎮 Gaming",', 35),
          _buildCodeLine('    "📚 Manga Reading",', 36),
          _buildCodeLine('    "🎵 J-Pop/Anime OSTs",', 37),
          _buildCodeLine('    "✈️ Dream of visiting Japan"', 38),
          _buildCodeLine('  ]', 39),
          _buildCodeLine('};', 40),
        ],
      );
    } else if (_selectedFile == 'interests') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeLine('class AnimeDevInterests {', 1),
          _buildCodeLine('  final Map<String, dynamic> otakuLife = {', 2),
          _buildCodeLine('    "animeConventions": ["Anime Friends", "CCXP"],', 3),
          _buildCodeLine('    "collection": {', 4),
          _buildCodeLine('      "manga": 142,', 5),
          _buildCodeLine('      "figures": 23,', 6),
          _buildCodeLine('      "posters": 15', 7),
          _buildCodeLine('    },', 8),
          _buildCodeLine('    "mangaReading": "Weekly Shonen Jump",', 9),
          _buildCodeLine('    "favoriteStudios": [', 10),
          _buildCodeLine('      "MAPPA",', 11),
          _buildCodeLine('      "Ufotable",', 12),
          _buildCodeLine('      "Studio Ghibli"', 13),
          _buildCodeLine('    ]', 14),
          _buildCodeLine('  };', 15),
          _buildCodeLine('', 16),
          _buildCodeLine('  void dailyRoutine() {', 17),
          _buildCodeLine('    if (newEpisodeAvailable) {', 18),
          _buildCodeLine('      watchAnime();', 19),
          _buildCodeLine('    } else {', 20),
          _buildCodeLine('      writeCode();', 21),
          _buildCodeLine('    }', 22),
          _buildCodeLine('  }', 23),
          _buildCodeLine('}', 24),
        ],
      );
    }
    return const SizedBox();
  }

  // SEÇÃO 8: TERMINAL
  Widget _buildTerminal() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.terminal,
                  color: Color(0xFF607B96),
                  size: 14,
                ),
                SizedBox(width: 8),
                Text(
                  'Terminal',
                  style: TextStyle(
                    color: Color(0xFF607B96),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Terminal Content
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    const Text(
                      'git:(',
                      style: TextStyle(
                        color: Color(0xFFE06C75),
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Text(
                      'main',
                      style: TextStyle(
                        color: Color(0xFF98C379),
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Text(
                      ')',
                      style: TextStyle(
                        color: Color(0xFFE06C75),
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.tealAccent.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}