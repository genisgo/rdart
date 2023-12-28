String decodeHtmlEntities(String text) {
  return text.replaceAllMapped(
    RegExp(r'&(#?[\da-zA-Z]+);'),
    (match) {
      final entity = match.group(1);
      if (entity != null) {
        if (entity.startsWith('#')) {
          final isHex = entity.startsWith('#x') || entity.startsWith('#X');
          final code = isHex
              ? int.parse(entity.substring(2), radix: 16)
              : int.parse(entity.substring(1));
          return String.fromCharCode(code);
        } else {
          // Gérer les entités HTML courantes ici
          switch (entity) {
            case 'lt':
              return '<';
            case 'gt':
              return '>';
            case 'amp':
              return '&';
            // Ajoutez d'autres entités HTML si nécessaire
          }
        }
      }
      return match.group(0)!;
    },
  );
}
