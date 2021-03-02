import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  bool isRewardedVideoComplete = false;

  @override
  void initState() {
    FacebookAudienceNetwork.init(
      testingId: "55afa8d9-ff1d-4271-b46a-7f877515e355",
    );
    _loadInterstitialAd();
    _loadRewardedVideoAd();

    super.initState();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value['invalidated'] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print('Interstitial Ad not loaded');
  }

  void _loadRewardedVideoAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "YOUR_PLACEMENT_ID",
      listener: (result, value) {
        print("Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
          isRewardedVideoComplete = true;
        if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
            (value == true || value["invalidated"] == true)) {
          _isRewardedAdLoaded = false;
          _loadRewardedVideoAd();
        }
      },
    );
  }

  _showRewardedAd() {
    if (_isRewardedAdLoaded == true)
      FacebookRewardedVideoAd.showRewardedVideoAd(delay: 10);
    else
      print("Rewarded Ad not yet loaded!");
  }

  Widget _currentAd = SizedBox(
    height: 0.0,
    width: 0.0,
  );

  _showBannerAd() {
    setState(() {
      _currentAd = FacebookBannerAd(listener: (result, value) {
        print('Banner Ad: $result --> $value');
      });
    });
  }

  _showNativeBannerAd() {
    setState(() {
      _currentAd = FacebookNativeAd(
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_100,
        width: double.infinity,
        backgroundColor: Colors.blue,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
      );
    });
  }

  _showNativeAd() {
    setState(() {
      _currentAd = FacebookNativeAd(
        adType: NativeAdType.NATIVE_AD_VERTICAL,
        width: double.infinity,
        height: 200,
        backgroundColor: Colors.blue,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        keepExpandedWhileLoading: true,
        expandAnimationDuraion: 1000,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Facebook'),
              Text(
                'Ads',
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: _currentAd,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _button(
                        onPressed: () => _showBannerAd(),
                        buttonText: 'Banner Ad'),
                    SizedBox(
                      height: 20,
                    ),
                    _button(
                        onPressed: () => _showInterstitialAd(),
                        buttonText: 'Interstitial Ad'),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    _button(
                        onPressed: () => _showNativeAd(),
                        buttonText: 'Native Ad'),
                    SizedBox(
                      height: 20,
                    ),
                    _button(
                        onPressed: () => _showRewardedAd(),
                        buttonText: 'Rewarded Ad'),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _button(
                onPressed: () => _showNativeBannerAd(),
                buttonText: 'NativeBanner'),
          ],
        ));
  }
}

Widget _button({Function onPressed, String buttonText}) {
  return SizedBox(
    height: 40,
    width: 120,
    child: FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.blue,
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
