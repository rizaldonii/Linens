class Campaign {
  final String id;
  final String imagePath;
  final String title;
  final String pembuat;
  final String amount;
  final String cerita;
  final String ajakan;
  final int durasi;
  final int biayaTerkumpul;
  final double progressValue;

  Campaign({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.pembuat,
    required this.amount,
    required this.cerita,
    required this.ajakan,
    required this.durasi,
    required this.biayaTerkumpul,
    required this.progressValue,
  });
}
