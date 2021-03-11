import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/mnemonic/word_list_english.dart';

class WordList {
  static final instances = <String, WordList>{};

  final String language;

  List<String> words = [];

  WordList._create({
    required this.language,
  }) {
    // Load the words and iterate over them
    words = WORD_LIST_ENGLISH.split('\n');

    // Drop the last word (\n) in the list
    words.removeLast();

    if (words.length != 2048) {
      throw MnemonicException(
        'BIP39 words list file must have precise 2048 entries',
      );
    }
  }

  static WordList english() {
    return getLanguage(language: 'english');
  }

  static WordList getLanguage({String language = 'english'}) {
    final instance = instances[language];
    if (instance != null) {
      return instance;
    }

    final wordList = WordList._create(language: language);
    instances[language] = wordList;
    return getLanguage(language: language);
  }

  /// Get the word at the specified index.
  String getWord(int index) {
    try {
      return words[index];
    } on RangeError {
      throw MnemonicException('Word not found in word list.');
    }
  }

  int findIndex(String word) {
    final index = words.indexOf(word.toLowerCase());

    return index > -1
        ? index
        : throw MnemonicException('Word not found in word list.');
  }
}
