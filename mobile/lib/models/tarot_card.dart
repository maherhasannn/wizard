class TarotCard {
  final String imagePath;
  final String title;
  final String romanNumeral;
  final String mainAdvice;
  final String description;
  final String actionText;
  final String mediaTitle;
  final String mediaDuration;

  TarotCard({
    required this.imagePath,
    required this.title,
    required this.romanNumeral,
    required this.mainAdvice,
    required this.description,
    required this.actionText,
    required this.mediaTitle,
    required this.mediaDuration,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      imagePath: json['imagePath'] as String,
      title: json['title'] as String,
      romanNumeral: json['romanNumeral'] as String,
      mainAdvice: json['mainAdvice'] as String,
      description: json['description'] as String,
      actionText: json['actionText'] as String,
      mediaTitle: json['mediaTitle'] as String,
      mediaDuration: json['mediaDuration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'title': title,
      'romanNumeral': romanNumeral,
      'mainAdvice': mainAdvice,
      'description': description,
      'actionText': actionText,
      'mediaTitle': mediaTitle,
      'mediaDuration': mediaDuration,
    };
  }
}
