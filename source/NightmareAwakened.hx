package;

import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
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

class NightmareAwakened extends MusicBeatState
{
    public static var CupNightmare:Bool = false;
	public static var SansNightmare:Bool = false;
	public static var BendyNightmare:Bool = false;

	override public function create()
	{
		if (CupNightmare && CoolUtil.difficultyString() == 'HARD')
		{
			var Warning:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('cupalert'));
			Warning.updateHitbox();
			Warning.screenCenter();
			add(Warning);
		}
		else if (SansNightmare && CoolUtil.difficultyString() == 'HARD')
		{
			var Warning:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('sansalert'));
			Warning.updateHitbox();
			Warning.screenCenter();
			add(Warning);
		}
		else if (BendyNightmare && CoolUtil.difficultyString() == 'HARD')
		{
			var Warning:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('bendyalert'));
			Warning.updateHitbox();
			Warning.screenCenter();
			add(Warning);
		}
		else
		{
			CupNightmare = false;
			SansNightmare = false;
			BendyNightmare = false;
			LoadingState.loadAndSwitchState(new StoryMenuState());
		}

	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			CupNightmare = false;
			SansNightmare = false;
			BendyNightmare = false;

			LoadingState.loadAndSwitchState(new StoryMenuState());
		}
	}
}