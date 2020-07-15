def can_build(env, platform):
    if platform == "iphone":
        return True
    return False

def configure(env):
    if env['platform'] == "iphone":
        env.Append(FRAMEWORKPATH=['#modules/appodeal/ios/lib'])
        env.Append(CPPPATH=['#core'])
        env.Append(LINKFLAGS=['-ObjC', '-framework', 'Appodeal'])
