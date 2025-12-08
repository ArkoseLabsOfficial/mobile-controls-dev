# Mobile Controls

---

a library made to make the process of adding a mobile controls way easier.

---

- [Setup](docs/SETUP.md)
- [Features](docs/FEATURES.md)
- [Usage](#usage)

---

# USAGE

Creating & Handling a mobile controls should be fairly easy and very much self-explanatory

- NOTE: MobilePad & Hitbox Using the same base, so their handling is almost same

```haxe
// *
// * src/Main.hx
// *

import mobile.MobileConfig;

class Main {
	static function main():Void {
		MobileConfig.init('MobileControls', 'ArkoseLabs/HaxeTale', 'mobile/',
			[
				'MobilePad/DPadModes',
				'MobilePad/ActionModes',
				'Hitbox/HitboxModes',
			], [
				DPAD,
				ACTION,
				HITBOX
			]
		);
	}
}

// *
// * src/PlayState.hx
// *

import mobile.MobileControlManager;
class PlayState extends FlxState {
	var manager:MobileControlManager;
	override function create() {
		manager = new MobileControlManager(this);
		/* MobilePad */
		manager.addMobilePad('Test', 'Test');
		manager.addMobilePadCamera();

		/* Hitbox */
		manager.addHitbox('Test');
		manager.addHitboxCamera();

		/* JoyStick */
		manager.addJoyStick(0, 0, 0, 0.25, 0.7);
		manager.addJoyStickCamera();
	}
	override function update(elapsed:Float) {
		if (manager.mobilePad.getButtonFromName('buttonA').justPressed) {
			trace('hello from buttonA');
		}

		if (manager.hitbox.getButtonFromName('buttonUp').justPressed) {
			trace('hello from buttonUp');
		}

		if (manager.joyStick.joyStickPressed('up')) {
			trace('hello from joyStick up');
		}
	}
}

// *
// * A Example (Probably This Class Won't Work)
// * src/Controls.hx
// *

import flixel.FlxG;

class Controls {
	public var requestedInstance(get, default):Dynamic;
	public var LEFT:Bool = false;
	public var RIGHT:Bool = false;
	public var UP:Bool = false;
	public var DOWN:Bool = false;
	public var LEFT_P:Bool = false;
	public var RIGHT_P:Bool = false;
	public var UP_P:Bool = false;
	public var DOWN_P:Bool = false;
	public var LEFT_R:Bool = false;
	public var RIGHT_R:Bool = false;
	public var UP_R:Bool = false;
	public var DOWN_R:Bool = false;
	public static var mobileBinds:Map<String, Array<String>> = [
		'up'			=> ['buttonUp'],
		'left'			=> ['buttonLeft'],
		'down'			=> ['buttonDown'],
		'right'			=> ['buttonRight']
	];

	public function new() {}
	public function initInput() {
		LEFT = justPressed('left');
		RIGHT = justPressed('right');
		UP = justPressed('up');
		DOWN = justPressed('down');
		LEFT_P = pressed('left');
		RIGHT_P = pressed('right');
		UP_P = pressed('up');
		DOWN_P = pressed('down');
		LEFT_R = released('left');
		RIGHT_R = released('right');
		UP_R = released('up');
		DOWN_R = released('down');
	}
	public function justPressed(keyName:String) {
		return mobilePadJustPressed(mobileBinds[keyName]) || joyStickJustPressed(keyName);
	}
	public function pressed(keyName:String) {
		return mobilePadPressed(mobileBinds[keyName]) || joyStickPressed(keyName);
	}
	public function released(keyName:String) {
		return mobilePadJustReleased(mobileBinds[keyName]) || joyStickJustReleased(keyName);
	}
	private function joyStickPressed(key:String):Bool
	{
		if (key != null && requestedInstance.manager.joyStick != null)
			if (requestedInstance.manager.joyStick.joyStickPressed(key) == true)
				return true;
		return false;
	}
	private function joyStickJustPressed(key:String):Bool
	{
		if (key != null && requestedInstance.manager.joyStick != null)
			if (requestedInstance.manager.joyStick.joyStickJustPressed(key) == true)
				return true;
		return false;
	}
	private function joyStickJustReleased(key:String):Bool
	{
		if (key != null && requestedInstance.manager.joyStick != null)
			if (requestedInstance.manager.joyStick.joyStickJustReleased(key) == true)
				return true;
		return false;
	}
	private function mobilePadPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedInstance.manager.mobilePad != null)
			if (requestedInstance.manager.mobilePad.buttonPressed(keys) == true)
				return true;
		return false;
	}
	private function mobilePadJustPressed(keys:Array<String>):Bool
	{
		if (keys != null && requestedInstance.manager.mobilePad != null)
			if (requestedInstance.manager.mobilePad.buttonJustPressed(keys) == true)
				return true;
		return false;
	}
	private function mobilePadJustReleased(keys:Array<String>):Bool
	{
		if (keys != null && requestedInstance.manager.mobilePad != null)
			if (requestedInstance.manager.mobilePad.buttonJustReleased(keys) == true)
				return true;

		return false;
	}
	@:noCompletion
	private function get_requestedInstance():Dynamic
	{
		return PlayState.instance;
	}
}

```
