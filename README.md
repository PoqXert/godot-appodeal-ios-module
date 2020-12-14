# godot-appodeal-ios-module
Godot Appodeal iOS Module

API Compatible with [Godot Appodeal Android plugin](https://github.com/PoqXert/godot-appodeal-android-plugin) (exclude [platform specific](#ios-only)).

## Setup

1. [Get Godot source](https://docs.godotengine.org/en/stable/development/compiling/getting_source.html).
2. Clone this repository to ``godot/modules`` folder.
3. Add ``Appodeal.framework`` to ``lib`` subfolder.
4. [Compile for iOS](https://docs.godotengine.org/en/stable/development/compiling/compiling_for_ios.html).
5. After export Godot-project to XCode-project, replace ``GameName.a`` in XCode-project to file got on previous step.
6. Change ``info.plist`` with [Prepare your app](https://wiki.appodeal.com/en/ios/2-6-5-ios-sdk-integration-guide) section.
7. Add Appodeal framework (see [Choose your integration type](https://wiki.appodeal.com/en/ios/2-6-5-ios-sdk-integration-guide) section).
8. Create ``Empty.swift`` in XCode-project and accept ``Create Bridging Header``

## Usage

To use the ``GodotAppodeal`` API you first have to get the ``GodotAppodeal`` singleton:
```gdscript
var _appodeal

func _ready():
  if Engine.has_singleton("GodotAppodeal"):
    _appodeal = Engine.get_singeton("GodotAppodeal")
```
### Initialization

To initialization Appodeal SDK call ``initialize`` method:
```gdscript
func initialize(app_key: String, ad_types: int, consent: bool) -> void
```
For example:
```gdscript
_appodeal.initialize("YOU_ANDROID_APPODEAL_APP_KEY", 8, false)
```
### Ad Types

The adTypes parameter in the code is responsible for the ad formats you are going to implement into your app.
You can define enum for it:
```gdscript
enum AdType {
  INTERSTITIAL = 1,
  BANNER = 2,
  NATIVE = 4,
  REWARDED_VIDEO = 8,
  NON_SKIPPABLE_VIDEO = 16,
}
```
Ad types can be combined using "|" operator.

### Show Styles

The showStyles parameter use for show ad.
You can define enum for it:
```gdscript
enum ShowStyle {
  INTERSTITIAL = 1,
  BANNER_TOP = 2,
  BANNER_BOTTOM = 4,
  REWARDED_VIDEO = 8,
  NON_SKIPPABLE_VIDEO = 16,
}
```

### Methods

#### Initialization

```gdscript
# Initialization Appodeal SDK
func initialize(app_key: String, ad_types: int, consent: bool) -> void
```
```gdscript
# Checking initialization for ad type
func isInitializedForAdType(ad_type: int) -> bool
```

#### Display ad

```gdscript
# Display ad
func showAd(show_style: int) -> bool
```
```gdscript
# Display ad for specified placement
func showAdForPlacement(show_style: int, placement: String) -> bool
```
```gdscript
# Check ability to display ad
func canShow(show_style: int) -> bool
```
```gdscript
# Check ability to display ad for specified placement
func canShowForPlacement(ad_type: int, placement: String) -> bool
```
```gdscript
# Hide banner
func hideBanner()
```

#### Configure SDK

```gdscript
# Enable/Disable testing
func setTestingEnabled(enabled: bool) -> void
```
```gdscript
# Disable specified networks
func disableNetworks(networks: Array) -> void
```
```gdscript
# Disable specified networks for ad type
func disableNetworksForAdType(networks: Array, ad_type: int) -> void
```
```gdscript
# Disable specified network
func disableNetwork(network: String) -> void
```
```gdscript
# Disable specified network for ad type
func disableNetworkForAdType(network: String, ad_type: int) -> void
```
```gdscript
# Disable location tracking.
func setLocationTracking(enabled: bool) -> void
```
```gdscript
# Disable data collection for kids apps
func setChildDirectedTreatment(for_kids: bool) -> void
```
```gdscript
# Change GDPR consent status
func updateConsent(consent: bool) -> void
```
```gdscript
# Set logging
func setLogLevel(log_level: int) -> void
```
```gdscript
# Send extra data
func setExtras(data: Dictionary) -> void
```
```gdscript
# Set segment filter
func setSegmentFilter(filter: Dictionary) -> void
```
```gdscript
# Enable/Disable smart banners
func setSmartBannersEnabled(enabled: bool) -> void
```
```gdscript
# Enable/Disable banner animation
func setBannerAnimationEnabled(enabled: bool) -> void
```
```gdscript
# Set banner size
# Set 728x90 if 1, otherwise 320x50
func setPreferredBannerAdSize(size: int) -> void
```

#### Caching

```gdscript
# Enable/Disable autocache
func setAutocache(enabled: bool, ad_type: int) -> void
```
```gdscript
# Check autocache enabled
func isAutocacheEnabled(ad_type: int) -> bool
```
```gdscript
# Check cache
func isPrecacheAd(ad_type: int) -> bool
```
```gdscript
# Cache
func cacheAd(ad_type: int) -> void
```

#### User Settings

```gdscript
# Set user ID for S2S callbacks
func setUserId(user_id: String) -> void
```
```gdscript
# Set user age
func setUserAge(age: int) -> void
```
```gdscript
# Set user gender
func setUserGender(gender: int) -> void
```

#### Other

```gdscript
# Get predicted eCPM for ad type
func getPredictedEcpmForAdType(ad_type: int) -> float
```
```gdscript
# Get Reward info for placement
func getRewardForPlacement(placement: String) -> Dictionary
```
Reward Dictionary have ``currency`` and ``amount`` keys.
```gdscript
# Track in-app purchases
func trackInAppPurchase(amount: float, currency: String) -> void
```

## Signals

### Interstitial

```gdscript
# Emit when interstitial is loaded
signal interstitial_loaded(precached: bool)
```
```gdscript
# Emit when interstitial failed to load
signal interstitial_load_failed()
```
```gdscript
# Emit when interstitial is shown
signal interstitial_shown()
```
```gdscript
# Emit when interstitial show failed
signal interstitial_show_failed()
```
```gdscript
# Emit when interstitial is clicked
signal interstitial_clicked()
```
```gdscript
# Emit when interstitial is closed
signal interstitial_closed()
```
```gdscript
# Emit when interstitial is expired
signal interstitial_expired()
```

### Banner

```gdscript
# Emit when banner is loaded
signal banner_loaded(precached: bool)
```
```gdscript
# Emit when banner failed to load
signal banner_load_failed()
```
```gdscript
# Emit when banner is shown
signal banner_shown()
```
```gdscript
# Emit when banner show failed
signal banner_show_failed()
```
```gdscript
# Emit when banner is clicked
signal banner_clicked()
```
```gdscript
# Emit when banner is expired
signal banner_expired()
```

### Rewarded Video

```gdscript
# Emit when rewarded video is loaded
signal rewarded_video_loaded(precache: bool)
```
```gdscript
# Emit when rewarded video failed to load
signal rewarded_video_load_failed()
```
```gdscript
# Emit when rewarded video is shown
signal rewarded_video_shown()
```
```gdscript
# Emit when rewarded video show failed
signal rewarded_video_show_failed()
```
```gdscript
# Emit when rewarded video is viewed until the end
signal rewarded_video_finished(amount: float, currency: String)
```
```gdscript
# Emit when rewarded video is closed
signal rewarded_video_closed(finished: bool)
```
```gdscript
# Emit when rewarded video is expired
signal rewarded_video_expired()
```
```gdscript
# Emit when rewarded video is clicked
signal rewarded_video_clicked()
```

### Non-Skippable Video

```gdscript
# Emit when non-skippable video is loaded
signal non_skippable_video_loaded(precache: bool)
```
```gdscript
# Emit when non-skippable video failed to load
signal non_skippable_video_load_failed()
```
```gdscript
# Emit when non-skippable video is shown
signal non_skippable_video_shown()
```
```gdscript
# Emit when non-skippable video show failed
signal non_skippable_video_show_failed()
```
```gdscript
# Emit when non-skippable video is viewed until the end
signal non_skippable_video_finished()
```
```gdscript
# Emit when non-skippable video is closed
signal non_skippable_video_closed(finished: bool)
```
```gdscript
# Emit when non-skippable video is expired
signal non_skippable_video_expired()
```

## iOS-only
This methods and signals available on iOS only.

Configure info.plist by [iOS 14 Network Support](https://wiki.appodeal.com/en/ios/ios-14-network-support) section
### Tracking Authorization Status
```gdscript
enum TrackingAuthorizationStatus {
  NOT_DETERMINED = 0,
  RESTRICTED = 1,
  DENIED = 2,
  AUTHORIZED = 3,
}
```

### Methods
```gdscript
# Request access to IDFA
func requestTrackingAuthorization() -> void
```
```gdscript
# Get tracking authorization status
func getTrackingAuthorizationStatus() -> int
```
### Signals
```gdscript
# Emit when request tracking authorization completed
signal tracking_request_completed(status: int)
```
