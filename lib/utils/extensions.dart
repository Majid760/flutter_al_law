extension PngImage on String {
  String get png => 'assets/pngs/$this.png';
}

extension SvgImage on String {
  String get svg => 'assets/svgs/$this.svg';
}
