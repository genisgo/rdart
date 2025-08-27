part of 'widgets.dart';

// -------------------- Types & thème ------------------------------------------
enum DataType { text, number, date, boolean }

enum FilterOp { contains, equals, notEquals, gt, lt, between, dateBetween }

class TableTheme {
  final Color headerBg;
  final Color headerFg;
  final Color rowBg;
  final Color altRowBg;
  final Color borderColor;
  final Color hoverBg;
  final Color selectedBg;
  final Color textColor;

  ///pour tri & boutons
  final Color accent;
  final double radius;
  final double lineHeight; // px
  final String fontFamily;
  final Color groupBg;
  final Color subtotalBg;
  const TableTheme({
    this.textColor = Colors.black,
    this.headerBg = const Color('#0b1220'),
    this.headerFg = const Color('#dbe7ff'),
    this.rowBg = const Color('#0f172a'),
    this.altRowBg = const Color('#111b2f'),
    this.borderColor = const Color('rgba(255,255,255,.08)'),
    this.hoverBg = const Color('rgba(79,70,229,.10)'),
    this.selectedBg = const Color('rgba(79,70,229,.18)'),
    this.accent = const Color('#4f46e5'),
    this.radius = 14,
    this.lineHeight = 40,
    this.fontFamily =
        'ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto',
    this.groupBg =const Color('rgba(255,255,255,.04)'),
    this.subtotalBg = const Color( 'rgba(79,70,229,.06)'),
  });
}

class TableColumn {
  final String key; // champ
  final String title; // libellé
  final DataType type;
  final bool sortable;
  final bool filterable;
  final bool sum; // total colonne
  final String align; // 'left'|'center'|'right'
  final bool visibleByDefault;
  final String Function(dynamic)? format; // formattage texte
  final Relement Function(Map<String, dynamic>)? cellBuilder; // custom cell
  const TableColumn({
    required this.key,
    required this.title,
    this.type = DataType.text,
    this.sortable = true,
    this.filterable = true,
    this.sum = false,
    this.align = 'left',
    this.visibleByDefault = true,
    this.format,
    this.cellBuilder,
  });
}

class _ColumnFilter {
  FilterOp op;
  String text = '';
  num? min;
  num? max;
  DateTime? from;
  DateTime? to;
  _ColumnFilter(this.op);
}

class _SortSpec {
  final String key;
  bool asc;
  _SortSpec(this.key, this.asc);
}

class TableView extends Relement {
  final List<Map<String, dynamic>> data;
  final List<TableColumn> columns;
  final bool showSearch;
  final bool showExport;
  final List<int> pageSizeOptions;
  final int initialPageSize;
  final TableTheme theme;
  final String? groupByKey; // clé de groupement (optionnel)
  final bool groupsCollapsible; // groupes repliables

  TableView({
    required this.data,
    required this.columns,
    this.showSearch = true,
    this.showExport = true,
    this.pageSizeOptions = const [5, 10, 20, 50],
    this.initialPageSize = 10,
    this.theme = const TableTheme(),
    this.groupByKey,
    this.groupsCollapsible = true,
    super.id,
  });

  // DOM
  late final DivElement _root;
  late final InputElement _search;
  late final TableElement _table;
  late TableSectionElement _thead;
  late TableSectionElement _tbody;
  late TableSectionElement _tfooter;
  late final DivElement _pager;

  final _filters = <String, _ColumnFilter>{};
  final _sorts = <_SortSpec>[]; // multi-tri
  final _hidden = <String>{}; // colonnes cachées
  int _page = 0;
  int _pageSize = 10;
  Timer? _debounce;
  final _collapsed = <String, bool>{}; // état des groupes

  List<Map<String, dynamic>> get _source => data;

  // Helpers
  num _num(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    final s = '$v'.replaceAll(',', '.');
    return num.tryParse(s) ?? 0;
  }

  DateTime? _date(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    try {
      return DateTime.parse('$v');
    } catch (_) {
      return null;
    }
  }

  String _fmtCell(TableColumn c, dynamic v) {
    if (c.format != null) return c.format!(v);
    if (v == null) return '';
    if (c.type == DataType.date) {
      final d = _date(v);
      return d == null ? '' : d.toIso8601String().split('T').first;
    }
    return '$v';
  }

  String _escapeHtml(String s) {
    return s
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  @override
  Element create() {
    _pageSize = initialPageSize;
    for (final c in columns) {
      if (!c.visibleByDefault) _hidden.add(c.key);
    }

    _root = DivElement();
    _root.style.fontFamily = theme.fontFamily;
    // ..color = theme.headerFg.color;

    // Toolbar
    final toolbar =
        DivElement()
          ..style.display = 'flex'
          ..style.gap = '10px'
          ..style.alignItems = 'center'
          ..style.marginBottom = '10px';

    if (showSearch) {
      final wrap = DivElement()..style.flex = '1';
      _search =
          InputElement()
            ..placeholder = 'Rechercher…'
            ..style.width = '100%'
            ..style.padding = '10px 12px'
            ..style.border = '1px solid ${theme.borderColor}'
            ..style.borderRadius = '${theme.radius}px'
            ..style.backgroundColor = theme.rowBg.color
            ..style.color = theme.headerFg.color;
      _search.onInput.listen((_) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 250), () {
          _page = 0; // reset pagination
          _refreshBody();
        });
      });
      wrap.append(_search);
      toolbar.append(wrap);
    }

    // Colonnes visibles
    final btnCols = _mkBtn('Colonnes');
    btnCols.onClick.listen((e) {
      _openColumnsPopup(btnCols);
    });

    // Export
    final btnCsv = _mkBtn('CSV');
    btnCsv.onClick.listen((_) => _exportCsv());
    final btnXls = _mkBtn('Excel');
    btnXls.onClick.listen((_) => _exportExcelHtml());
    final btnPdf = _mkBtn('PDF');
    btnPdf.onClick.listen((_) => _exportPdf());

    // Page size selector
    final selSize =
        SelectElement()
          ..style.background = 'transparent'
          ..style.border = '1px solid ${theme.borderColor}'
          ..style.color = theme.textColor.color
          ..style.borderRadius = '10px'
          ..style.padding = '8px 10px';
    for (final v in pageSizeOptions) {
      selSize.children.add(
        OptionElement(data: '$v/pg', value: '$v', selected: v == _pageSize),
      );
    }
    selSize.onChange.listen((_) {
      _pageSize = int.tryParse(selSize.value ?? '10') ?? 10;
      _page = 0;
      _refreshBody();
    });

    toolbar.children.addAll([
      btnCols,
      if (showExport) btnCsv,
      if (showExport) btnXls,
      if (showExport) btnPdf,
      selSize,
    ]);
    _root.append(toolbar);

    // Table
    _table = TableElement();
    _table.style
      ..width = '100%'
      ..borderCollapse = 'separate'
      ..borderSpacing = '0'
      ..backgroundColor = theme.rowBg.color
      ..border = '1px solid ${theme.borderColor}'
      ..borderRadius = '${theme.radius}px'
      ..overflow = 'hidden';

    _thead = _table.createTHead();
    _tbody =
        _table.tBodies.isNotEmpty ? _table.tBodies.first : _table.createTBody();
    _tfooter = _table.tFoot ?? _table.createTFoot();

    _buildHeader();

    _root.append(_table);

    // Pager
    _pager =
        DivElement()
          ..style.display = 'flex'
          ..style.justifyContent = 'space-between'
          ..style.alignItems = 'center'
          ..style.marginTop = '10px';
    _root.append(_pager);

    _refreshBody();
    return _root;
  }

  Element _mkBtn(String label) {
    final b =
        ButtonElement()
          ..text = label
          ..style.backgroundColor = 'transparent'
          ..style.border = '1px solid ${theme.borderColor}'
          ..style.color = theme.textColor.color
          ..style.borderRadius = '10px'
          ..style.padding = '8px 10px'
          ..style.cursor = 'pointer';
    b.onMouseOver.listen((_) => b.style.filter = 'brightness(1.1)');
    b.onMouseOut.listen((_) => b.style.filter = 'none');
    return b;
  }

  void _openColumnsPopup(Element anchor) {
    final popup =
        DivElement()
          ..style.position = 'absolute'
          ..style.zIndex = '10000'
          ..style.backgroundColor = theme.rowBg.color
          ..style.color = theme.headerFg.color
          ..style.border = '1px solid ${theme.borderColor}'
          ..style.borderRadius = '12px'
          ..style.padding = '10px'
          ..style.boxShadow = '0 20px 40px -20px rgba(0,0,0,.5)';
    final rect = anchor.getBoundingClientRect();
    popup.style.left = '${rect.left}px';
    popup.style.top = '${rect.bottom + 6}px';

    for (final c in columns) {
      final row =
          LabelElement()
            ..style.display = 'flex'
            ..style.alignItems = 'center'
            ..style.gap = '8px'
            ..style.margin = '6px 0';
      final cb = CheckboxInputElement()..checked = !_hidden.contains(c.key);
      cb.onChange.listen((_) {
        if (cb.checked == true)
          _hidden.remove(c.key);
        else
          _hidden.add(c.key);
        _page = 0;
        _buildHeader();
        _refreshBody();
      });
      final span = SpanElement()..text = c.title;
      row.children.addAll([cb, span]);
      popup.append(row);
    }

    document.body!.append(popup);
    late EventListener? onDoc;
    onDoc = (ev) {
      if (!popup.contains(ev.target as Node?)) {
        popup.remove();
        document.removeEventListener('click', onDoc);
      }
    };
    document.addEventListener('click', onDoc);
  }

  void _buildHeader() {
    _thead.children.clear();
    final tr = TableRowElement();
    for (final c in columns) {
      if (_hidden.contains(c.key)) continue;
      final th = Element.tag('th');
      th.text = c.title;
      th.style
        ..position = 'relative'
        ..backgroundColor = theme.headerBg.color
        ..color = theme.headerFg.color
        ..textAlign = c.align
        ..padding = '0 12px'
        ..height = '${theme.lineHeight}px'
        ..borderBottom = '1px solid ${theme.borderColor}'
        ..userSelect = 'none';

      // tri & multi-tri (Shift)
      if (c.sortable) {
        th.style.cursor = 'pointer';
        th.onClick.listen((e) {
          final shift = (e is MouseEvent) ? e.shiftKey : false;
          _onSort(c.key, multi: shift);
        });
        final currentIndex = _sorts.indexWhere((s) => s.key == c.key);
        final icon =
            SpanElement()
              ..text =
                  (currentIndex >= 0)
                      ? (_sorts[currentIndex].asc ? ' ▲' : ' ▼')
                      : ''
              ..style.color = theme.accent.color
              ..style.marginLeft = '6px';
        th.append(icon);
      }

      // filtre bouton
      if (c.filterable) {
        final f =
            ButtonElement()
              ..text = '🔎'
              ..title = 'Filtrer'
              ..style.position = 'absolute'
              ..style.right = '6px'
              ..style.top = '50%'
              ..style.transform = 'translateY(-50%)'
              ..style.background = 'transparent'
              ..style.border = 'none'
              ..style.color = theme.headerFg.color
              ..style.cursor = 'pointer';
        f.onClick.listen((e) {
          e.stopPropagation();
          _openFilterPopup(c, th);
        });
        th.append(f);
      }

      tr.append(th);
    }
    _thead.append(tr);
  }

  void _onSort(String key, {bool multi = false}) {
    final idx = _sorts.indexWhere((s) => s.key == key);
    if (!multi) {
      // remplace par un seul critère
      if (idx >= 0) {
        final asc = !_sorts[idx].asc;
        _sorts
          ..clear()
          ..add(_SortSpec(key, asc));
      } else {
        _sorts
          ..clear()
          ..add(_SortSpec(key, true));
      }
    } else {
      // multi-tri : shift-click
      if (idx >= 0) {
        _sorts[idx].asc = !_sorts[idx].asc;
      } else {
        _sorts.add(_SortSpec(key, true));
      }
    }
    _page = 0; // reset pagination
    _refreshBody();
  }

  void _openFilterPopup(TableColumn c, Element anchor) {
    final popup =
        DivElement()
          ..style.position = 'absolute'
          ..style.zIndex = '10000'
          ..style.backgroundColor = theme.rowBg.color
          ..style.color = theme.headerFg.color
          ..style.border = '1px solid ${theme.borderColor}'
          ..style.borderRadius = '12px'
          ..style.padding = '10px'
          ..style.boxShadow = '0 20px 40px -20px rgba(0,0,0,.5)';

    final rect = anchor.getBoundingClientRect();
    popup.style.left = '${rect.left}px';
    popup.style.top = '${rect.bottom + 6}px';

    final st = _filters[c.key] ?? _ColumnFilter(_defaultOpFor(c.type));

    final opSel = SelectElement();
    for (final op in _opsFor(c.type)) {
      final o = OptionElement(
        data: op.toString().split('.').last,
        value: op.toString(),
        selected: op == st.op,
      );
      opSel.children.add(o);
    }

    final inputsWrap =
        DivElement()
          ..style.display = 'grid'
          ..style.gap = '8px'
          ..style.marginTop = '8px';

    void rebuildInputs() {
      inputsWrap.children.clear();
      final op = _parseOp(opSel.value);
      if (c.type == DataType.text) {
        final t =
            InputElement()
              ..placeholder = 'texte'
              ..value = st.text
              ..style.padding = '8px'
              ..style.border = '1px solid ${theme.borderColor}'
              ..style.backgroundColor = theme.rowBg.color
              ..style.color = theme.headerFg.color
              ..style.borderRadius = '10px';
        t.onInput.listen((_) => st.text = t.value ?? '');
        inputsWrap.append(t);
      } else if (c.type == DataType.number) {
        if (op == FilterOp.between) {
          final minI =
              InputElement(type: 'number')
                ..placeholder = 'min'
                ..value = (st.min?.toString() ?? '');
          final maxI =
              InputElement(type: 'number')
                ..placeholder = 'max'
                ..value = (st.max?.toString() ?? '');
          for (final i in [minI, maxI]) {
            i
              ..style.padding = '8px'
              ..style.border = '1px solid ${theme.borderColor}'
              ..style.backgroundColor = theme.rowBg.color
              ..style.color = theme.headerFg.color
              ..style.borderRadius = '10px';
          }
          minI.onInput.listen((_) => st.min = num.tryParse(minI.value ?? ''));
          maxI.onInput.listen((_) => st.max = num.tryParse(maxI.value ?? ''));
          inputsWrap.children.addAll([minI, maxI]);
        } else {
          final n =
              InputElement(type: 'number')
                ..placeholder = 'valeur'
                ..value = (st.min?.toString() ?? '');
          n
            ..style.padding = '8px'
            ..style.border = '1px solid ${theme.borderColor}'
            ..style.backgroundColor = theme.rowBg.color
            ..style.color = theme.headerFg.color
            ..style.borderRadius = '10px';
          n.onInput.listen((_) => st.min = num.tryParse(n.value ?? ''));
          inputsWrap.append(n);
        }
      } else if (c.type == DataType.date) {
        final fromI = InputElement(type: 'date');
        final toI = InputElement(type: 'date');
        for (final i in [fromI, toI]) {
          i
            ..style.padding = '8px'
            ..style.border = '1px solid ${theme.borderColor}'
            ..style.backgroundColor = theme.rowBg.color
            ..style.color = theme.headerFg.color
            ..style.borderRadius = '10px';
        }
        if (st.from != null)
          fromI.value = st.from!.toIso8601String().split('T').first;
        if (st.to != null)
          toI.value = st.to!.toIso8601String().split('T').first;
        fromI.onInput.listen(
          (_) =>
              st.from =
                  (fromI.value?.isNotEmpty ?? false)
                      ? DateTime.parse(fromI.value!)
                      : null,
        );
        toI.onInput.listen(
          (_) =>
              st.to =
                  (toI.value?.isNotEmpty ?? false)
                      ? DateTime.parse(toI.value!)
                      : null,
        );
        inputsWrap.children.addAll([fromI, toI]);
      }
    }

    opSel.onChange.listen((_) {
      st.op = _parseOp(opSel.value);
      rebuildInputs();
    });
    rebuildInputs();

    final actions =
        DivElement()
          ..style.display = 'flex'
          ..style.gap = '8px'
          ..style.marginTop = '10px'
          ..style.justifyContent = 'flex-end';
    final apply = _mkBtn('Appliquer');
    final clear = _mkBtn('Effacer');
    apply.onClick.listen((_) {
      _filters[c.key] = st;
      _page = 0;
      popup.remove();
      _refreshBody();
    });
    clear.onClick.listen((_) {
      _filters.remove(c.key);
      _page = 0;
      popup.remove();
      _refreshBody();
    });

    popup.children.addAll([
      DivElement()
        ..text = 'Filtre: ${c.title}'
        ..style.fontWeight = '800',
      opSel,
      inputsWrap,
      actions,
    ]);
    document.body!.append(popup);

    late EventListener? onDoc;
    onDoc = (ev) {
      if (!popup.contains(ev.target as Node?)) {
        popup.remove();
        document.removeEventListener('click', onDoc);
      }
    };
    document.addEventListener('click', onDoc);
  }

  FilterOp _defaultOpFor(DataType t) {
    switch (t) {
      case DataType.text:
        return FilterOp.contains;
      case DataType.number:
        return FilterOp.gt;
      case DataType.date:
        return FilterOp.dateBetween;
      case DataType.boolean:
        return FilterOp.equals;
    }
  }

  List<FilterOp> _opsFor(DataType t) {
    switch (t) {
      case DataType.text:
        return const [FilterOp.contains, FilterOp.equals, FilterOp.notEquals];
      case DataType.number:
        return const [
          FilterOp.gt,
          FilterOp.lt,
          FilterOp.equals,
          FilterOp.between,
        ];
      case DataType.date:
        return const [FilterOp.dateBetween];
      case DataType.boolean:
        return const [FilterOp.equals, FilterOp.notEquals];
    }
  }

  FilterOp _parseOp(String? s) {
    return FilterOp.values.firstWhere(
      (e) => e.toString() == s,
      orElse: () => FilterOp.contains,
    );
  }

  // ---------------- Pipeline de données --------------------------------------
  List<Map<String, dynamic>> _applyAll() {
    Iterable<Map<String, dynamic>> rows = _source;

    // recherche globale
    final q = showSearch ? (_search.value ?? '').trim().toLowerCase() : '';
    if (q.isNotEmpty) {
      rows = rows.where((r) {
        for (final c in columns) {
          if (_hidden.contains(c.key)) continue;
          final v = r[c.key];
          if (v == null) continue;
          final s = _fmtCell(c, v).toLowerCase();
          if (s.contains(q)) return true;
        }
        return false;
      });
    }

    // filtres
    for (final entry in _filters.entries) {
      final key = entry.key;
      final st = entry.value;
      final col = columns.firstWhere((c) => c.key == key);
      rows = rows.where((r) {
        final v = r[key];
        switch (col.type) {
          case DataType.text:
            final s = (v == null) ? '' : '$v'.toLowerCase();
            final t = (st.text).toLowerCase();
            switch (st.op) {
              case FilterOp.contains:
                return s.contains(t);
              case FilterOp.equals:
                return s == t;
              case FilterOp.notEquals:
                return s != t;
              default:
                return true;
            }
          case DataType.number:
            final n = _num(v);
            switch (st.op) {
              case FilterOp.gt:
                return st.min != null ? n > (st.min as num) : true;
              case FilterOp.lt:
                return st.min != null ? n < (st.min as num) : true;
              case FilterOp.equals:
                return st.min != null ? n == (st.min as num) : true;
              case FilterOp.between:
                return (st.min != null && st.max != null)
                    ? (n >= st.min! && n <= st.max!)
                    : true;
              default:
                return true;
            }
          case DataType.date:
            final d = _date(v);
            if (d == null) return false;
            final from = st.from;
            final to = st.to;
            if (from != null &&
                d.isBefore(DateTime(from.year, from.month, from.day)))
              return false;
            if (to != null &&
                d.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59)))
              return false;
            return true;
          case DataType.boolean:
            final b = (v == true);
            if (st.op == FilterOp.equals)
              return st.text.toLowerCase() == 'true' ? b : !b;
            if (st.op == FilterOp.notEquals)
              return st.text.toLowerCase() == 'true' ? !b : b;
            return true;
        }
      });
    }

    // multi-tri
    if (_sorts.isNotEmpty) {
      final list = rows.toList();
      list.sort((a, b) {
        for (final s in _sorts) {
          final col = columns.firstWhere(
            (c) => c.key == s.key,
            orElse: () => columns.first,
          );
          final va = a[s.key];
          final vb = b[s.key];
          int cmp;
          switch (col.type) {
            case DataType.number:
              cmp = _num(va).compareTo(_num(vb));
              break;
            case DataType.date:
              final da = _date(va) ?? DateTime.fromMillisecondsSinceEpoch(0);
              final db = _date(vb) ?? DateTime.fromMillisecondsSinceEpoch(0);
              cmp = da.compareTo(db);
              break;
            default:
              cmp = ('$va').toLowerCase().compareTo(('$vb').toLowerCase());
          }
          if (cmp != 0) return s.asc ? cmp : -cmp;
        }
        return 0;
      });
      rows = list;
    }

    return rows.toList();
  }

  // --------------- Rendu body (+ groupement) ---------------------------------
  void _refreshBody() {
    final rows = _applyAll();

    _tbody.children.clear();

    if (groupByKey != null) {
      _renderGrouped(rows);
    } else {
      // --- pagination simple par lignes ---
      final totalPages = (rows.length / _pageSize).ceil().clamp(1, 1 << 30);
      _page = _page.clamp(0, totalPages - 1);

      final start = _page * _pageSize;
      final end = (start + _pageSize).clamp(0, rows.length);
      final slice = rows.sublist(start, end);

      int i = 0;
      for (final r in slice) {
        _appendDataRow(r, alt: (i++ % 2) == 1);
      }

      _buildFooter(rows);
      _buildPager(rows.length, totalPagesOverride: totalPages);
    }
  }

  void _renderGrouped(List<Map<String, dynamic>> rows) {
    final gKey = groupByKey!;
    // Regroupe
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final r in rows) {
      final k = '${r[gKey]}';
      (groups[k] ??= <Map<String, dynamic>>[]).add(r);
    }

    // Ordre stable (par clé)
    final keys = groups.keys.toList()..sort();

    // Découpe en pages de groupes (on ne coupe pas un groupe en 2)
    final pages = <List<String>>[];
    var cur = <String>[];
    var left = _pageSize;
    for (final k in keys) {
      final len = groups[k]!.length;
      if (cur.isEmpty || len <= left) {
        cur.add(k);
        left -= len;
      } else {
        pages.add(cur);
        cur = [k];
        left = _pageSize - len;
      }
    }
    if (cur.isNotEmpty) pages.add(cur);

    final totalPages = pages.isEmpty ? 1 : pages.length;
    _page = _page.clamp(0, totalPages - 1);

    // Rendu de la page courante (groupes entiers)
    final pageKeys = pages.isEmpty ? <String>[] : pages[_page];
    for (final g in pageKeys) {
      final items = groups[g]!;
      final collapsed = _collapsed[g] ?? false;

      // Ligne “groupe”
      final trG = TableRowElement();
      final tdG = TableCellElement()..colSpan = _visibleCols.length;
      tdG.style
        ..backgroundColor = theme.groupBg.color
        ..padding = '6px 12px'
        ..fontWeight = '800'
        ..borderBottom = '1px solid ${theme.borderColor}'
        ..cursor = groupsCollapsible ? 'pointer' : 'default';
      tdG.text = groupsCollapsible ? (collapsed ? '▶ $g' : '▼ $g') : g;
      if (groupsCollapsible) {
        tdG.onClick.listen((_) {
          _collapsed[g] = !collapsed;
          _refreshBody();
        });
      }
      trG.append(tdG);
      _tbody.append(trG);

      if (!collapsed) {
        int i = 0;
        for (final r in items) {
          _appendDataRow(r, alt: (i++ % 2) == 1);
        }
        // Sous-total visibles
        final trS = TableRowElement();
        for (final c in columns) {
          if (_hidden.contains(c.key)) continue;
          final td = TableCellElement();
          td.style
            ..padding = '0 12px'
            ..height = '${theme.lineHeight}px'
            ..borderBottom = '1px solid ${theme.borderColor}'
            ..backgroundColor = theme.subtotalBg.color
            ..fontWeight = '800'
            ..textAlign = c.align;
          if (c.type == DataType.number) {
            num s = 0;
            for (final r in items) {
              s += _num(r[c.key]);
            }
            td.text = s.toStringAsFixed(2);
          } else if (trS.children.isEmpty) {
            td.text = 'Sous-total';
          }
          trS.append(td);
        }
        _tbody.append(trS);
      }
    }

    _buildFooter(rows);
    _buildPager(rows.length, totalPagesOverride: totalPages);
  }

  List<TableColumn> get _visibleCols => [
    for (final c in columns)
      if (!_hidden.contains(c.key)) c,
  ];

  void _appendDataRow(Map<String, dynamic> r, {bool alt = false}) {
    final tr = TableRowElement();
    tr.style.backgroundColor = alt ? theme.altRowBg.color : theme.rowBg.color;
    tr.onMouseOver.listen(
      (_) => tr.style.backgroundColor = theme.hoverBg.color,
    );
    tr.onMouseOut.listen(
      (_) =>
          tr.style.backgroundColor =
              alt ? theme.altRowBg.color : theme.rowBg.color,
    );

    for (final c in columns) {
      if (_hidden.contains(c.key)) continue;
      final td = TableCellElement();
      td.style
        ..padding = '0 12px'
        ..height = '${theme.lineHeight}px'
        ..borderBottom = '1px solid ${theme.borderColor}'
        ..textAlign = c.align
        ..whiteSpace = 'nowrap'
        ..overflow = 'hidden'
        ..textOverflow = 'ellipsis';
      if (c.cellBuilder != null) {
        td.append(c.cellBuilder!(r).create());
      } else {
        td.text = _fmtCell(c, r[c.key]);
      }
      tr.append(td);
    }
    _tbody.append(tr);
  }

  void _buildFooter(List<Map<String, dynamic>> full) {
    // Recrée TFOOT proprement
    final tf = _table.tFoot ?? _table.createTFoot();
    tf.children.clear();

    final numCols = <int, num>{};
    int ci = 0;
    for (final c in columns) {
      if (_hidden.contains(c.key)) {
        ci++;
        continue;
      }
      if (c.sum && c.type == DataType.number) {
        num s = 0;
        for (final r in full) {
          s += _num(r[c.key]);
        }
        numCols[ci] = s;
      }
      ci++;
    }

    if (numCols.isEmpty) return; // pas de footer si aucune somme

    final tr = TableRowElement();
    ci = 0;
    for (final c in columns) {
      if (_hidden.contains(c.key)) {
        ci++;
        continue;
      }
      final td = TableCellElement();
      td.style
        ..padding = '8px 12px'
        ..height = '${theme.lineHeight}px'
        ..backgroundColor = theme.headerBg.color
        ..borderTop = '1px solid ${theme.borderColor}'
        ..fontWeight = '800'
        ..textAlign = c.align;
      if (numCols.containsKey(ci)) td.text = numCols[ci]!.toStringAsFixed(2);
      tr.append(td);
      ci++;
    }
    tf.append(tr);
  }

  void _buildPager(int filteredCount, {int? totalPagesOverride}) {
    _pager.children.clear();
    final totalPages =
        totalPagesOverride ??
        (filteredCount / _pageSize).ceil().clamp(1, 1 << 30);
    _page = _page.clamp(0, totalPages - 1);

    final info =
        SpanElement()
          ..text = '${filteredCount} éléments · page ${_page + 1}/$totalPages';
    final prev = _mkBtn('◀');
    final next = _mkBtn('▶');
    prev.onClick.listen((_) {
      if (_page > 0) {
        _page--;
        _refreshBody();
      }
    });
    next.onClick.listen((_) {
      if (_page < totalPages - 1) {
        _page++;
        _refreshBody();
      }
    });

    _pager.children.addAll([
      info,
      DivElement()..children.addAll([prev, next]),
    ]);
  }

  // ---------------------- Export (colonnes visibles) --------------------------
  List<Map<String, dynamic>> _currentRowsForExport() => _applyAll();

  void _exportCsv() {
    final rows = _currentRowsForExport();
    final vis = _visibleCols;
    final headers = vis.map((c) => c.title).toList();

    String csvEscape(String s) {
      var t = s.replaceAll('"', '""');
      if (t.contains(';') || t.contains('\n')) t = '"' + t + '"';
      return t;
    }

    final sb = StringBuffer();
    sb.writeln(headers.map(csvEscape).join(';'));
    for (final r in rows) {
      sb.writeln(
        [for (final c in vis) csvEscape(_fmtCell(c, r[c.key]))].join(';'),
      );
    }

    final blob = Blob([sb.toString()], 'text/csv;charset=utf-8');
    final url = Url.createObjectUrlFromBlob(blob);
    final a = AnchorElement(href: url)..download = 'export.csv';
    a.click();
    Url.revokeObjectUrl(url);
  }

  void _exportExcelHtml() {
    final rows = _currentRowsForExport();
    final vis = _visibleCols;
    final sb = StringBuffer();
    sb.writeln(
      '<!DOCTYPE html><html><head><meta charset="UTF-8"></head><body>',
    );
    sb.writeln('<table border="1" style="border-collapse:collapse">');
    sb.write('<tr>');
    for (final c in vis) {
      sb.write('<th>${_escapeHtml(c.title)}</th>');
    }
    sb.writeln('</tr>');
    for (final r in rows) {
      sb.write('<tr>');
      for (final c in vis) {
        sb.write('<td>${_escapeHtml(_fmtCell(c, r[c.key]))}</td>');
      }
      sb.writeln('</tr>');
    }
    sb.writeln('</table></body></html>');
    final blob = Blob([sb.toString()], 'application/vnd.ms-excel');
    final url = Url.createObjectUrlFromBlob(blob);
    final a = AnchorElement(href: url)..download = 'export.xls';
    a.click();
    Url.revokeObjectUrl(url);
  }

  void _exportPdf() {
    final rows = _currentRowsForExport();
    final vis = _visibleCols;
    final style =
        'body{font-family:${theme.fontFamily};padding:20px;} table{width:100%;border-collapse:collapse;} th,td{border:1px solid #ccc;padding:6px 8px;} th{background:#f0f0f0;}';
    final b =
        StringBuffer()
          ..writeln(
            '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Export</title><style>$style</style></head><body>',
          )
          ..writeln('<h3>Export</h3>')
          ..writeln('<table><thead><tr>');
    for (final c in vis) {
      b.write('<th>${_escapeHtml(c.title)}</th>');
    }
    b.writeln('</tr></thead><tbody>');
    for (final r in rows) {
      b.write('<tr>');
      for (final c in vis) {
        b.write('<td>${_escapeHtml(_fmtCell(c, r[c.key]))}</td>');
      }
      b.writeln('</tr>');
    }
    b.writeln(
      '</tbody></table><script>window.onload=function(){try{window.focus();window.print();}catch(e){}}</script></body></html>',
    );

    final blob = Blob([b.toString()], 'text/html');
    final url = Url.createObjectUrlFromBlob(blob);
    window.open(url, '_blank');
    Future.delayed(
      Duration(milliseconds: 10000),
      () => Url.revokeObjectUrl(url),
    );
  }

  @override
  Element get getElement => _root;
}
