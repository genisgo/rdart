part of 'widgets.dart';

// Lecteur vidéo moderne (HTML5) — Relement
// Ajouts :
// - Aperçu vignettes (sprite) au survol/drag de la barre de progression
// - Mode Théâtre (plein largeur, hauteur 70vh)
// - Support HLS natif (si navigateur le gère)
// - Raccourcis : space/k (play), f (fullscreen), p (PiP), c (CC), m (mute), t (théâtre)
// - Toujours : play/pause, seek, buffer, volume/mute, vitesse, qualité, CC, PiP, FS, nodownload

class ThumbnailSpriteConfig {
  final String url; // sprite image
  final int tileWidth; // largeur d'une vignette
  final int tileHeight; // hauteur d'une vignette
  final int columns; // nb colonnes dans le sprite
  final double stepSec; // intervalle en secondes entre 2 vignettes
  const ThumbnailSpriteConfig({
    required this.url,
    required this.tileWidth,
    required this.tileHeight,
    required this.columns,
    required this.stepSec,
  });
}

class VideoPlayerPlus extends Relement {
  final List<VideoSource> sources; // >=1
  final List<CaptionTrack> captions; // optionnel
  final ThumbnailSpriteConfig? thumbs; // optionnel
  final String? poster;
  final bool autoplay;
  final bool loop;
  final bool muted;
  final bool allowDownload;
  final bool allowPiP;
  final double initialVolume;
  final double initialSpeed; // 0..1, 0.25..2
  final String? crossOrigin; // 'anonymous' / 'use-credentials'

  VideoPlayerPlus({
    required this.sources,
    this.captions = const [],
    this.thumbs,
    this.poster,
    this.autoplay = false,
    this.loop = false,
    this.muted = false,
    this.allowDownload = false,
    this.allowPiP = true,
    this.initialVolume = 0.9,
    this.initialSpeed = 1.0,
    this.crossOrigin,
    super.id,
  });

  // DOM
  late final DivElement _root;
  late final VideoElement _video;
  late final DivElement _controls;
  late final DivElement _progressWrap;
  late final DivElement _progressPlayed;
  late final DivElement _progressBuffered;
  late final DivElement _progressHandle;
  late final ButtonElement _btnPlay, _btnMute, _btnPiP, _btnFs, _btnTheater;
  late final InputElement _volSlider;
  late final SpanElement _timeCurrent, _timeDuration;
  late final SelectElement _speedSelect, _qualitySelect;
  late final ButtonElement _btnSubs;
  AnchorElement? _btnDownload;
  late final DivElement _centerOverlay;

  // Thumbs popup
  DivElement? _thumbPopup;
  DivElement? _thumbFrame;
  SpanElement? _thumbTime;

  // état
  bool _draggingSeek = false;
  int _hideTimer = -1;
  int _lastMoveMs = 0;
  int _activeTrackIndex = -1;
  int _activeSourceIndex = 0;
  bool _theater = false;

  static String _fmt(num s) {
    final t = s.floor();
    final h = t ~/ 3600;
    final m = (t % 3600) ~/ 60;
    final sec = t % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = sec.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$m:$ss';
  }

  void _applyTheme() {
    _root.style
      ..position = 'relative'
      ..backgroundColor = '#000'
      ..borderRadius = '12px'
      ..overflow = 'hidden'
      ..userSelect = 'none'
      ..boxShadow = '0 24px 48px -24px rgba(0,0,0,.6)'
      ..width = '100%';
    _video.style
      ..width = '100%'
      ..height = '100%'
      ..display = 'block'
      ..backgroundColor = '#000';
    _controls.style
      ..position = 'absolute'
      ..left = '0'
      ..right = '0'
      ..bottom = '0'
      ..padding = '8px 12px'
      ..background =
          'linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,.45) 40%, rgba(0,0,0,.65) 100%)'
      ..color = '#fff'
      ..opacity = '1'
      ..transition = 'opacity 180ms ease';
    _centerOverlay.style
      ..position = 'absolute'
      // ..inset = '0'
      ..display = 'flex'
      ..alignItems = 'center'
      ..justifyContent = 'center'
      ..pointerEvents = 'none';
  }

  ButtonElement _btn(String label, {String? title}) {
    final b =
        ButtonElement()
          ..text = label
          ..title = title ?? ''
          ..style.background = 'rgba(255,255,255,.12)'
          ..style.border = '1px solid rgba(255,255,255,.18)'
          ..style.borderRadius = '10px'
          ..style.color = '#fff'
          ..style.cursor = 'pointer'
          ..style.padding = '8px 10px'
          ..style.display = 'inline-flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px';
    b.onMouseOver.listen((_) => b.style.filter = 'brightness(1.08)');
    b.onMouseOut.listen((_) => b.style.filter = 'none');
    return b;
  }

  Element _mkTime() {
    _timeCurrent =
        SpanElement()
          ..text = '0:00'
          ..style.opacity = '.9';
    _timeDuration =
        SpanElement()
          ..text = '0:00'
          ..style.opacity = '.9';
    final sep =
        SpanElement()
          ..text = ' / '
          ..style.opacity = '.6';
    final wrap =
        DivElement()
          ..style.display = 'inline-flex'
          ..style.alignItems = 'center'
          ..style.gap = '2px'
          ..children.addAll([_timeCurrent, sep, _timeDuration]);
    return wrap;
  }

  Element _mkVolume() {
    _btnMute = _btn('🔈', title: 'Muet');
    _volSlider =
        InputElement(type: 'range')
          ..min = '0'
          ..max = '1'
          ..step = '0.01'
          ..value = initialVolume.toString()
          ..style.width = '110px';
    final wrap =
        DivElement()
          ..style.display = 'inline-flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px'
          ..children.addAll([_btnMute, _volSlider]);
    return wrap;
  }

  Element _mkProgress() {
    _progressWrap =
        DivElement()
          ..style.height = '8px'
          ..style.position = 'relative'
          ..style.background = 'rgba(255,255,255,.18)'
          ..style.borderRadius = '999px'
          ..style.cursor = 'pointer';
    _progressBuffered =
        DivElement()
          ..style.position = 'absolute'
          ..style.left = '0'
          ..style.top = '0'
          ..style.bottom = '0'
          ..style.width = '0%'
          ..style.background = 'rgba(255,255,255,.28)'
          ..style.borderRadius = '999px';
    _progressPlayed =
        DivElement()
          ..style.position = 'absolute'
          ..style.left = '0'
          ..style.top = '0'
          ..style.bottom = '0'
          ..style.width = '0%'
          ..style.background = '#4f46e5'
          ..style.borderRadius = '999px';
    _progressHandle =
        DivElement()
          ..style.position = 'absolute'
          ..style.top = '-4px'
          ..style.width = '16px'
          ..style.height = '16px'
          ..style.borderRadius = '999px'
          ..style.background = '#fff'
          ..style.boxShadow = '0 2px 6px rgba(0,0,0,.35)'
          ..style.left = '0%';

    // Thumbnails popup
    if (thumbs != null) {
      _thumbPopup =
          DivElement()
            ..style.position = 'absolute'
            ..style.bottom = '14px'
            ..style.left = '0'
            ..style.transform = 'translateX(-50%)'
            ..style.padding = '6px'
            ..style.borderRadius = '10px'
            ..style.background = 'rgba(0,0,0,.7)'
            ..style.color = '#fff'
            ..style.display = 'none'
            ..style.pointerEvents = 'none'
            ..style.textAlign = 'center'
            ..style.fontSize = '12px';
      _thumbFrame =
          DivElement()
            ..style.width = '${thumbs!.tileWidth}px'
            ..style.height = '${thumbs!.tileHeight}px'
            ..style.backgroundImage = 'url("${thumbs!.url}")'
            ..style.backgroundRepeat = 'no-repeat'
            ..style.marginBottom = '4px';
      _thumbTime = SpanElement()..text = '0:00';
      _thumbPopup!..children.addAll([_thumbFrame!, _thumbTime!]);
      _progressWrap.children.add(_thumbPopup!);
    }

    _progressWrap.children.addAll([
      _progressBuffered,
      _progressPlayed,
      _progressHandle,
    ]);
    return _progressWrap;
  }

  Element _mkSelectors() {
    _speedSelect =
        SelectElement()
          ..style.background = 'rgba(255,255,255,.12)'
          ..style.border = '1px solid rgba(255,255,255,.18)'
          ..style.borderRadius = '10px'
          ..style.color = '#fff'
          ..style.padding = '8px 10px'
          ..children.addAll([
            for (final v in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
              OptionElement(
                data: v.toString() + '×',
                value: v.toString(),
                selected: v == initialSpeed,
              ),
          ]);

    _qualitySelect =
        SelectElement()
          ..style.background = 'rgba(255,255,255,.12)'
          ..style.border = '1px solid rgba(255,255,255,.18)'
          ..style.borderRadius = '10px'
          ..style.color = '#fff'
          ..style.padding = '8px 10px'
          ..children.addAll([
            for (int i = 0; i < sources.length; i++)
              OptionElement(
                data: sources[i].label,
                value: i.toString(),
                selected: i == 0,
              ),
          ]);

    _btnSubs = _btn('CC', title: 'Sous-titres');

    final wrap =
        DivElement()
          ..style.display = 'inline-flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px'
          ..children.addAll([
            _speedSelect,
            if (sources.length > 1) _qualitySelect,
            if (captions.isNotEmpty) _btnSubs,
          ]);
    return wrap;
  }

  Element _mkRightControls() {
    _btnPiP = _btn('PIP', title: 'Picture-in-Picture');
    _btnFs = _btn('⛶', title: 'Plein écran');
    _btnTheater = _btn('⌗', title: 'Mode Théâtre');
    _btnDownload =
        allowDownload
            ? (AnchorElement()
              ..text = '↧'
              ..title = 'Télécharger'
              ..style.background = 'rgba(255,255,255,.12)'
              ..style.border = '1px solid rgba(255,255,255,.18)'
              ..style.borderRadius = '10px'
              ..style.color = '#fff'
              ..style.padding = '8px 10px'
              ..style.textDecoration = 'none')
            : null;

    final wrap =
        DivElement()
          ..style.display = 'inline-flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px'
          ..children.addAll([
            _btnTheater,
            if (allowPiP) _btnPiP,
            _btnFs,
            if (_btnDownload != null) _btnDownload!,
          ]);
    return wrap;
  }

  void _wireEvents() {
    void togglePlay() {
      _video.paused ? _video.play() : _video.pause();
    }

    _btnPlay.onClick.listen((_) => togglePlay());
    _video.onClick.listen((_) => togglePlay());
    _video.onPlay.listen((_) {
      _btnPlay.text = '⏸';
      _centerOverlay.style.opacity = '0';
    });
    _video.onPause.listen((_) {
      _btnPlay.text = '▶';
      _centerOverlay.style.opacity = '1';
    });

    // Volume
    _volSlider.onInput.listen((_) {
      _video.volume = double.tryParse(_volSlider.value ?? '1') ?? 1;
      if (_video.volume > 0) _video.muted = false;
    });
    _btnMute.onClick.listen((_) {
      _video.muted = !_video.muted;
    });
    _video.onVolumeChange.listen((_) {
      final vol = _video.muted ? 0 : _video.volume;
      _volSlider.value = vol.toString();
      _btnMute.text = (vol == 0) ? '🔇' : '🔈';
    });

    // Métadonnées & download
    _video.onLoadedMetadata.listen((_) {
      _timeDuration.text = _fmt(_video.duration.isNaN ? 0 : _video.duration);
      if (_btnDownload != null) {
        _btnDownload!
          ..href = _currentSrc().url
          ..download = '';
      }
    });

    // Progrès
    _video.onTimeUpdate.listen((_) {
      if (!_draggingSeek) _updateProgressUI();
    });
    _video.addEventListener("progress", (event) {
      _updateBufferedUI();
    });

    // Vitesse
    _speedSelect.onChange.listen((_) {
      _video.playbackRate = double.tryParse(_speedSelect.value ?? '1') ?? 1;
    });

    // Qualité
    _qualitySelect.onChange.listen((_) {
      final idx = int.tryParse(_qualitySelect.value ?? '0') ?? 0;
      _switchSource(idx);
    });

    // CC
    _btnSubs.onClick.listen((_) => _cycleTrack());

    _btnPiP.onClick.listen((_) async {
      try {
        if (pipElement != null) {
          await exitPiP();
        } else {
          if (!pipEnabled) {
            window.alert('Picture-in-Picture non supporté.');
            return;
          }
          await _video.play(); // souvent requis avant PiP
          await enterPiP(_video);
        }
      } catch (_) {
        // ignore
      }
    });

    // --- Fullscreen ---
    _btnFs.onClick.listen((_) async {
      if (document.fullscreenElement == _root) {
        document.exitFullscreen();
      } else {
        await _root.requestFullscreen();
      }
    });
    // Théâtre
    void applyTheater() {
      _theater = !_theater;
      if (_theater) {
        _root.style.height = '70vh';
      } else {
        _root.style.height = '';
      }
    }

    _btnTheater.onClick.listen((_) => applyTheater());

    // Seek + thumbnails
    void seekFromX(num clientX) {
      final rect = _progressWrap.getBoundingClientRect();
      final x = (clientX - rect.left).clamp(0, rect.width);
      final ratio = rect.width == 0 ? 0 : x / rect.width;
      final dur = _video.duration.isNaN ? 0 : _video.duration;
      _video.currentTime = ratio * dur;
      _updateProgressUI();
    }

    _progressWrap.onMouseDown.listen((e) {
      _draggingSeek = true;
      seekFromX(e.client.x);
    });
    document.onMouseMove.listen((e) {
      if (_draggingSeek) {
        seekFromX(e.client.x);
      }
      if (thumbs != null) {
        _updateThumbs(e.client.x);
      }
    });
    document.onMouseUp.listen((_) => _draggingSeek = false);
    _progressWrap.onMouseEnter.listen((e) {
      if (thumbs != null) {
        _thumbPopup!.style.display = 'block';
        _updateThumbs(e.client.x);
      }
    });
    _progressWrap.onMouseLeave.listen((_) {
      if (thumbs != null) _thumbPopup!.style.display = 'none';
    });

    // Auto-hide
    void showControls([bool temp = false]) {
      _controls.style.opacity = '1';
      _centerOverlay.style.opacity = _video.paused ? '1' : '0';
      if (temp) _lastMoveMs = DateTime.now().millisecondsSinceEpoch;
    }

    void maybeHide() {
      if (_video.paused) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastMoveMs > 1800) _controls.style.opacity = '.0';
    }

    _root.onMouseMove.listen((_) {
      showControls(true);
    });
    Future.delayed(Duration(milliseconds: 600), () {
      maybeHide();
    });
    // Clavier
    _root.tabIndex = 0;
    _root.onKeyDown.listen((e) {
      switch (e.key) {
        case ' ':
        case 'k':
          togglePlay();
          e.preventDefault();
          break;
        case 'ArrowRight':
          _video.currentTime += 5;
          break;
        case 'ArrowLeft':
          _video.currentTime -= 5;
          break;
        case 'ArrowUp':
          _video.volume = math.min(1, _video.volume + .05);
          break;
        case 'ArrowDown':
          _video.volume = math.max(0, _video.volume - .05);
          break;
        case 'm':
          _video.muted = !_video.muted;
          break;
        case 'f':
          _btnFs.click();
          break;
        case 'p':
          if (allowPiP) _btnPiP.click();
          break;
        case 'c':
          if (captions.isNotEmpty) _btnSubs.click();
          break;
        case 't':
          _btnTheater.click();
          break;
        default:
          break;
      }
      showControls(true);
    });

    // Download restrictions
    if (!allowDownload) {
      _video.setAttribute('controlsList', 'nodownload noplaybackrate');
      _root.onContextMenu.listen((e) {
        e.preventDefault();
      });
    }
  }

  void _updateProgressUI() {
    final dur = _video.duration.isNaN ? 0 : _video.duration;
    final cur = _video.currentTime;
    final ratio = dur == 0 ? 0 : (cur / dur);
    _progressPlayed.style.width = '${(ratio * 100).clamp(0, 100)}%';
    _progressHandle.style.left = 'calc(${(ratio * 100).clamp(0, 100)}% - 8px)';
    _timeCurrent.text = _fmt(cur);
  }

  void _updateBufferedUI() {
    if (_video.buffered.length > 0) {
      final end = _video.buffered.end(_video.buffered.length - 1);
      final dur = _video.duration.isNaN ? 0 : _video.duration;
      final ratio = dur == 0 ? 0 : (end / dur);
      _progressBuffered.style.width = '${(ratio * 100).clamp(0, 100)}%';
    }
  }

  void _updateThumbs(num clientX) {
    if (thumbs == null) return;
    final rect = _progressWrap.getBoundingClientRect();
    final x = (clientX - rect.left).clamp(0, rect.width);
    final ratio = rect.width == 0 ? 0 : x / rect.width;
    final dur = _video.duration.isNaN ? 0 : _video.duration;
    final time = ratio * dur;
    final idx = (time / thumbs!.stepSec).floor();
    final col = idx % thumbs!.columns;
    final row = (idx / thumbs!.columns).floor();
    final offsetX = -(col * thumbs!.tileWidth);
    final offsetY = -(row * thumbs!.tileHeight);

    _thumbFrame!.style
      ..backgroundPosition = '${offsetX}px ${offsetY}px'
      ..backgroundSize = '${thumbs!.columns * thumbs!.tileWidth}px auto';
    _thumbTime!.text = _fmt(time);

    // position popup
    final left = x; // centre sur le curseur
    _thumbPopup!.style.left = '${left}px';
    _thumbPopup!.style.display = 'block';
  }

  VideoSource _currentSrc() => sources[_activeSourceIndex];

  void _switchSource(int newIndex) async {
    if (newIndex == _activeSourceIndex) return;
    final wasPlaying = !_video.paused;
    final t = _video.currentTime;
    _activeSourceIndex = newIndex;
    _video.pause();
    _video.src = _currentSrc().url;
    if (crossOrigin != null) _video.crossOrigin = crossOrigin;
    _video.load();
    _video.currentTime = t;
    if (wasPlaying) {
      _video.play();
    }
  }

  void _cycleTrack() {
    final tracks = _video.textTracks;
    if (tracks == null || tracks.length == 0) return;
    for (var i = 0; i < tracks.length; i++) {
      tracks[i].mode = 'disabled';
    }
    _activeTrackIndex++;
    if (_activeTrackIndex >= tracks.length) _activeTrackIndex = -1;
    if (_activeTrackIndex >= 0) {
      tracks[_activeTrackIndex].mode = 'showing';
    }
  }

  @override
  Element create() {
    _root = DivElement();
    _video =
        VideoElement()
          ..controls = false
          ..preload = 'metadata'
          // ..playsInline = true
          ..muted = muted
          ..loop = loop
          ..poster = poster ?? ''
          ..style.outline = 'none';
    _video.setAttribute('playsinline', '');
    if (crossOrigin != null) _video.crossOrigin = crossOrigin;

    // première source (HLS si natif)
    final first = sources.first;
    final canHls =
        (first.type == 'application/vnd.apple.mpegurl' ||
                first.url.endsWith('.m3u8'))
            ? _video.canPlayType('application/vnd.apple.mpegurl').isNotEmpty
            : true;
    _video.src =
        first
            .url; // on tente, si non supporté le navigateur échouera (pas d'hls.js ici)

    // tracks
    for (final c in captions) {
      final tr =
          TrackElement()
            ..kind = 'subtitles'
            ..src = c.src
            ..srclang = c.srclang
            ..label = c.label;
      if (c.isDefault) {
        tr.setAttribute('default', '');
      }
      // ..defaultSelected = c.isDefault;

      _video.children.add(tr);
    }

    // overlay play
    _centerOverlay = DivElement();
    final bigPlay =
        DivElement()
          ..text = '▶'
          ..style.fontSize = '56px'
          ..style.width = '96px'
          ..style.height = '96px'
          ..style.borderRadius = '999px'
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.justifyContent = 'center'
          ..style.background = 'rgba(0,0,0,.45)'
          ..style.color = '#fff';
    _centerOverlay.children.add(bigPlay);

    // contrôles
    _controls = DivElement();
    _btnPlay = _btn('▶', title: 'Lecture/Pause');
    final left =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px'
          ..children.addAll([_btnPlay, _mkTime(), _mkVolume()]);
    final middle =
        DivElement()
          ..style.flex = '1'
          ..style.margin = '0 12px'
          ..children.add(_mkProgress());
    final right =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px'
          ..children.addAll([_mkSelectors(), _mkRightControls()]);
    final bar =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..children.addAll([left, middle, right]);
    _controls.children.add(bar);

    _root.children.addAll([_video, _centerOverlay, _controls]);

    _applyTheme();
    _wireEvents();

    _video.volume = initialVolume;
    _video.playbackRate = initialSpeed;
    if (autoplay) {
      _video.play().catchError((_) {
        /* bloqué */
      });
    }

    return _root;
  }

  @override
  Element get getElement => _root;
}
