About
=====

Copyright 2011, Google Inc. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Features
========

The is the Ad Catalog for iOS.  The catalog was written and tested with the
Google Admob Ads SDK version 6.1.4, and supports iOS 5.0 or higher.

The catalog provides:
* Banners example featuring all of the banner sizes supported  by the AdMob
  SDK.
* Four interstitial examples:
  1. Basic - an interstitial ads loads and displays when ready.
  2. Game Levels - an interstitial is displayed before moving to level 2.
  3. Video Preroll - an interstitial is displayed prior to viewing a video.
  4. Splash - if this option is set, an interstitial will be displayed the next
     time the app loads.
* Four advanced layout integration examples:
  1. OpenGL - a banner ad loads beneath an OpenGL view.
  2. ScrollView - a banner ad loads beneath a ScrollView.
  3. TabbedView - a singleton banner ad is displayed for multiple view
     controllers through a TabBar interface.
  4. TableView - a banner ad is loaded inside the cells of a TableView.

Requirements:
=============
* Xcode 4.2 or higher
* iOS SDK 5.0 or higher
* Google AdMob Ads SDK for iOS
* AdMob publisher ID

Getting started with the Ad Catalog with Xcode:
===============================================
1. Launch Xcode, select File > Open, navigate to AdCatalog.xcodeproj, select it
   and click Open.
2. Add the Google AdMob Ads SDK to your project.
   ** Download the most recent Google AdMob Ads SDK for iOS, unzip it.
   ** Right-Click the GoogleAdMobAdsSDK folder in the Project Navigator pane.
   ** Select 'Add Files To "AdCatalog"...'
   ** Navigate to the directory you previously unzipped the Google AdMob Ads SDK
     into, select all of the files there, check "Copy items into destination
     group's folder (if needed)", and click 'Add'.
3. Insert your AdMob publisher ID into the application.
   ** Open SampleConstants.h, replace the strings,
     'REPLACE_WITH_YOUR_ADMOB_AD_UNIT_ID', with your publisher id.

Click the Run button and enjoy!
