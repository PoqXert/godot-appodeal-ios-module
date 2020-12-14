//
//  appodeal.mm
//
//
//  Created by Poq Xert on 09.06.2020.
//

#include "appodeal.h"
#import <Appodeal/Appodeal.h>
#include "helper.h"

#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif


static GodotAppodeal *godotAppodealInstance = NULL;

@interface GodotAppodealInterstitial: NSObject<AppodealInterstitialDelegate>

- (void)interstitialDidLoadAdIsPrecache:(BOOL)precache;
- (void)interstitialDidFailToLoadAd;
- (void)interstitialDidFailToPresent;
- (void)interstitialWillPresent;
- (void)interstitialDidDismiss;
- (void)interstitialDidClick;
- (void)interstitialDidExpired;

@end

@implementation GodotAppodealInterstitial

- (void)interstitialDidLoadAdIsPrecache:(BOOL)precache {
    godotAppodealInstance->emit_signal("interstitial_loaded", precache);
}
- (void)interstitialDidFailToLoadAd {
    godotAppodealInstance->emit_signal("interstitial_load_failed");
}
- (void)interstitialDidFailToPresent {
    godotAppodealInstance->emit_signal("interstitial_show_failed");
}
- (void)interstitialWillPresent {
    godotAppodealInstance->emit_signal("interstitial_shown");
}
- (void)interstitialDidDismiss {
    godotAppodealInstance->emit_signal("interstitial_closed");
}
- (void)interstitialDidClick {
    godotAppodealInstance->emit_signal("interstitial_clicked");
}
- (void)interstitialDidExpired {
    godotAppodealInstance->emit_signal("interstitial_expired");
}

@end

@interface GodotAppodealBanner: NSObject<AppodealBannerDelegate>

- (void)bannerDidLoadAdIsPrecache:(BOOL)precache;
- (void)bannerDidFailToLoadAd;
- (void)bannerDidExpired;
- (void)bannerDidClick;
- (void)bannerDidShow;

@end

@implementation GodotAppodealBanner

- (void)bannerDidLoadAdIsPrecache:(BOOL)precache {
    godotAppodealInstance->emit_signal("banner_loaded", precache);
}
- (void)bannerDidFailToLoadAd {
    godotAppodealInstance->emit_signal("banner_load_failed");
}
- (void)bannerDidExpired {
    godotAppodealInstance->emit_signal("banner_expired");
}
- (void)bannerDidClick {
    godotAppodealInstance->emit_signal("banner_clicked");
}
- (void)bannerDidShow {
    godotAppodealInstance->emit_signal("banner_shown");
}

@end

@interface GodotAppodealRewardedVideo: NSObject<AppodealRewardedVideoDelegate>

- (void)rewardedVideoDidLoadAdIsPrecache:(BOOL)precache;
- (void)rewardedVideoDidFailToLoadAd;
- (void)rewardedVideoDidFailToPresentWithError:(nonnull NSError *)error;
- (void)rewardedVideoDidPresent;
- (void)rewardedVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched;
- (void)rewardedVideoDidFinish:(float)rewardAmount name:(NSString *)rewardName;
- (void)rewardedVideoDidClick;
- (void)rewardedVideoDidExpired;

@end

@implementation GodotAppodealRewardedVideo

- (void)rewardedVideoDidLoadAdIsPrecache:(BOOL)precache {
    godotAppodealInstance->emit_signal("rewarded_video_loaded", precache);
}
- (void)rewardedVideoDidFailToLoadAd {
    godotAppodealInstance->emit_signal("rewarded_video_load_failed");
}
- (void)rewardedVideoDidFailToPresentWithError:(nonnull NSError *)error {
    godotAppodealInstance->emit_signal("rewarded_video_show_failed");
}
- (void)rewardedVideoDidPresent {
    godotAppodealInstance->emit_signal("rewarded_video_shown");
}
- (void)rewardedVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched {
    godotAppodealInstance->emit_signal("rewarded_video_closed", wasFullyWatched);
}
- (void)rewardedVideoDidFinish:(float)rewardAmount name:(NSString *)rewardName {
    godotAppodealInstance->emit_signal("rewarded_video_finished", rewardAmount, (String)nsobjectToVariant(rewardName));
}
- (void)rewardedVideoDidClick {
    godotAppodealInstance->emit_signal("rewarded_video_clicked");
}
- (void)rewardedVideoDidExpired {
    godotAppodealInstance->emit_signal("rewarded_video_expired");
}

@end

@interface GodotAppodealNonSkippableVideo: NSObject<AppodealNonSkippableVideoDelegate>

- (void)nonSkippableVideoDidLoadAdIsPrecache:(BOOL)precache;
- (void)nonSkippableVideoDidFailToLoadAd;
- (void)nonSkippableVideoDidExpired;
- (void)nonSkippableVideoDidPresent;
- (void)nonSkippableVideoDidFailToPresentWithError:(nonnull NSError *)error;
- (void)nonSkippableVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched;

@end

@implementation GodotAppodealNonSkippableVideo

- (void)nonSkippableVideoDidLoadAdIsPrecache:(BOOL)precache {
    godotAppodealInstance->emit_signal("non_skippable_video_loaded", precache);
}
- (void)nonSkippableVideoDidFailToLoadAd {
    godotAppodealInstance->emit_signal("non_skippable_video_load_failed");
}
- (void)nonSkippableVideoDidExpired {
    godotAppodealInstance->emit_signal("non_skippable_video_expired");
}
- (void)nonSkippableVideoDidPresent {
    godotAppodealInstance->emit_signal("non_skippable_video_shown");
}
- (void)nonSkippableVideoDidFailToPresentWithError:(nonnull NSError *)error {
    godotAppodealInstance->emit_signal("non_skippable_video_show_failed");
}
- (void)nonSkippableVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched {
    godotAppodealInstance->emit_signal("non_skippable_video_closed", wasFullyWatched);
}

@end

AppodealAdType getAdType(int value) {
    AppodealAdType type = 0;
    if((value&1) != 0) {
        type |= AppodealAdTypeInterstitial;
    }
    if((value&2) != 0) {
        type |= AppodealAdTypeBanner;
    }
    if((value&4) != 0) {
        type |= AppodealAdTypeNativeAd;
    }
    if((value&8) != 0) {
        type |= AppodealAdTypeRewardedVideo;
    }
    if((value&16) != 0) {
        type |= AppodealAdTypeNonSkippableVideo;
    }
    return type;
}

AppodealShowStyle getShowStyle(int value) {
    AppodealShowStyle style = 0;
    if((value&1) != 0) {
        style |= AppodealShowStyleInterstitial;
    }
    if((value&2) != 0) {
        style |= AppodealShowStyleBannerTop;
    }
    if((value&4) != 0) {
        style |= AppodealShowStyleBannerBottom;
    }
    if((value&8) != 0) {
        style |= AppodealShowStyleRewardedVideo;
    }
    if((value&16) != 0) {
        style |= AppodealShowStyleNonSkippableVideo;
    }
    return style;
}

GodotAppodeal::GodotAppodeal() {
    godotAppodealInstance = this;
}

GodotAppodeal::~GodotAppodeal() {
    
}

void GodotAppodeal::setTestingEnabled(bool testing) {
    [Appodeal setTestingEnabled:testing];
}

void GodotAppodeal::disableNetworks(Array networks) {
    if(networks.empty()) {
        return;
    }
    NSArray *arr = arrayToNSArray(networks);
    [Appodeal disableNetworks:(NSArray <NSString *>* _Nullable)arr];
}

void GodotAppodeal::disableNetworksForAdType(Array networks, int adType) {
    if(networks.empty() || adType == 0) {
        return;
    }
    NSArray *arr = arrayToNSArray(networks);
    [Appodeal disableNetworks:(NSArray <NSString *>* _Nullable)arr forAdType:getAdType(adType)];
}

void GodotAppodeal::disableNetwork(const String &network) {
    [Appodeal disableNetwork:(NSString *)variantToNSObject(network)];
}

void GodotAppodeal::disableNetworkForAdType(const String &network, int adType) {
    NSString *str = (NSString *)variantToNSObject(network);
    [Appodeal disableNetworkForAdType:getAdType(adType) name:str];
}

double GodotAppodeal::getPredictedEcpmForAdType(int adType) {
    return [Appodeal predictedEcpmForAdType:getAdType(adType)];
}

void GodotAppodeal::setLocationTracking(bool enabled) {
    [Appodeal setLocationTracking:enabled];
}

void GodotAppodeal::setAutocache(bool enabled, int types) {
    [Appodeal setAutocache:enabled types:getAdType(types)];
}

bool GodotAppodeal::isAutocacheEnabled(int adType) {
    return [Appodeal isAutocacheEnabled:getAdType(adType)];
}

void GodotAppodeal::initialize(const String &appKey, int types, bool consent) {
    [Appodeal setLogLevel:APDLogLevelDebug];
    AppodealAdType adTypes = getAdType(types);
    if((adTypes&AppodealAdTypeInterstitial) != 0) {
        [Appodeal setInterstitialDelegate:[[GodotAppodealInterstitial alloc] init]];
    }
    if((adTypes&AppodealAdTypeRewardedVideo) != 0) {
        [Appodeal setRewardedVideoDelegate:[[GodotAppodealRewardedVideo alloc] init]];
    }
    if((adTypes&AppodealAdTypeBanner) != 0) {
        [Appodeal setBannerDelegate:[[GodotAppodealBanner alloc] init]];
    }
    if((adTypes&AppodealAdTypeNonSkippableVideo) != 0) {
        [Appodeal setNonSkippableVideoDelegate:[[GodotAppodealNonSkippableVideo alloc] init]];
    }
    NSString *key = (NSString *)variantToNSObject(appKey);
    [Appodeal initializeWithApiKey:key types:adTypes hasConsent:consent];
}

bool GodotAppodeal::isInitializedForAdType(int adType) {
    return [Appodeal isInitalizedForAdType:getAdType(adType)];
}

void GodotAppodeal::setLogLevel(int logLevel) {
    [Appodeal setLogLevel:(APDLogLevel)logLevel];
}

void GodotAppodeal::setExtras(Dictionary extras) {
    [Appodeal setExtras:dictionaryToNSDictionary(extras)];
}

void GodotAppodeal::setChildDirectedTreatment(bool enabled) {
    [Appodeal setChildDirectedTreatment:enabled];
}

void GodotAppodeal::updateConsent(bool consent) {
    [Appodeal updateConsent:consent];
}

// User Settings

void GodotAppodeal::setUserId(const String &userId) {
    [Appodeal setUserId:(NSString *)variantToNSObject(userId)];
}

void GodotAppodeal::setUserAge(int age) {
    [Appodeal setUserAge:age];
}

void GodotAppodeal::setUserGender(int gender) {
    [Appodeal setUserGender:(AppodealUserGender)gender];
}

// AD

bool GodotAppodeal::canShow(int style) {
    return [Appodeal isReadyForShowWithStyle:getShowStyle(style)];
}

bool GodotAppodeal::canShowForPlacement(int adType, const String &placement) {
    NSString *strPlace = (NSString *)variantToNSObject(placement);
    return [Appodeal canShow:getAdType(adType) forPlacement:strPlace];
}

bool GodotAppodeal::showAd(int style) {
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [Appodeal showAd:getShowStyle(style) rootViewController:vc];
}

bool GodotAppodeal::showAdForPlacement(int style, const String &placement) {
    NSString *strPlace = (NSString *)variantToNSObject(placement);
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [Appodeal showAd:getShowStyle(style) forPlacement:strPlace rootViewController:vc];
}

void GodotAppodeal::cacheAd(int adType) {
    [Appodeal cacheAd:getAdType(adType)];
}

bool GodotAppodeal::isPrecacheAd(int adType) {
    return [Appodeal isPrecacheAd:getAdType(adType)];
}

void GodotAppodeal::setSegmentFilter(Dictionary segmentFilter) {
    [Appodeal setSegmentFilter:dictionaryToNSDictionary(segmentFilter)];
}

void GodotAppodeal::setPreferredBannerAdSize(int sizeType) {
    APDUnitSize size = kAppodealUnitSize_320x50;
    if(sizeType == 1) {
        size = kAppodealUnitSize_728x90;
    }
    [Appodeal setPreferredBannerAdSize:size];
}

void GodotAppodeal::hideBanner() {
    [Appodeal hideBanner];
}

void GodotAppodeal::setSmartBannersEnabled(bool enabled) {
    [Appodeal setSmartBannersEnabled:enabled];
}

void GodotAppodeal::setBannerAnimationEnabled(bool enabled) {
    [Appodeal setBannerAnimationEnabled:enabled];
}

Dictionary GodotAppodeal::getRewardForPlacement(const String &placement) {
    id<APDReward> reward = [Appodeal rewardForPlacement:(NSString *)variantToNSObject(placement)];
    Dictionary res = Dictionary();
    res["currency"] = nsobjectToVariant([reward currencyName]);
    res["amount"] = [reward amount];
    return res;
}

void GodotAppodeal::trackInAppPurchase(int val, const String &currency) {
    NSString *strCurrency = (NSString *)variantToNSObject(currency);
    [Appodeal trackInAppPurchase:[NSNumber numberWithInt:val] currency:strCurrency];
}

void GodotAppodeal::requestTrackingAuthorization() {
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    if(@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            godotAppodealInstance->emit_signal("tracking_request_completed", (int)status);
        }];
    } else {
        godotAppodealInstance->emit_signal("tracking_request_completed", 0);
    }
#else
    godotAppodealInstance->emit_signal("tracking_request_completed", 0);
#endif
}

int GodotAppodeal::getTrackingAuthorizationStatus() {
    int status = 0;
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    if(@available(iOS 14, *)) {
        status = (int)[ATTrackingManager trackingAuthorizationStatus];
    }
#endif
    return status;
}

void GodotAppodeal::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setTestingEnabled", "testing"), &GodotAppodeal::setTestingEnabled);
    ClassDB::bind_method(D_METHOD("disableNetworks", "networks"), &GodotAppodeal::disableNetworks);
    ClassDB::bind_method(D_METHOD("disableNetworksForAdType", "networks", "type"), &GodotAppodeal::disableNetworksForAdType);
    ClassDB::bind_method(D_METHOD("disableNetwork", "network"), &GodotAppodeal::disableNetwork);
    ClassDB::bind_method(D_METHOD("disableNetworkForAdType", "network", "type"), &GodotAppodeal::disableNetworkForAdType);
    ClassDB::bind_method(D_METHOD("getPredictedEcpmForAdType", "type"), &GodotAppodeal::getPredictedEcpmForAdType);
    ClassDB::bind_method(D_METHOD("setLocationTracking", "enabled"), &GodotAppodeal::setLocationTracking);
    ClassDB::bind_method(D_METHOD("setAutocache", "enable", "types"), &GodotAppodeal::setAutocache);
    ClassDB::bind_method(D_METHOD("isAutocacheEnabled", "type"), &GodotAppodeal::isAutocacheEnabled);
    ClassDB::bind_method(D_METHOD("initialize", "app_key", "types", "consent"), &GodotAppodeal::initialize);
    ClassDB::bind_method(D_METHOD("isInitializedForAdType", "type"), &GodotAppodeal::isInitializedForAdType);
    ClassDB::bind_method(D_METHOD("setLogLevel", "level"), &GodotAppodeal::setLogLevel);
    ClassDB::bind_method(D_METHOD("setExtras", "extras"), &GodotAppodeal::setExtras);
    ClassDB::bind_method(D_METHOD("setChildDirectedTreatment", "enabled"), &GodotAppodeal::setChildDirectedTreatment);
    ClassDB::bind_method(D_METHOD("updateConsent", "consent"), &GodotAppodeal::updateConsent);
    ClassDB::bind_method(D_METHOD("setUserId", "user_id"), &GodotAppodeal::setUserId);
    ClassDB::bind_method(D_METHOD("setUserAge", "age"), &GodotAppodeal::setUserAge);
    ClassDB::bind_method(D_METHOD("setUserGender", "gender"), &GodotAppodeal::setUserGender);
    ClassDB::bind_method(D_METHOD("canShow", "style"), &GodotAppodeal::canShow);
    ClassDB::bind_method(D_METHOD("canShowForPlacement", "type", "placement"), &GodotAppodeal::canShowForPlacement);
    ClassDB::bind_method(D_METHOD("showAd", "style"), &GodotAppodeal::showAd);
    ClassDB::bind_method(D_METHOD("showAdForPlacement", "style", "placement"), &GodotAppodeal::showAdForPlacement);
    ClassDB::bind_method(D_METHOD("cacheAd", "type"), &GodotAppodeal::cacheAd);
    ClassDB::bind_method(D_METHOD("isPrecacheAd", "type"), &GodotAppodeal::isPrecacheAd);
    ClassDB::bind_method(D_METHOD("setSegmentFilter", "filter"), &GodotAppodeal::setSegmentFilter);
    ClassDB::bind_method(D_METHOD("setPreferredBannerAdSize", "size"), &GodotAppodeal::setPreferredBannerAdSize);
    ClassDB::bind_method(D_METHOD("hideBanner"), &GodotAppodeal::hideBanner);
    ClassDB::bind_method(D_METHOD("setSmartBannersEnabled", "enabled"), &GodotAppodeal::setSmartBannersEnabled);
    ClassDB::bind_method(D_METHOD("setBannerAnimationEnabled", "enabled"), &GodotAppodeal::setBannerAnimationEnabled);
    ClassDB::bind_method(D_METHOD("getRewardForPlacement", "placement"), &GodotAppodeal::getRewardForPlacement);
    ClassDB::bind_method(D_METHOD("trackInAppPurchase", "value", "currency"), &GodotAppodeal::trackInAppPurchase);
    ClassDB::bind_method(D_METHOD("requestTrackingAuthorization"), &GodotAppodeal::requestTrackingAuthorization);
    ClassDB::bind_method(D_METHOD("getTrackingAuthorizationStatus"), &GodotAppodeal::getTrackingAuthorizationStatus);
    // Interstitial
    ADD_SIGNAL(MethodInfo("interstitial_loaded"));
    ADD_SIGNAL(MethodInfo("interstitial_load_failed"));
    ADD_SIGNAL(MethodInfo("interstitial_show_failed"));
    ADD_SIGNAL(MethodInfo("interstitial_shown"));
    ADD_SIGNAL(MethodInfo("interstitial_closed"));
    ADD_SIGNAL(MethodInfo("interstitial_clicked"));
    ADD_SIGNAL(MethodInfo("interstitial_expired"));
    // Banner
    ADD_SIGNAL(MethodInfo("banner_loaded"));
    ADD_SIGNAL(MethodInfo("banner_load_failed"));
    ADD_SIGNAL(MethodInfo("banner_expired"));
    ADD_SIGNAL(MethodInfo("banner_clicked"));
    ADD_SIGNAL(MethodInfo("banner_shown"));
    // Rewarded Video
    ADD_SIGNAL(MethodInfo("rewarded_video_loaded"));
    ADD_SIGNAL(MethodInfo("rewarded_video_load_failed"));
    ADD_SIGNAL(MethodInfo("rewarded_video_show_failed"));
    ADD_SIGNAL(MethodInfo("rewarded_video_shown"));
    ADD_SIGNAL(MethodInfo("rewarded_video_closed"));
    ADD_SIGNAL(MethodInfo("rewarded_video_finished"));
    ADD_SIGNAL(MethodInfo("rewarded_video_clicked"));
    ADD_SIGNAL(MethodInfo("rewarded_video_expired"));
    //Non Skippable Video
    ADD_SIGNAL(MethodInfo("non_skippable_video_loaded"));
    ADD_SIGNAL(MethodInfo("non_skippable_video_load_failed"));
    ADD_SIGNAL(MethodInfo("non_skippable_video_expired"));
    ADD_SIGNAL(MethodInfo("non_skippable_video_shown"));
    ADD_SIGNAL(MethodInfo("non_skippable_video_show_failed"));
    ADD_SIGNAL(MethodInfo("non_skippable_video_closed"));
    //Tracking
    ADD_SIGNAL(MethodInfo("tracking_request_completed"));
}
