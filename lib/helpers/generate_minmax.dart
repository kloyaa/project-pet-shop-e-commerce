import 'dart:math';

int randomNumber(min, max) {
  Random random = Random();

  int _min = min;
  int _max = max;
  int result = _min + random.nextInt(_max - _min);

  return result;
}
