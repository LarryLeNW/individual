import 'package:ecommerce/data/models/song.model.dart';
import 'package:ecommerce/views/home/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Center(
          child: Text("Home", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: MusicHomepage(),
    );
  }
}

class MusicHomepage extends StatefulWidget {
  const MusicHomepage({super.key});

  @override
  State<MusicHomepage> createState() => _MusicHomepageState();
}

class _MusicHomepageState extends State<MusicHomepage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSong();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool isLoading = songs.isEmpty;
    if (isLoading)
      return getProgressBar();
    else
      return getListView();
  }

  Widget getProgressBar() => const Center(child: CircularProgressIndicator());

  ListView getListView() => ListView.separated(
    itemBuilder: (context, position) {
      return getRow(position);
    },
    separatorBuilder: (context, index) {
      return const Divider(
        color: Colors.grey,
        thickness: 1,
        indent: 24,
        endIndent: 24,
      );
    },
    itemCount: songs.length,
    shrinkWrap: true,
  );

  Widget getRow(int index) {
    return _SongItemSection(song: songs[index], parent: this);
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "title",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Artist: "),
              ],
            ),
          ),
    );
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({required this.song, required this.parent});

  final Song song;
  final _MusicHomepageState parent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          song.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => const Icon(Icons.music_note),
        ),
      ),
      title: Text(
        song.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(song.artist),
      trailing: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          parent._showBottomSheet();
        },
      ),
      onTap: () {
        context.goNamed('Playing', extra: song);
      },
    );
  }
}
