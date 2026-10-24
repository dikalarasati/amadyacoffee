/// Mengubah angka menjadi format Rupiah, contoh: 28000 -> "Rp 28.000".
String formatRupiah(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return '${value < 0 ? '-' : ''}Rp $buffer';
}
