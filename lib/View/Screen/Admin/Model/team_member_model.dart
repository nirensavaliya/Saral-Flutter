class TeamMemberListModel {
  List<TeamMemberData>? data;
  int? statusCode;
  String? responseMsg;

  TeamMemberListModel({this.data, this.statusCode, this.responseMsg});

  TeamMemberListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg']?.toString();
    final raw = json['data'];
    if (raw is List) {
      data = raw
          .whereType<Map>()
          .map((e) => TeamMemberData.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (raw is Map) {
      final nested = raw['items'] ?? raw['list'] ?? raw['data'];
      if (nested is List) {
        data = nested
            .whereType<Map>()
            .map((e) => TeamMemberData.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
  }
}

class TeamMemberData {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? imageBase64string;

  TeamMemberData({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.imageBase64string,
  });

  factory TeamMemberData.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ??
        json['Id'] ??
        json['teamMemberId'] ??
        json['teamMemberID'];
    int? id;
    if (rawId is int) {
      id = rawId;
    } else {
      id = int.tryParse(rawId?.toString() ?? '');
    }

    return TeamMemberData(
      id: id,
      name: json['name']?.toString() ?? json['memberName']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString() ??
          json['imageURL']?.toString() ??
          json['image']?.toString() ??
          json['imageFileName']?.toString(),
      imageBase64string: json['imageBase64string']?.toString() ??
          json['imageBase64']?.toString(),
    );
  }

  String? get displayImage {
    final url = imageUrl?.trim();
    if (url != null && url.isNotEmpty) return url;
    final base64 = imageBase64string?.trim();
    if (base64 != null && base64.isNotEmpty) {
      if (base64.startsWith('http') || base64.startsWith('data:')) {
        return base64;
      }
      return 'data:image/jpeg;base64,$base64';
    }
    return null;
  }
}
