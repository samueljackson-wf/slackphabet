import 'dart:io';
import 'dart:math';

const String whiteColor = 'white';
const String yellowColor = 'yellow';

abstract class ColorGenerator {
  String getColor();
}

class WhiteColorGenerator implements ColorGenerator {
  @override
  String getColor() => whiteColor;
}

class YellowColorGenerator implements ColorGenerator {
  @override
  String getColor() => yellowColor;
}

class AlternateColorGenerator implements ColorGenerator {
  bool _lastWasYellow = false;
  @override
  String getColor() {
    final color = _lastWasYellow ? whiteColor : yellowColor;
    _lastWasYellow = !_lastWasYellow;
    return color;
  }
}

class RandomColorGenerator implements ColorGenerator {
  static final _random = Random();
  @override
  String getColor() => _random.nextInt(2) == 1
    ? whiteColor
    : yellowColor;
}

class LetterGenerator {
  final ColorGenerator _colorGen;

  LetterGenerator(this._colorGen);

  List<String> toEmojiLetters(String message) {
    final letters = message.split('');
    return letters.map(_getEmojiForLetter).toList();
  }

  String _getEmojiForLetter(String letter) {
    // Handle special cases:
    if (letter == ' ') return '  '; // double-width spaces
    if (!_isValidLetter(letter)) return letter; // has no emoji letter

    final color = _colorGen.getColor();

    String l;
    if (letter == '?') {
      l = 'question';
    } else if (letter == '!') {
      l = 'exclamation';
    } else {
      l = letter.toLowerCase();
    }

    return ':alphabet-$color-$l:';
  }

  static final RegExp letterMatcher = RegExp('[a-zA-Z\?\!]');
  bool _isValidLetter(String letter) {
    if (letter == null || letter.length != 1) return false;

    return letterMatcher.hasMatch(letter);
  }
}

ColorGenerator getColorGenerator(List<String> args) {
  if (args.isEmpty || args.length > 2) {
    print('Usage: slackphabet "message" --[white|yellow|alternate|random]');
    exit(1);
  }

  final color = args.length == 1
    ? '--white'
    : args.last;

  switch(color) {
    case '--yellow':
      return YellowColorGenerator();
    case '--random':
      return RandomColorGenerator();
    case '--alternate':
      return AlternateColorGenerator();
    case '--white':
    default:
      return WhiteColorGenerator();
  }
}

void main(List<String> args) async {
  final colorGen = getColorGenerator(args);
  final emojiGen = LetterGenerator(colorGen);

  final emojiStr = emojiGen.toEmojiLetters(args.first).join('');
  final p = await Process.start('pbcopy', []);
  p.stdin.writeln(emojiStr);
  await p.stdin.close();
  exit(0);
}