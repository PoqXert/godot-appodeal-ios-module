//
//  appodeal.h
//  
//
//  Created by Poq Xert on 09.06.2020.
//

#ifndef appodeal_h
#define appodeal_h

#include "core/object.h"
#include "core/array.h"
#include "core/dictionary.h"

class GodotAppodeal : public Object {
    GDCLASS(GodotAppodeal, Object);

    static void _bind_methods();

public:
    GodotAppodeal();
    ~GodotAppodeal();
    
    
    // Base
    void setTestingEnabled(bool testing);
    void disableNetworks(Array networks);
    void disableNetworksForAdType(Array networks, int adType);
    void disableNetwork(const String &network);
    void disableNetworkForAdType(const String &network, int adType);
    double getPredictedEcpmForAdType(int adType);
    void setLocationTracking(bool enabled);
    void setAutocache(bool enable, int types);
    bool isAutocacheEnabled(int adType);
    void initialize(const String &appKey, int types, bool consent);
    bool isInitializedForAdType(int adType);
    void setLogLevel(int logLevel);
    void setExtras(Dictionary extras);
    void setChildDirectedTreatment(bool enabled);
    void updateConsent(bool consent);
    // User Settings
    void setUserId(const String &userId);
    void setUserAge(int age);
    void setUserGender(int gender);
    // AD
    bool canShow(int style);
    bool canShowForPlacement(int adType, const String &placement);
    bool showAd(int style);
    bool showAdForPlacement(int style, const String &placement);
    void cacheAd(int adType);
    //bool isReadyForShow(int adType);
    bool isPrecacheAd(int adType);
    // Segments
    void setSegmentFilter(Dictionary segmentFilter);
    // Banner
    void setPreferredBannerAdSize(int sizeType);
    void hideBanner();
    void setSmartBannersEnabled(bool enabled);
    void setBannerAnimationEnabled(bool enabled);
    
    // Rewarded Video
    Dictionary getRewardForPlacement(const String &placement);
    
    void trackInAppPurchase(int val, const String &currency);
    
    void requestTrackingAuthorization();
    int getTrackingAuthorizationStatus();
};

#endif /* appodeal_h */
