class PdfItemModel {
  final String id;
  final String name;
  final String path;
  final DateTime createdAt;
  final int lastPage;
  final bool isAsset;
  final String? fileSizeLabel;

  const PdfItemModel({
    required this.id,
    required this.name,
    required this.path,
    required this.createdAt,
    this.lastPage = 1,
    this.isAsset = false,
    this.fileSizeLabel,
  });

  PdfItemModel copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? createdAt,
    int? lastPage,
    bool? isAsset,
    String? fileSizeLabel,
  }) {
    return PdfItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      lastPage: lastPage ?? this.lastPage,
      isAsset: isAsset ?? this.isAsset,
      fileSizeLabel: fileSizeLabel ?? this.fileSizeLabel,
    );
  }

  factory PdfItemModel.fromMap(Map<String, dynamic> map) {
    return PdfItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      path: map['path'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastPage: map['lastPage'] as int? ?? 1,
      isAsset: map['isAsset'] as bool? ?? false,
      fileSizeLabel: map['fileSizeLabel'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'createdAt': createdAt.toIso8601String(),
      'lastPage': lastPage,
      'isAsset': isAsset,
      'fileSizeLabel': fileSizeLabel,
    };
  }
}
