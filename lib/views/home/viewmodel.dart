import 'dart:async';
import 'package:ecommerce/data/models/song.model.dart';
import 'package:ecommerce/data/repository/song.repository.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStream = StreamController();

  void loadSong() {
    final repository = DefaultRepository();
    repository.loadData().then((value) => songStream.add(value!));
  }
}
