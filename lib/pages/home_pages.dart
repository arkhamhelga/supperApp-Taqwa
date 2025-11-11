import 'dart:async'; //timer coundown
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; //carousel slider
import 'package:http/http.dart' as http; //ambil data API
import 'dart:convert'; //decode JSON
import 'package:geolocator/geolocator.dart'; //GPS
import 'package:geocoding/geocoding.dart'; //konversi GPS
import 'package:intl/intl.dart'; //Format Nummber
import 'package:permission_handler/permission_handler.dart'; //Izin Handler
import 'package:shared_preferences/shared_preferences.dart'; // cache lokal
import 'package:string_similarity/string_similarity.dart'; // fuzzy match string

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  bool _isloading = true;
  Duration? _timeRemaining;
  Timer? _countdownTimer;
  String _location = 'mengambil loaksi....';
  String _prayerTime = 'Loading ....';
  String _backgroundImage = 'assets/images/bg_morning';
  List<dynamic>? _jadwalSholat;

  //State untuk dijalankan diawal
  @override
  void initState() {
    super.initState();
  }

  final posterlist = const <String>[
    'assets/images/ramadhan-kareem.png',
    'assets/images/idl-fitr.png',
    'assets/images/idl-adh.png',
    'assets/images/bg_afternoon.png',
    'assets/images/bg_morning.png',
    'assets/images/bg_night.png',
  ];

  //Fungsi text remaining waktu sholat
  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minute = d.inMinutes;
    return "$hours jam $minute menit lagi";
  }

  Future _getBackgroudImage(DateTime now) async {
    if (now.hour < 12) {
      return 'assets/images/bg_morning.png';
    } else if (now.hour < 18) {
      return 'assets/images/bg_afternoon.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //=========================================
              //[MENU WAKTU SHOLAT BY LOKASI]
              //=========================================
              _buildHeroSection(),
              const SizedBox(height: 65),
              // ========================================
              //[MENU SECTION]
              // ========================================
              _buidMenuGridSection(),
              // ========================================
              //[CAROUSEL SECTION]
              // ========================================
              _buildCaroucelSection(),
            ],
          ),
        ),
      ),
    );
  }

  //=======================================
  //[MENU HERO WIDGET]
  //=======================================
  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFB3E5FC),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_afternoon.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Assalamu\'alaikum',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Ngargoyoso',
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 50,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        //=========== WAKTU SHOLAT SELANJUTNYA===============
        Positioned(
          bottom: -55,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 4),
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Column(
              children: [
                Text(
                  'Waktu Sholat Berikutnya',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Ashar',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 20,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  '14:22',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 28,
                    color: Colors.black38,
                  ),
                ),
                Text(
                  '5 Jam 10 menit',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //=======================================
  //[MENU GRID SECTION WIDGET]
  //=======================================
  Widget _buidMenuItem(String iconPath, String title, String roudname) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, roudname);
        },
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.amber.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 35),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=======================================
  //[MENU GRID SECTION WIDGET]
  //=======================================
  Widget _buidMenuGridSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buidMenuItem(
            'assets/images/ic_menu_doa.png', //icon path
            'Doa', // title
            'Doa',
          ), //route name
          _buidMenuItem(
            'assets/images/ic_menu_jadwal_sholat.png', //icon path
            'sholat', //title
            'Sholat',
          ), //route name
          _buidMenuItem(
            'assets/images/ic_menu_Zakat.png', //icon patch
            'Zakat', //title
            'Zakat',
          ), //route name
          _buidMenuItem(
            'assets/images/ic_menu_doa.png', //icon path
            'Doa', // title
            'Doa',
          ), //route name
          _buidMenuItem(
            'assets/images/ic_play_video_kajian.png', //icon path
            'Kajian', //title
            'Kajian Islam',
          ), //route name
        ],
      ),
    );
  }

  //=======================================
  //[CAROUSEL SECTION]
  //=======================================
  Widget _buildCaroucelSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CarouselSlider.builder(
          itemCount: posterlist.length,
          itemBuilder: (context, index, realindex) {
            final poster = posterlist[index];
            return Container(
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(
                  poster,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 270,
            enlargeCenterPage: true,
            viewportFraction: 0.7,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        // DOT INDIKATOR carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: posterlist.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _currentIndex.animateToPage(entry.key),
              child: Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Colors.amber
                      : Colors.grey[400],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension on int {
  void animateToPage(int key) {}
}
