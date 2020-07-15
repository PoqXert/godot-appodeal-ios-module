#include "register_types.h"
#include "ios/src/appodeal.h"
#include "core/class_db.h"
#include "core/engine.h"

void register_appodeal_types() {
    Engine::get_singleton()->add_singleton(Engine::Singleton("GodotAppodeal", memnew(GodotAppodeal)));
}

void unregister_appodeal_types() {
    
}
