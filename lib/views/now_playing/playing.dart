import 'package:ecommerce/views/now_playing/audio_player_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ecommerce/data/models/song.model.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  late AudioPlayerManager _audioPlayerManager;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    final song =
        GoRouter.of(context).routerDelegate.currentConfiguration.extra as Song;
    _audioPlayerManager = AudioPlayerManager(songUrl: song.source);
    _audioPlayerManager.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song =
        GoRouter.of(context).routerDelegate.currentConfiguration.extra as Song;

    if (song == null) {
      return const Scaffold(body: Center(child: Text("No song data")));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Now Playing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => const SizedBox(
                      height: 200,
                      child: Center(child: Text("Menu Options")),
                    ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(song.album),
            const SizedBox(height: 20),
            ClipOval(
              child: Image.network(
                song.image,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(song.title, style: const TextStyle(fontSize: 24)),
            Text("Artist: ${song.artist}"),
            const SizedBox(height: 32),
            _progressBar(),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 36,
                  onPressed: () {
                    // TODO: previous
                  },
                ),
                const SizedBox(width: 32),
                _playButton(),
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 36,
                  onPressed: () {
                    // TODO: next
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(progress: progress, total: total);
      },
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8),
            width: 48,
            height: 48,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.play();
            },
            icon: Icons.play_arrow,
            color: null,
            size: 48,
          );
        } else if (processingState != ProcessingState.completed) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.pause();
            },
            icon: Icons.pause,
            color: null,
            size: 48,
          );
        } else {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.seek(Duration.zero);
            },
            icon: Icons.replay,
            color: null,
            size: 48,
          );
        }
      },
    );
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
