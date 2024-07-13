import 'dart:io';

double calculate(double num1, double num2, String operator) {
  switch (operator) {
    case '+':
      return num1 + num2;
    case '-':
      return num1 - num2;
    case '*':
      return num1 * num2;
    case '/':
      if (num2 != 0) {
        return num1 / num2;
      } else {
        throw ArgumentError('Tidak bisa melakukan pembagian dengan nol.');
      }
    default:
      throw ArgumentError('Operator tidak valid.');
  }
}

void main() {
  try {
    stdout.write('Masukkan operand pertama: ');
    String? input1 = stdin.readLineSync();
    double num1 = double.parse(input1!);

    stdout.write('Masukkan operand kedua: ');
    String? input2 = stdin.readLineSync();
    double num2 = double.parse(input2!);

    stdout.write('Masukkan operator (+, -, *, /): ');
    String? operator = stdin.readLineSync();

    if (operator != null) {
      double result = calculate(num1, num2, operator);
      print('Hasil: $num1 $operator $num2 = $result');
    } else {
      print('Operator tidak boleh kosong.');
    }
  } catch (e) {
    print('Terjadi kesalahan: $e');
  }
}
