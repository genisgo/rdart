part of 'utils.dart';
// --- Helpers d’accès aux props/méthodes JS ---
bool get pipEnabled =>
  js.hasProperty(document, 'pictureInPictureEnabled') &&
  (js.getProperty(document, 'pictureInPictureEnabled') == true);

Element? get pipElement =>
  js.getProperty(document, 'pictureInPictureElement') as Element?;

Future<void> enterPiP(VideoElement video) async {
  // video.requestPictureInPicture()
  await js.promiseToFuture(js.callMethod(video, 'requestPictureInPicture', []));
}

Future<void> exitPiP() async {
  // document.exitPictureInPicture()
  await js.promiseToFuture(js.callMethod(document, 'exitPictureInPicture', []));
}

class VideoSource {
  final String url; // MP4 / HLS (.m3u8 si natif)
  final String label; // "1080p"/"720p"…
   /// ex: 'video/mp4' ou 'application/vnd.apple.mpegurl'
  final String? type;
  final int? height; // pour trier/afficher
  const VideoSource({
    required this.url,
    required this.label,
    this.type,
    this.height,
  });
}

class CaptionTrack {
  final String src;
  final String srclang;
  final String label;
  final bool isDefault;
  const CaptionTrack({
    required this.src,
    required this.srclang,
    required this.label,
    this.isDefault = false,
  });
}
