import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_app/model/google_ads_manager.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key, required this.action}) : super(key: key);
  final Function action;

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  GoogleAdsManager googleAdsManager = GoogleAdsManager();
  BannerAd? _bannerAd;

  @override
  void initState() {
    googleAdsManager.init();
    BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',
      request: const AdRequest(
        keywords: <String>['foo', 'bar'],
        contentUrl: 'http://foo.com/bar.html',
        nonPersonalizedAds: true,
      ),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  void dispose() {
    googleAdsManager.dispose();
    // _bannerAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(159, 161, 184, 1), size: 25),
        backgroundColor: const Color.fromRGBO(250, 250, 255, 1),
        title: Text(
          "ads".tr,
          style: const TextStyle(
              color: Color.fromRGBO(156, 166, 201, 1),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            widget.action();
          },
          icon: const Icon(FontAwesomeIcons.bars),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              googleAdsManager.showRewardedAd();
            },
            child: const Text("test"),
          ),
          if (_bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
        ],
      ),
    );
  }
}
