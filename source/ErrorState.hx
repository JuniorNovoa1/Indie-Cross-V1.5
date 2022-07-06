package;

import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxState;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;

using StringTools;

class ErrorState extends MusicBeatState
{
	var NewState:FlxState;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		super.create();
	}

	override function update(elapsed)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			trace('Redirecting...');
			FlxG.switchState(NewState);
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			trace('Restarting...');
			FlxG.switchState(new Startup());
			//FlxG.resetGame();
		}

		super.update(elapsed);
	}

	public function new(error:String, State:FlxState)
	{
		super();

		trace('Error: ' + error);
		trace('Next State Status: ' + State);
		lime.app.Application.current.window.alert('Press Enter To Continue. \n Press Escape to Reset Your Game.', 'Error! \n' + error);
		//Application.current.window.alert(error, '\n Press Enter To Continue. \n Press Escape to Reset Your Game.');

		NewState = State;
	}

}