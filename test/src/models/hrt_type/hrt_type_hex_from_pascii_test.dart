import 'package:flutter_test/flutter_test.dart';
import 'package:hrtvirtual/src/models/hrt_type.dart';

void main() {
  test('Deve dar ABACATE quando valor em hex for 0010810C1505', () {
    const valorHex = 'ABACATE' ;
    expect(hrtTypeHexFrom(valorHex,'PAscii'), '0010810C1505');
  });
}