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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/ic_menu_doa.png'),
                                Text(
                                  'Doa & zikir',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/ic_menu_zakat.png'),
                                Text(
                                  'Zakat',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_menu_jadwal_sholat.png',
                                ),
                                Text(
                                  'Jadwal Sholat',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_play_video_kajian.png',
                                ),
                                Text(
                                  'Video Kajian',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ========================================
            //[CAROUSEL SECTION]
            // ========================================
            _buildCaroucelSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaroucelSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CarouselSlider.builder(
          itemCount: posterlist.length,
          itemBuilder: (context, index, realindex) {
            final poster = posterlist[index];
            return Container(child: Image.asset(poster));
          },
          options: CarouselOptions(),
        ),
      ],
    );
  }
}
