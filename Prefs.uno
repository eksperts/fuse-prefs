using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Scripting;

[extern(Android) ForeignInclude(Language.Java, "android.content.SharedPreferences", "android.content.Context", "android.preference.PreferenceManager")]

[UXGlobalModule]
public sealed class FusePrefs : NativeModule {

    static readonly FusePrefs _instance;
    public FusePrefs()
    {
        if (_instance != null) return;
        Uno.UX.Resource.SetGlobalKey(_instance = this, "FusePrefs");
        AddMember(new NativeFunction("write", Write));
        AddMember(new NativeFunction("read", Read));
    }

    static object Write(Fuse.Scripting.Context context, object[] args)
    {
        if (args.Length == 2)
        {
            var key = args[0] as string;
            var val = args[1] as string;
            if (key != null && val != null)
            {
                return WriteImpl(key, val);
            }
        }
        return null;
    }

    private static extern(!mobile) bool WriteImpl(string key, string val)
    {
        return false;
    }

    [Foreign(Language.Java)]
    private static extern(Android) bool WriteImpl(string key, string val)
    @{
        Context context = com.fuse.Activity.getRootActivity();
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(key, val);
        editor.commit();
        return true;
    @}

    [Foreign(Language.ObjC)]
    private static extern(iOS) bool WriteImpl(string key, string val)
    @{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:val forKey:key];
        [prefs synchronize];
        return true;
    @}


    static object Read(Fuse.Scripting.Context context, object[] args)
    {
        if (args.Length == 1)
        {
            var key = args[0] as string;
            if (key != null)
            {
                return ReadImpl(key);
            }
        }
        return null;
    }

    private static extern(!mobile) string ReadImpl(string key)
    {
        return false;
    }

    [Foreign(Language.Java)]
    private static extern(Android) string ReadImpl(string key)
    @{
        Context context = com.fuse.Activity.getRootActivity();
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        String val = preferences.getString(key, "");
        return val;
    @}

    [Foreign(Language.ObjC)]
    private static extern(iOS) string ReadImpl(string key)
    @{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *val = [prefs stringForKey:key];
        return val;
    @}

}
