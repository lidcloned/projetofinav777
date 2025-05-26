// YouTubePlayerScreen para o app LAMAFIA - IDCLONED / VAICHATGPT

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/logger.dart';

class YouTubePlayerScreen extends StatefulWidget {
  const YouTubePlayerScreen({super.key});

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  
  // Canal oficial do IDCLONED - LAMAFIA
  final String _channelUrl = 'https://www.youtube.com/channel/IDCLONED_LAMAFIA';
  
  // ID do vídeo mais recente (será substituído pelo real)
  final String _videoId = 'dQw4w9WgXcQ';
  
  @override
  void initState() {
    super.initState();
    _initializePlayer();
    Logger.log('YouTubePlayerScreen iniciada - Canal IDCLONED', 'YouTubePlayer', 'ADMIN');
  }
  
  void _initializePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
        captionLanguage: 'pt',
        forceHD: true,
      ),
    );
    
    _controller.addListener(_playerListener);
  }
  
  void _playerListener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }
  
  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Animate(
              effects: [
                FadeEffect(duration: 800.ms),
                SlideEffect(
                  begin: const Offset(0, -10),
                  end: const Offset(0, 0),
                  duration: 800.ms,
                ),
              ],
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFF9147FF),
                  progressColors: const ProgressBarColors(
                    playedColor: Color(0xFF9147FF),
                    handleColor: Color(0xFF7289DA),
                  ),
                  onReady: () {
                    _isPlayerReady = true;
                    Logger.log('Player do YouTube pronto', 'YouTubePlayer', 'INFO');
                  },
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      player,
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Animate(
              effects: [
                FadeEffect(delay: 300.ms, duration: 800.ms),
              ],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LAMAFIA TV',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9147FF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Canal Oficial do IDCLONED',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Conteúdo Exclusivo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildVideoItem(
                            'Apresentação da Federação LAMAFIA',
                            'assets/images/thumbnail1.jpg',
                            '10:25',
                          ),
                          _buildVideoItem(
                            'Tutorial: Como se juntar ao clã',
                            'assets/images/thumbnail2.jpg',
                            '5:18',
                          ),
                          _buildVideoItem(
                            'Gameplay Exclusiva - Squad LAMAFIA',
                            'assets/images/thumbnail3.jpg',
                            '22:47',
                          ),
                          _buildVideoItem(
                            'Anúncio: Nova Bandeira na Federação',
                            'assets/images/thumbnail4.jpg',
                            '3:52',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Logger.log('Usuário acessou canal completo do YouTube', 'YouTubePlayer', 'ADMIN');
                          // Aqui seria implementada a abertura do canal no navegador
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Visitar Canal Completo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9147FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVideoItem(String title, String thumbnailAsset, String duration) {
    return Animate(
      effects: [
        FadeEffect(delay: 500.ms, duration: 800.ms),
        SlideEffect(
          begin: const Offset(20, 0),
          end: const Offset(0, 0),
          delay: 500.ms,
          duration: 800.ms,
        ),
      ],
      child: Card(
        color: const Color(0xFF2C2F33),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                thumbnailAsset,
                width: 80,
                height: 50,
                fit: BoxFit.cover,
              ),
              const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            duration,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
          trailing: const Icon(Icons.more_vert),
          onTap: () {
            if (_isPlayerReady) {
              Logger.log('Selecionou vídeo: $title', 'YouTubePlayer', 'INFO');
              // Aqui seria implementada a troca de vídeo
            }
          },
        ),
      ),
    );
  }
}

// VAICHATGPT:
// Player de YouTube integrado para o canal oficial do IDCLONED.
// Acesso exclusivo para o administrador (IDCLONED).
// Interface moderna com animações sutis.
// Lista de vídeos sugeridos com thumbnails.
// Parte do sistema de mídia do app, janela para o conteúdo oficial da federação.
