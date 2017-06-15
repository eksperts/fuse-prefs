A proof-of-concept Fuse wrapper for SharedPreferences / NSDefaults.

Basic Android and iOS implementation done, only supports storing strings for now.

See the included example for details.

Basic usage:

	var Prefs = require("FusePrefs");
	Prefs.write("key", "value");
	var key = Prefs.read("key");

As an alternative, consider using [fuse-usersettings](https://github.com/bolav/fuse-usersettings) library by Bolav
