import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCity = "";
  final String ApiKey = "8a67629475c4a96c38a106df14d21859";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/search.jpg"),
          fit: BoxFit
              .cover, // ekrana yerleştirilen resimi boşluklarının olmaması için ekranı olduğu gibi kapla dedik
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //burada appbar konulma sebebi geri dönüş tuşu olmöasını sağlamaktır
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //şeffaf yaparak bir şey yokmuş gibi görünmesini sağladık
          elevation:
              0, // üstte ki yüksekliği sıfırladık appbar ile gelen bir yükseklik
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  //buraya bir tıklaa vb işlem yapıldığında bana bir işlem ver onu yapayım anlamında bir metoto
                  //string alması gereken bir metottur
                  onChanged: (value) {
                    selectedCity = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Şehir Seçiniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center, //yazıyı ortaladık
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  //Bu şehir için API yanıt veriyor mu
                  var respons = await http.get(Uri.parse(
                      "https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=$ApiKey&units=metric"));
                  (respons.statusCode == 200)
                      ? Navigator.pop(context, selectedCity)
                      : QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Lokasyon Bulunmadı',
                          text: 'Başka bir lokasyon giriniz',
                          confirmBtnText: "tamam",
                        );
                  //sayfayı kaldır
                  //Navigator.pop(context, selectedCity):
                  //sayfayı açan satıra veri gönder
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: Text("Seçilen Şehir"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
