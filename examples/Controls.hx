package;

import flixel.FlxG;

class Controls {
	// walk shitttts
	public var LEFT(get, never):Bool;
	public var RIGHT(get, never):Bool;
	public var UP(get, never):Bool;
	public var DOWN(get, never):Bool;
	public var LEFT_P(get, never):Bool;
	public var RIGHT_P(get, never):Bool;
	public var UP_P(get, never):Bool;
	public var DOWN_P(get, never):Bool;
	public var LEFT_R(get, never):Bool;
	public var RIGHT_R(get, never):Bool;
	public var UP_R(get, never):Bool;
	public var DOWN_R(get, never):Bool;

	public function get_LEFT() return justPressed('left');
	public function get_RIGHT() return justPressed('right');
	public function get_UP() return justPressed('up');
	public function get_DOWN() return justPressed('down');
	public function get_LEFT_P() return pressed('left');
	public function get_RIGHT_P() return pressed('right');
	public function get_UP_P() return pressed('up');
	public function get_DOWN_P() return pressed('down');
	public function get_LEFT_R() return justReleased('left');
	public function get_RIGHT_R() return justReleased('right');
	public function get_UP_R() return justReleased('up');
	public function get_DOWN_R() return justReleased('down');

	public function new() {}

	public static var mobileBinds:Map<String, Dynamic> = [
		'up'			=> 'mpad_up',
		'left'			=> 'mpad_left',
		'down'			=> 'mpad_down',
		'right'			=> ['mpad_right', 'mpad_a']
	];

	public function justPressed(keyName:String) {
		return justPressedKeys(mobilePadJustPressed(mobileBinds[keyName]) || joyStickJustPressed(keyName);
	}

	public function pressed(keyName:String) {
		return mobilePadPressed(mobileBinds[keyName]) || joyStickPressed(keyName);
	}
	
	public function released(keyName:String) {
		return mobilePadJustReleased(mobileBinds[keyName]) || joyStickJustReleased(keyName);
	}
	
	// KEYS
	public function justPressedKeys(keyses:Array<FlxKey>) {
		return FlxG.keys.anyJustPressed(keyses);
	}

	public function pressedKeys(keyses:Array<FlxKey>) {
		return FlxG.keys.anyPressed(keyses);
	}

	public function releasedKeys(keyses:Array<FlxKey>) {
		return FlxG.keys.anyJustReleased(keyses);
	}

	public var requestedInstance(get, default):Dynamic;
	public var mobileControls(get, never):Bool;

	private function joyStickPressed(key:String):Bool
	{
		if (key != null && requestedInstance.joyStick != null)
			if (requestedInstance.joyStick.pressed(key) == true)
				return true;

		return false;
	}

	private function joyStickJustPressed(key:String):Bool
	{
		if (key != null && requestedInstance.joyStick != null)
			if (requestedInstance.joyStick.justPressed(key) == true)
				return true;

		return false;
	}

	private function joyStickJustReleased(key:String):Bool
	{
		if (key != null && requestedInstance.joyStick != null)
			if (requestedInstance.joyStick.justReleased(key) == true)
				return true;

		return false;
	}

	private function mobilePadPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedInstance.mobilePad != null)
			if (requestedInstance.mobilePad.pressed(keys) == true)
				return true;

		return false;
	}

	private function mobilePadJustPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedInstance.mobilePad != null)
			if (requestedInstance.mobilePad.justPressed(keys) == true)
				return true;

		return false;
	}

	private function mobilePadJustReleased(keys:Array<String>):Bool
	{
		if (keys != null && requestedInstance.mobilePad != null)
			if (requestedInstance.mobilePad.justReleased(keys) == true)
				return true;

		return false;
	}

	@:noCompletion
	private function get_requestedInstance():Dynamic
	{
		return PlayState.instance;
	}
}