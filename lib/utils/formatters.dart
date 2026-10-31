String formatUsd(double value) {
  final fixed = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
  final parts = fixed.split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  final cents = parts.length > 1 ? '.${parts[1]}' : '';
  return '\$${buffer.toString()}$cents';
}
