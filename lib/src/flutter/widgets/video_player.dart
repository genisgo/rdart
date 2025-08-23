part of 'widgets.dart';

// Lecteur vidéo moderne (HTML5) en Rdart — base Relement uniquement
// Caractéristiques :
// - Play/Pause, Seek, Durée/Temps, Volume & Mute, Vitesse (0.25×..2×)
// - Qualité (sources multiples), Sous-titres (VTT), PIP, Plein écran
// - Auto-hide des contrôles, Raccourcis clavier, Poster, Loop, Autoplay
// - Option allowDownload pour afficher/masquer le téléchargement et limiter l'accès
//   au téléchargement (controlsList='nodownload', blocage du clic droit)
//
// NB : empêcher totalement le téléchargement est impossible côté client.
//      Ici on supprime les options évidentes (bouton, context menu, controlsList),
//      et on n'expose pas d'URL directe si vous passez un proxy.


class VideoPlayer extends Relement {
  final List<VideoSource> sources; // au moins 1
  final List<CaptionTrack> captions; // optionnel
  final String? poster; // image d'ouverture
  final bool autoplay;
  final bool loop;
  final bool muted;
  final bool allowDownload; // contrôle du bouton et controlsList
  final bool allowPiP;
  final double initialVolume; // 0..1
  final double initialSpeed; // 0.25..2.0
  final String? crossOrigin; // 'anonymous' / 'use-credentials'

  VideoPlayer({
    required this.sources,
    this.captions = const [],
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
  late final ButtonElement _btnPlay;
  late final ButtonElement _btnMute;
  late final InputElement _volSlider;
  late final SpanElement _timeCurrent;
  late final SpanElement _timeDuration;
  late final SelectElement _speedSelect;
  late final SelectElement _qualitySelect;
  late final ButtonElement _btnSubs;
  late final ButtonElement _btnPiP;
  late final ButtonElement _btnFs;
  AnchorElement? _btnDownload;
  late final DivElement _centerOverlay;

  // état
  bool _draggingSeek = false;
  // int _hideTimer = -1;
  int _lastMoveMs = 0;
  int _activeTrackIndex = -1; // -1 = off
  int _activeSourceIndex = 0;

  // utilitaires
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
      ..boxShadow = '0 24px 48px -24px rgba(0,0,0,.6)';
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

  Element _icon(String text) {
    final b =
        SpanElement()
          ..text = text
          ..style.fontSize = '18px';
    return b;
  }

  ButtonElement _mkBtn(String label) {
    final b =
        ButtonElement()
          ..text = label
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
    _btnMute = _mkBtn('🔈')..title = 'Muet';
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

    _btnSubs = _mkBtn('CC');

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
    _btnPiP = _mkBtn('PIP');
    _btnFs = _mkBtn('⛶');
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
          ..style.gap = '8px';
    if (allowPiP) wrap.children.add(_btnPiP);
    wrap.children.add(_btnFs);
    if (_btnDownload != null) wrap.children.add(_btnDownload!);
    return wrap;
  }

  void _wireEvents() {
    // Play / Pause
    void togglePlay() {
      _video.paused ? _video.play() : _video.pause();
    }

    _btnPlay.onClick.listen((_) => togglePlay());
    _video.onClick.listen((_) => togglePlay());

    _video.onPlay.listen((_) {
      print("pause");
      _btnPlay.text = '⏸';
      _centerOverlay.style.opacity = '0';
    });
    _video.onPause.listen((_) {
      _btnPlay.text = '▶';
      _centerOverlay.style.opacity = '1';
    });

    // Volume & mute
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

    // Durée / temps
    _video.onLoadedMetadata.listen((_) {
      _timeDuration.text = _fmt(_video.duration.isNaN ? 0 : _video.duration);
      if (_btnDownload != null) {
        _btnDownload!
          ..href = _currentSrc().url
          ..download = '';
      }
    });

    _video.onTimeUpdate.listen((_) {
      if (!_draggingSeek) _updateProgressUI();
    });
    _video.addEventListener("progress", (event) {
      _updateBufferedUI();
    });

    // Vitesse
    _speedSelect.onChange.listen((_) {
      final v = double.tryParse(_speedSelect.value ?? '1') ?? 1;
      _video.playbackRate = v;
    });

    // Qualité
    _qualitySelect.onChange.listen((_) {
      final idx = int.tryParse(_qualitySelect.value ?? '0') ?? 0;
      _switchSource(idx);
    });

    // Sous-titres (toggle cyclique: off -> track1 -> track2 ...)
    _btnSubs.onClick.listen((_) {
      _cycleTrack();
    });

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

    // Seek (drag)
    void seekFromEvent(MouseEvent e) {
      final rect = _progressWrap.getBoundingClientRect();
      final x = (e.client.x - rect.left).clamp(0, rect.width);
      final ratio = rect.width == 0 ? 0 : x / rect.width;
      final dur = _video.duration.isNaN ? 0 : _video.duration;
      _video.currentTime = ratio * dur;
      _updateProgressUI();
    }

    _progressWrap.onMouseDown.listen((e) {
      _draggingSeek = true;
      seekFromEvent(e);
    });
    document.onMouseMove.listen((e) {
      if (_draggingSeek) seekFromEvent(e);
    });
    document.onMouseUp.listen((_) {
      if (_draggingSeek) {
        _draggingSeek = false;
      }
    });

    // Auto-hide contrôles quand la souris ne bouge pas en lecture
    void showControls([bool temp = false]) {
      _controls.style.opacity = '1';
      _centerOverlay.style.opacity = _video.paused ? '1' : '0';
      if (temp) _lastMoveMs = DateTime.now().millisecondsSinceEpoch;
    }

    void maybeHide() {
      if (_video.paused) return; // toujours visible en pause
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastMoveMs > 1800) {
        _controls.style.opacity = '.0';
      }
    }

    _root.onMouseMove.listen((_) {
      showControls(true);
    });
    Future.delayed(Duration(milliseconds: 600), () {
      maybeHide();
    });
    //  window.setInterval(, 600);

    // Clavier
    _root.tabIndex = 0; // focusable
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
        default:
          break;
      }
      showControls(true);
    });

    // Contexte / download
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

  VideoSource _currentSrc() => sources[_activeSourceIndex];

  void _switchSource(int newIndex) async {
    if (newIndex == _activeSourceIndex) return;
    final wasPlaying = !_video.paused;
    final t = _video.currentTime;
    _activeSourceIndex = newIndex;

    // remplace src (simple et fiable)
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
    // cacher tous
    for (var i = 0; i < tracks.length; i++) {
      tracks[i].mode = 'disabled';
    }
    // avancer
    _activeTrackIndex++;
    if (_activeTrackIndex >= tracks.length) _activeTrackIndex = -1; // off
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

    // première source
    _video.src = sources.first.url;

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
      _video.children.add(tr);
    }

    // center overlay (grand play)
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

    // barre de contrôle
    _controls = DivElement();

    _btnPlay = _mkBtn('▶');
    final left =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px'
          ..children.addAll([_btnPlay, _mkTime(), _mkVolume()]);

    final middle =
        DivElement()
          ..style.flex = '1'
          ..style.margin = '0 12px';
    middle.children.add(_mkProgress());

    final right =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.gap = '8px';
    right.children.addAll([_mkSelectors(), _mkRightControls()]);

    final bar =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..children.addAll([left, middle, right]);

    _controls.children.add(bar);

    _root.children.addAll([_video, _centerOverlay, _controls]);

    _applyTheme();
    _wireEvents();

    // init volume/vitesse/autoplay
    _video.volume = initialVolume;
    _video.playbackRate = initialSpeed;
    if (autoplay) {
      _video.play().catchError((_) {
        /* autoplay bloqué par navigateur */
      });
    }

    return _root;
  }

  @override
  Element get getElement => _root;
}
