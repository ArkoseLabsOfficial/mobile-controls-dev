package mobile;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.graphics.frames.FlxTileFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * A modified FlxVirtualPad works with IDs.
 * It's really easy to customize the layout.
 *
 * @author KralOyuncu 2010x (ArkoseLabs)
 */
@:access(mobile.MobileButton)
class MobilePad extends MobileInputHandler {
	public var onButtonDown:FlxTypedSignal<(MobileButton, Array<String>, Int) -> Void> = new FlxTypedSignal<(MobileButton, Array<String>, Int) -> Void>();
	public var onButtonUp:FlxTypedSignal<(MobileButton, Array<String>, Int) -> Void> = new FlxTypedSignal<(MobileButton, Array<String>, Int) -> Void>();
	public var instance:MobileInputHandler;
	public var DPads:Array<MobileButton> = [];
	public var Actions:Array<MobileButton> = [];
	public var buttonIndexFromName:Map<String, Int> = [];
	public var buttonFromName:Map<String, MobileButton> = [];

	public function getButtonIndexFromName(btnName:String)
		return buttonIndexFromName.get(btnName);

	public function getButtonFromName(btnName:String)
		return buttonFromName.get(btnName);

	/**
	 * Create a virtual gamepad.
	 *
	 * @param   DPadMode   The D-Pad mode. `FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 * @param   GlobalAlpha   The alpha of buttons. `0.7` for example.
	 */

	public function new(?DPad:String, ?Action:String, ?globalAlpha:Float = 0.7, ?disableCreation:Bool) {
		super();

		if (!disableCreation)
		{
			if (DPad != "NONE")
			{
				if (!MobileConfig.dpadModes.exists(DPad))
					throw 'The mobilePad dpadMode "$DPad" doesn\'t exists.';

				for (buttonData in MobileConfig.dpadModes.get(DPad).buttons)
				{
					if (buttonData.scale == null) buttonData.scale = 1.0;
					var buttonName:String = buttonData.button;
					var buttonIDs:Array<String> = buttonData.buttonIDs;
					var buttonUniqueID:Int = buttonData.buttonUniqueID;
					var buttonGraphic:String = buttonData.graphic;
					var buttonScale:Float = buttonData.scale;
					var buttonColor = buttonData.color;
					var buttonX:Float = buttonData.x;
					var buttonY:Float = buttonData.y;
					if (buttonData.buttonUniqueID == null) buttonUniqueID = -1; // -1 means not setted.

					addButton(buttonName, buttonIDs, buttonUniqueID, buttonX, buttonY, buttonGraphic, buttonScale, Util.colorFromString(buttonColor), 'DPad');
				}
			}

			if (Action != "NONE")
			{
				if (!MobileConfig.actionModes.exists(Action))
					throw 'The mobilePad actionMode "$Action" doesn\'t exists.';

				for (buttonData in MobileConfig.actionModes.get(Action).buttons)
				{
					if (buttonData.scale == null) buttonData.scale = 1.0;
					var buttonName:String = buttonData.button;
					var buttonIDs:Array<String> = buttonData.buttonIDs;
					var buttonUniqueID:Int = buttonData.buttonUniqueID;
					var buttonGraphic:String = buttonData.graphic;
					var buttonColor = buttonData.color;
					var buttonScale:Float = buttonData.scale;
					var buttonX:Float = buttonData.x;
					var buttonY:Float = buttonData.y;
					if (buttonData.buttonUniqueID == null) buttonUniqueID = -1; // -1 means not setted.

					addButton(buttonName, buttonIDs, buttonUniqueID, buttonX, buttonY, buttonGraphic, buttonScale, Util.colorFromString(buttonColor), 'Action');
				}
			}
		}

		scrollFactor.set();
		updateTrackedButtons();
		alpha = globalAlpha;

		instance = this;
	}

	public var countedDPadIndex:Int = 0;
	public var countedActionIndex:Int = 0;
	public function addButton(buttonName:String, buttonIDs:Array<String>, ?buttonUniqueID:Int = -1, buttonX:Float, buttonY:Float, buttonGraphic:String, ?buttonScale:Float = 1.0, ?buttonColor:Int = 0xFFFFFF, indexType:String = 'DPad') {
		var button:MobileButton = new MobileButton(0, 0);
		button = createVirtualButton(buttonX, buttonY, buttonGraphic, buttonScale, buttonColor);
		button.name = buttonName;
		button.uniqueID = buttonUniqueID;
		button.IDs = buttonIDs;
		button.onDown.callback = () -> onButtonDown.dispatch(button, buttonIDs, buttonUniqueID);
		button.onOut.callback = button.onUp.callback = () -> onButtonUp.dispatch(button, buttonIDs, buttonUniqueID);

		Actions.push(button);
		add(button);
		buttonFromName.set(buttonName, button);
		switch (indexType.toUpperCase()) {
			case 'DPAD':
				buttonIndexFromName.set(buttonName, countedDPadIndex);
				countedDPadIndex++;
			case 'ACTION':
				buttonIndexFromName.set(buttonName, countedActionIndex);
				countedActionIndex++;
		}
	}

	public function createVirtualButton(x:Float, y:Float, framePath:String, ?scale:Float = 1.0, ?ColorS:Int = 0xFFFFFF):MobileButton {
		var frames:FlxGraphic;

		final path:String = MobileConfig.mobileFolderPath + 'MobilePad/Textures/$framePath.png';
		if(Assets.exists(path))
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(path));
		else
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(MobileConfig.mobileFolderPath + 'MobilePad/Textures/default.png'));

		var button = new MobileButton(x, y);
		button.scale.set(scale, scale);
		button.frames = FlxTileFrames.fromGraphic(frames, FlxPoint.get(Std.int(frames.width / 2), frames.height));

		button.updateHitbox();
		button.updateLabelPosition();

		button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
		button.centerBounds();

		button.immovable = true;
		button.solid = button.moves = false;
		button.antialiasing = true;
		button.tag = framePath.toUpperCase();

		if (ColorS != -1) button.color = ColorS;
		return button;
	}

	/**
	 * Clean up memory.
	 */
	override function destroy():Void
	{
		super.destroy();
		onButtonUp.destroy();
		onButtonDown.destroy();

		DPads = [];
		Actions = [];
		buttonIndexFromName = [];
		buttonFromName = [];
	}
}