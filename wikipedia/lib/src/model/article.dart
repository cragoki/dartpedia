class Article {
  Article({required this.title, required this.extract});

  final String title;
  final String extract;

  //Unlike previous models that create a single instance, the Wikipedia search endpoint returns multiple articles in a map.
  // Dart constructors only return a single instance, so Article uses a static method named listFromJson to return a List<Article>
  static List<Article> listFromJson(Map<String, Object?> json) {
    final List<Article> articles = <Article>[];
    if (json case {'query': {'pages': final Map<String, Object?> pages}}) {
      //extract each entry's value directly without manual property access.
      for (final MapEntry<String, Object?>(:Object? value) in pages.entries) {
        if (value case {
        'title': final String title,
        'extract': final String extract,
        }) {
          articles.add(Article(title: title, extract: extract));
        }
      }
      return articles;
    }
    throw FormatException('Could not deserialize Article, json=$json');
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'title': title,
    'extract': extract,
  };

  @override
  String toString() {
    return 'Article{title: $title, extract: $extract}';
  }
}