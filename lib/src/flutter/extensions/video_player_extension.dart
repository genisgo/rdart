part of 'extensions.dart';

// Extensions d'analytics pour VideoPlayerPlus (Rdart, base Relement)
// Mesure : progression (tick régulier), pause, reprise, quartiles 25/50/75/100,
// résumé d'usage, métadonnées vidéo. Aucune dépendance externe.
//
// ⚠️ Prérequis : le widget VideoPlayerPlus doit avoir été créé/monté
// (appelez `create()` puis utilisez `getElement`). L'extension va retrouver
// l'élément <video> en DOM sous la racine du player.

// --------------------------- Modèles -----------------------------------------
class VideoProgress {
  final double current; // secondes lues
  final double duration; // secondes total
  final double percent; // 0..1
  final double buffered; // 0..1
  final double playbackRate; // 0.5..2.0
  final bool paused;
  const VideoProgress({
    required this.current,
    required this.duration,
    required this.percent,
    required this.buffered,
    required this.playbackRate,
    required this.paused,
  });
}

class VideoMetadata {
  final double duration; // s
  final int width; // pixels vidéo
  final int height; // pixels vidéo
  final double aspect; // width/height
  final String src; // URL courante
  final String? sourceLabel; // label si reconnu par sources[]
  final String? mimeType; // type si reconnu
  const VideoMetadata({
    required this.duration,
    required this.width,
    required this.height,
    required this.aspect,
    required this.src,
    this.sourceLabel,
    this.mimeType,
  });
}

class VideoAnalyticsSummary {
  final int pauses; // nb pauses
  final int resumes; // nb reprises
  final double watched; // secondes de contenu réellement visionnées
  final Set<int> quartiles; // ex: {25, 50, 75, 100}
  const VideoAnalyticsSummary({
    required this.pauses,
    required this.resumes,
    required this.watched,
    required this.quartiles,
  });
}

// --------------------------- État interne (attaché par Expando) -------------
class _VAState {
  VideoElement? video;
  Timer? timer;
  StreamSubscription<Event>? onPlay, onPause, onTime, onLoadedMeta, onProgress;
  double lastTime = 0.0; // dernière timeupdate lue
  double watched = 0.0; // somme des deltas forward
  int pauses = 0;
  int resumes = 0;
  final Set<int> quartiles = <int>{};
  void dispose() {
    onPlay?.cancel();
    onPause?.cancel();
    onTime?.cancel();
    onProgress?.cancel();
    onLoadedMeta?.cancel();
    // if (timer != null && timer!.isActive) {
    //   timer?.cancel();
    // }
  }
}

// final _state = Expando<_VAState>('video-analytics');
final _states = <VideoPlayer, _VAState?>{};

// --------------------------- Extensions publiques ---------------------------
extension VideoPlayerPlusAnalyticsExt on VideoPlayer {
  // Récupère l'élément <video> rendu par ce player (après create())

  VideoElement? get _videoEl {
    final root = getElement; // racine du composant
    final video = root.querySelector('video') as VideoElement?;

    return video;
  }

  // Démarre le tracking périodique et les hooks pause/play/quartiles.
  // - tick : intervalle pour onTick (par défaut 1s)
  // - onTick : reçoit l'état courant (progression, buffer, etc.)
  // - onPause / onResume : déclenchés sur événements natifs
  // - onQuartile : appelé une seule fois par seuil atteint (25/50/75/100)
  void startAnalytics({
    Duration tick = const Duration(seconds: 1),
    void Function(VideoProgress p)? onTick,
    void Function()? onPause,
    void Function()? onResume,
    void Function(int q)? onQuartile,
  }) {
    // _videoEl?.onPause.listen((event) {
    //   print("pause 2");
    // });
    final v = _videoEl;
    if (v == null) return;

    var st = _states[this];
    if (st != null) {
      st.dispose();
    }

    st = _states[this] = _VAState()..video = v;

    // Écoute play/pause
    st.onPlay = v.onPlay.listen((_) {
      st?.resumes++;

      onResume?.call();
    });

    st.onPause = v.onPause.listen((_) {
      st?.pauses++;
      onPause?.call();
    });

    // timeupdate : calcule le temps réellement visionné (delta forward)

     v.onTimeUpdate.listen((ev) {
      final cur = v.currentTime;
      final prev = st!.lastTime;
      final d = cur - prev;
      if (d > 0) st.watched += d; // avance uniquement
      st.lastTime = cur.toDouble();
       final dur = v.duration.isNaN ? 0 : v.duration;
        // final cur = v.currentTime;
        double bufEnd = 0;
        final b = v.buffered;
        if (b.length > 0) {
          bufEnd = b.end(b.length - 1);
        }
        final progress = VideoProgress(
          current: cur.toDouble(),
          duration: dur.toDouble(),
          percent: dur == 0 ? 0 : (cur / dur).clamp(0, 1),
          buffered: dur == 0 ? 0 : (bufEnd / dur).clamp(0, 1),
          playbackRate: v.playbackRate.toDouble(),
          paused: v.paused,
        );
        // print("progress");
        onTick?.call(progress);
      _emitQuartilesIfAny(v, st, onQuartile);
      
    });

    // progress → rafraîchir buffer lors des ticks
    // v.addEventListener("onProgress", (event) {

    // },);

    // // intervalle régulier pour onTick
    // st.timer = Timer.periodic(tick, (timer) {
    //   () {
    //     final dur = v.duration.isNaN ? 0 : v.duration;
    //     final cur = v.currentTime;
    //     double bufEnd = 0;
    //     final b = v.buffered;
    //     if (b.length > 0) {
    //       bufEnd = b.end(b.length - 1);
    //     }
    //     final progress = VideoProgress(
    //       current: cur.toDouble(),
    //       duration: dur.toDouble(),
    //       percent: dur == 0 ? 0 : (cur / dur).clamp(0, 1),
    //       buffered: dur == 0 ? 0 : (bufEnd / dur).clamp(0, 1),
    //       playbackRate: v.playbackRate.toDouble(),
    //       paused: v.paused,
    //     );
    //     print("progress");
    //     onTick?.call(progress);
    //   };
    // });
    // // st.intervalId = window.setInterval(,);
  }

  // Stoppe le tracking et nettoie les listeners
  void stopAnalytics() {
    final st = _states[this];
    if (st == null) return;
    st.dispose();
    _states[this] = null; // libère
  }

  // Remet les compteurs (pauses, reprises, quartiles, watched)
  void resetAnalytics() {
    final st = _states[this];
    if (st != null) {
      st.pauses = 0;
      st.resumes = 0;
      st.quartiles.clear();
      st.watched = 0;
      st.lastTime = _videoEl?.currentTime.toDouble() ?? 0.0;
    }
  }

  // Résumé instantané des compteurs
  VideoAnalyticsSummary getAnalyticsSummary() {
    final st = _states[this];
    return VideoAnalyticsSummary(
      pauses: st?.pauses ?? 0,
      resumes: st?.resumes ?? 0,
      watched: st?.watched ?? 0.0,
      quartiles: Set.unmodifiable(st?.quartiles ?? const <int>{}),
    );
  }

  // Métadonnées immédiates (si loadedmetadata déjà passé). Utiliser
  // waitForMetadata() pour forcer un chargement si nécessaire.
  VideoMetadata getMetadata() {
    final v = _videoEl;
    final dur = (v?.duration ?? double.nan);
    final duration = dur.isNaN ? 0 : dur;
    final w = v?.videoWidth ?? 0;
    final h = v?.videoHeight ?? 0;
    final src = v?.currentSrc ?? '';
    String? label;
    String? mime;
    // essaie d'associer au catalogue sources[]
    if (src.isNotEmpty) {
      final match = sources.firstWhere((s) {
        // compare chemins sans origine pour être plus tolérant
        try {
          final a = Uri.parse(s.url);
          final b = Uri.parse(src);
          return a.path == b.path;
        } catch (_) {
          return s.url == src;
        }
      }, orElse: () => sources.first);
      label = match.label;
      mime = match.type;
    }
    return VideoMetadata(
      duration: duration.toDouble(),
      width: w,
      height: h,
      aspect: h == 0 ? 0 : w / h,
      src: src,
      sourceLabel: label,
      mimeType: mime,
    );
  }

  // Attend loadedmetadata si nécessaire puis renvoie les métadonnées
  Future<VideoMetadata> waitForMetadata() async {
    final v = _videoEl;
    if (v == null) {
      return const VideoMetadata(
        duration: 0,
        width: 0,
        height: 0,
        aspect: 0,
        src: '',
      );
    }
    if (v.readyState >= 1 && !v.duration.isNaN) {
      return getMetadata();
    } else {
      final c = Completer<void>();
      late StreamSubscription sub;
      sub = v.onLoadedMetadata.listen((_) {
        c.complete();
        sub.cancel();
      });
      // sécurité : timeout léger
      Future.delayed(Duration(milliseconds: 3000), () {
        if (!c.isCompleted) c.complete();
      });
      // window.setTimeout(() {

      // }, 3000);
      await c.future;
      return getMetadata();
    }
  }

  // Utilitaire : déclenche les callbacks de quartiles une seule fois
  void _emitQuartilesIfAny(
    VideoElement v,
    _VAState st,
    void Function(int q)? onQuartile,
  ) {
    final dur = v.duration.isNaN ? 0 : v.duration;
    if (dur <= 0) return;
    final pct = (v.currentTime / dur) * 100;
    for (final q in const [25, 50, 75, 100]) {
      if (pct >= q && !st.quartiles.contains(q)) {
        st.quartiles.add(q);
        onQuartile?.call(q);
      }
    }
  }
}
