import 'package:flutter/material.dart';

class Dailyweathercard extends StatelessWidget {
  const Dailyweathercard(
      {super.key,
      required this.imageUrl,
      required this.temp,
      required this.date});
  final String imageUrl;
  final double temp;
  final String date;
  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar",
    ];

    String weekD = weekDays[DateTime.parse(date).weekday -
        1]; //haftanın kaçıncı gün olduğunu veriyor index numaram yani
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        height: 200,
        width: 150,
        child: Column(
          children: [
            Image.network("https://openweathermap.org/img/wn/$imageUrl@2x.png"),
            Text(
              "$temp°C",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              weekD,
            ),
          ],
        ),
      ),
    );
  }
}
