import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/MyWidgets/DailyWeatherCard.dart';
import 'package:weather/SearchPage.dart';

import 'MyWidgets/LoadingWidgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  String location = "Kütahya";
  double? temp;
  var locationData;
  final String ApiKey = "8a67629475c4a96c38a106df14d21859";
  String code = "c";
  Position? devicePosition;
  String? imageUrl;

  List<String> imageUrlList = [
    "01d",
    "01d",
    "01d",
    "01d",
    "01d",
  ];
  List<double> tempList = [20.0, 20.0, 20.0, 20.0, 20.0];
  List<String> dateList = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma"];
  Future<void> getLocationDataFromApi() async {
    locationData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$ApiKey&units=metric")); // belirli bir api üzerinden veeri çekilmiştir
    //burada ki get metototu future<response> şeklinde bir değer dönmktedir
    //atılan istekler direkt olarak string içeriisnde gelmemekte
    //bir response objesi olarak dönmekte
    //atılan isteğin beklemek için await ifadesi iile async ifadesi eklenmiştir
    //bekleme sonrası ileride bir şey döneceğinden dolayı future olarak tanımladık
    final locationDataParse = jsonDecode(locationData.body);

    temp = locationDataParse["main"]["temp"];
    location = locationDataParse["name"];
    code = locationDataParse["weather"].first["main"];
    imageUrl = locationDataParse["weather"].first["icon"];
    setState(() {});
  }

  Future<void> getLocationDataFromApiByLatLon() async {
    if (devicePosition != null) {
      locationData = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$ApiKey&units=metric")); // belirli bir api üzerinden veeri çekilmiştir
      //burada ki get metototu future<response> şeklinde bir değer dönmktedir
      //atılan istekler direkt olarak string içeriisnde gelmemekte
      //bir response objesi olarak dönmekte
      //atılan isteğin beklemek için await ifadesi iile async ifadesi eklenmiştir
      //bekleme sonrası ileride bir şey döneceğinden dolayı future olarak tanımladık
      final locationDataParse = jsonDecode(locationData.body);

      temp = locationDataParse["main"]["temp"];
      location = locationDataParse["name"];
      code = locationDataParse["weather"].first["main"];
      imageUrl = locationDataParse["weather"].first["icon"];
      setState(() {});
    }
  }

  Future<void> getDevicePosition() async {
    try {
      devicePosition = await _determinePosition();
    } catch (e) {
      print("konum bilgisi alınmadı $e");
    }
    print(devicePosition);
  }

  Future<void> getDailyForecastByLatLon() async {
    var forecastData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$ApiKey&units=metric"));
    var forecastDataParse = jsonDecode(forecastData.body);
    tempList.clear();
    imageUrlList.clear();
    dateList.clear();

    setState(() {
      tempList.add(forecastDataParse["list"][7]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][15]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][23]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][31]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][39]["main"]["temp"]);

      imageUrlList.add(forecastDataParse["list"][7]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][15]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][23]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][31]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][39]["weather"].first["icon"]);

      dateList.add(forecastDataParse["list"][7]["dt_txt"]);
      dateList.add(forecastDataParse["list"][15]["dt_txt"]);
      dateList.add(forecastDataParse["list"][23]["dt_txt"]);
      dateList.add(forecastDataParse["list"][31]["dt_txt"]);
      dateList.add(forecastDataParse["list"][39]["dt_txt"]);
    });
  }

  Future<void> getDailyForecastByLocation() async {
    var forecastData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$ApiKey&units=metric"));
    var forecastDataParse = jsonDecode(forecastData.body);
    tempList.clear();
    imageUrlList.clear();
    dateList.clear();

    setState(() {
      tempList.add(forecastDataParse["list"][7]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][15]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][23]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][31]["main"]["temp"]);
      tempList.add(forecastDataParse["list"][39]["main"]["temp"]);

      imageUrlList.add(forecastDataParse["list"][7]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][15]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][23]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][31]["weather"].first["icon"]);
      imageUrlList.add(forecastDataParse["list"][39]["weather"].first["icon"]);

      dateList.add(forecastDataParse["list"][7]["dt_txt"]);
      dateList.add(forecastDataParse["list"][15]["dt_txt"]);
      dateList.add(forecastDataParse["list"][23]["dt_txt"]);
      dateList.add(forecastDataParse["list"][31]["dt_txt"]);
      dateList.add(forecastDataParse["list"][39]["dt_txt"]);
    });
  }

  void getInitialData() async {
    await getDevicePosition();
    await getLocationDataFromApiByLatLon();
    await getDailyForecastByLatLon();
  }

  @override
  void initState() {
    //burada iki işlem içn bekleme olacağından ve de
    //initstate i async şeklinde bir ifade ile saramayacağımdan dolayı
    //başka bir metot içerisinde biz bu metotları beklemeli olarak çağırabiliriz
    //bu şekildie yapılması geremektedir
    // getDevicePosition();
    // getLocationDataFromApiByLatLon();
    //getLocationDataFromApi(); burada ki metota artık gerek yoktur
    //çünkü burada ki çağırma işlemi şehir girilmesi ile elde edilmekteydi
    getInitialData();
    super.initState();
  }
  //bu metot program çalıştığı zaman bir kez çalışır butonlara basılsa bile
  //ekran tekrardan yenilendiğinde butona basıldığında bile sadece 1 kez çalışmaktadır
  //bu çalışma süreci ise ilk progra çalıştığı sıradadır
  //genelde gps verilerini çekmek vb işlemler için kullanılmaktadır
  //burada bizim aldığımı hava verileri için belirli bir bekleme süresi olduığundan await/async ifadeleri eklenmelidir
  //ama initsatate bu ifadelere izin vermemmektedir

  @override
  Widget build(BuildContext context) {
    BoxDecoration containerDecoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/image/$code.jpg"),
        fit: BoxFit
            .cover, // ekrana yerleştirilen resimi boşluklarının olmaması için ekranı olduğu gibi kapla dedik
      ),
    );
    return Container(
      decoration: containerDecoration,
      //eğer temp null ise circcularprogressIndicato göster
      //eğer null değil ise set state yap ve  scaffold ı göster
      child: (temp == null || devicePosition == null)
          ? const LoadingWidget()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width:
                          100, //genelde uygulamalar yukarı aşağı kaydırılabilir olduğu için bu şekilde bir genişlik değeri verilmiştir
                      child: Image.network(
                          "https://openweathermap.org/img/wn/$imageUrl@2x.png"),
                    ),
                    Text(
                      "$temp°C",
                      style: const TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                              offset: Offset(-3, 3)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(-3, 3)),
                            ],
                          ),
                        ),
                        IconButton(
                          //icon buton oluşturuldu
                          onPressed: () async {
                            //search sayfasında ki veriyi seleectes city içerisine aktardık
                            final selectedCity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchPage()));
                            //butona tıklandığı zaman navigation ile bir sonra ki sayfaya gitme işlemi yapılmıştır
                            location = selectedCity;
                            getLocationDataFromApi();
                            getDailyForecastByLocation();
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    buildWeatherCart(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildWeatherCart(BuildContext context) {
    List<Dailyweathercard> DailyweathercardList = [
      Dailyweathercard(
          imageUrl: imageUrlList[0], temp: tempList[0], date: dateList[0]),
      Dailyweathercard(
          imageUrl: imageUrlList[1], temp: tempList[1], date: dateList[1]),
      Dailyweathercard(
          imageUrl: imageUrlList[2], temp: tempList[2], date: dateList[2]),
      Dailyweathercard(
          imageUrl: imageUrlList[3], temp: tempList[3], date: dateList[3]),
      Dailyweathercard(
          imageUrl: imageUrlList[4], temp: tempList[4], date: dateList[4]),
    ];

    return SizedBox(
      height: 150,
      //ekran genişliğinin 90 nı kadar yayıl
      width: MediaQuery.of(context).size.width * 0.9,
      //ekran genişliğini bulduk bu mtod ile
      child: ListView(
        // ekrana kaydırma özelliği eklendi
        scrollDirection: Axis.horizontal, //yatayda olması sağlandı
        children: [
          DailyweathercardList[0],
          DailyweathercardList[1],
          DailyweathercardList[2],
          DailyweathercardList[3],
          DailyweathercardList[4],
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

// ElevatedButton(
//   onPressed: () async {
//     print("getLocaitoData çağrılmadan önce : $locationData");
//     await getLocationData();
//     // Future.delayed(
//     //   Duration(seconds: 3),
//     //   () => print(
//     //       "getLocaitoData çağrıldıktan sonra : $locationData"),
//     // ); // 3 sn bekle
//     print("getLocaitoData çağrıldıktan sonra : $locationData");
//
//     final locationDataParse = jsonDecode(locationData.body);
//
//     print(locationDataParse);
//     print(locationDataParse.runtimeType);
//     print(locationDataParse["main"]["temp"]);
//     // print(locationData
//     //     .body); //gelen responsun içerisindekileri görmek için kullanılır
//     // //reposns istek sonrası gelen veridir yani istek sonucunda oluşan obje ya da data olarak
//     // //söyleyebiliriz
//     // print(locationData
//     //     .body.runtimeType); //gelen verinin tipini gördük
//   },
//   child: Text("getlocationdata"),
// ),
