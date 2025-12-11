enum SwitcherButtonColors { white, red, green, orange, blue }

extension SwitcherButtonColorsValue on SwitcherButtonColors {
  String get value {
    switch (this) {
      case SwitcherButtonColors.white:
        return 'neutral';
      case SwitcherButtonColors.green:
        return 'green';
      case SwitcherButtonColors.red:
        return 'red';
      case SwitcherButtonColors.orange:
        return 'orange';
      case SwitcherButtonColors.blue:
        return 'blue';
    }
  }

  int get hex {
    switch (this) {
      case SwitcherButtonColors.white:
        return 0xFFAAAAAA;
      case SwitcherButtonColors.green:
        return 0xFF88C100;
      case SwitcherButtonColors.red:
        return 0xFFFF003C;
      case SwitcherButtonColors.orange:
        return 0xFFFF631B;
      case SwitcherButtonColors.blue:
        return 0xFF007196;
    }
  }
}
