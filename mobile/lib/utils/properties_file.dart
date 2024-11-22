class PropertiesFile {
  final Map<String, String> _properties = {};

  PropertiesFile(String propertiesString) {
    propertiesString.split("\n").forEach((line) {
      var pair = line.split("=");
      if (pair.length != 2) {
        return;
      }
      if (pair.last.isNotEmpty) {
        _properties[pair.first] = pair.last;
      }
    });
  }

  String stringForKey(String key) {
    assert(_properties.containsKey(key));
    return _properties[key]!;
  }
}
