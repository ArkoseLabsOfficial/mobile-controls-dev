package mobile;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxDestroyUtil;
import mobile.MobilePad;
import mobile.Hitbox;
import mobile.JoyStick;

/**
 * A simple mobile manager for who doesn't want to create these manually
 * if you're making big projects or have a experience to how controls work, create the controls yourself
 */
class MobileControlManager {
	public var currentState:Dynamic;

	public var mobilePad:MobilePad;
	public var mobilePadCam:FlxCamera;
	public var joyStickCam:FlxCamera;
	public var joyStick:JoyStick;
	public var legacyJoyStickCam:FlxCamera;
	public var legacyJoyStick:JoyStickLegacy;
	public var hitboxCam:FlxCamera;
	public var hitbox:Hitbox;

	public function new(state:Dynamic):Void
	{
		this.currentState = state;
		trace("MobileControlManager initialized.");
	}

	public function addMobilePad(DPad:String, Action:String, ?Alpha:Float = 0.7, ?DisableCreation:Bool):Void
	{
		if (mobilePad != null) removeMobilePad();
		mobilePad = new MobilePad(DPad, Action, Alpha, DisableCreation);
		currentState.add(mobilePad);
	}

	public function removeMobilePad():Void
	{
		if (mobilePad != null)
		{
			currentState.remove(mobilePad);
			mobilePad = FlxDestroyUtil.destroy(mobilePad);
		}

		if(mobilePadCam != null)
		{
			FlxG.cameras.remove(mobilePadCam);
			mobilePadCam = FlxDestroyUtil.destroy(mobilePadCam);
		}
	}

	public function addMobilePadCamera():Void
	{
		mobilePadCam = new FlxCamera();
		mobilePadCam.bgColor.alpha = 0;
		FlxG.cameras.add(mobilePadCam, false);
		mobilePad.cameras = [mobilePadCam];
	}

	public function addHitbox(Mode:String, ?Alpha:Float = 0.7, ?DisableCreation:Bool = false):Void
	{
		if (hitbox != null) removeHitbox();
		hitbox = new Hitbox(Mode, Alpha, DisableCreation);
		currentState.add(hitbox);
	}

	public function removeHitbox():Void
	{
		if (hitbox != null)
		{
			currentState.remove(hitbox);
			hitbox = FlxDestroyUtil.destroy(hitbox);
		}

		if(hitboxCam != null)
		{
			FlxG.cameras.remove(hitboxCam);
			hitboxCam = FlxDestroyUtil.destroy(hitboxCam);
		}
	}

	public function addHitboxCamera():Void
	{
		hitboxCam = new FlxCamera();
		hitboxCam.bgColor.alpha = 0;
		FlxG.cameras.add(hitboxCam, false);
		hitbox.cameras = [hitboxCam];
	}

	public function addJoyStick(x:Float = 0, y:Float = 0, ?graphic:String, ?onMove:Float->Float->Float->String->Void):Void
	{
		if (joyStick != null) removeJoyStick();
		joyStick = new JoyStick(x, y, graphic, onMove);
		currentState.add(joyStick);
	}

	public function removeJoyStick():Void
	{
		if (joyStick != null)
		{
			currentState.remove(joyStick);
			joyStick = FlxDestroyUtil.destroy(joyStick);
		}

		if(joyStickCam != null)
		{
			FlxG.cameras.remove(joyStickCam);
			joyStickCam = FlxDestroyUtil.destroy(joyStickCam);
		}
	}

	public function addJoyStickCamera():Void {
		joyStickCam = new FlxCamera();
		joyStickCam.bgColor.alpha = 0;
		FlxG.cameras.add(joyStickCam, false);
		joyStick.cameras = [joyStickCam];
	}

	public function addLegacyJoyStick(x:Float, y:Float, radius:Float = 0, ease:Float = 0.25, size:Float = 1):Void
	{
		if (legacyJoyStick != null) removeLegacyJoyStick();
		legacyJoyStick = new JoyStickLegacy(x, y, radius, ease, size);
		currentState.add(legacyJoyStick);
	}

	public function removeLegacyJoyStick():Void
	{
		if (legacyJoyStick != null)
		{
			currentState.remove(legacyJoyStick);
			legacyJoyStick = FlxDestroyUtil.destroy(legacyJoyStick);
		}

		if(legacyJoyStickCam != null)
		{
			FlxG.cameras.remove(legacyJoyStickCam);
			legacyJoyStickCam = FlxDestroyUtil.destroy(legacyJoyStickCam);
		}
	}

	public function addLegacyJoyStickCamera():Void {
		legacyJoyStickCam = new FlxCamera();
		legacyJoyStickCam.bgColor.alpha = 0;
		FlxG.cameras.add(legacyJoyStickCam, false);
		legacyJoyStick.cameras = [legacyJoyStickCam];
	}

	public function destroy():Void {
		removeMobilePad();
		removeHitbox();
		removeJoyStick();
		removeLegacyJoyStick();
	}
}
