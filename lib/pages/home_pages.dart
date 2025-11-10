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

  final posterlist = const <String>[
    'assets/images/ramadhan-kareem.png',
    'assets/images/idl-fitr.png',
    'assets/images/idl-adh.png',
    'assets/images/bg_afternoon.png',
    'assets/images/bg_morning.png',
    'assets/images/bg_night.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
    );
  }

  //=======================================
  //[MENU GRID SECTION WIDGET]
  //=======================================
  Widget _buidMenuItem(
    String iconPath,
    String title,
    String roudname,
  ) {
    return InkWell(
      onTap: () {},
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
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 35,),
            const SizedBox(height: 6,),
            Text(
              title,
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 13),
              ),
          ],
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
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buidMenuItem(
          'assets/images/ic_menu_doa.png', //icon path
          'Doa Harian', // title
          'Doa'), //route name
          _buidMenuItem(
          'assets/images/ic_menu_jadwal_sholat.png', //icon path
          'Jadwal sholat', //title
          'Sholat'), //route name
          _buidMenuItem(
          'assets/images/ic_menu_Zakat.png', //icon patch
          'Zakat', //title
          'Zakat'), //route name
          _buidMenuItem('assets/images/ic_play_video_kajian.png', //icon path
          'Video Kajian', //title
        'Kajian Islam'), //route name
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
