package;

import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import haxe.CallStack;
import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import lime.app.Application;
import openfl.display.StageScaleMode;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import GameJolt;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	#if desktop
	var initialState:Class<FlxState> = Startup; // The FlxState the game starts with.
	#else
	var initialState:Class<FlxState> = MainMenuState; // The FlxState the game starts with.
	#end
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;

	//for when the game is not focused/is focused
	var focusMusicTween:FlxTween;
	var SoundVolume:Float = 0.0;
	//ok done!!!!!!

	public static var gjToastManager:GJToastManager; //this is needed for the child

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	function onWindowFocusOut()
	{
		trace("Game unfocused");
	
		SoundVolume = FlxG.sound.volume;
		trace('Previous sound volume: ' + SoundVolume);

		// Lower global volume when unfocused
		if (focusMusicTween != null)
			focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 0.1}, 0.4);
	
		// Conserve power by lowering draw framerate when unfocuced
		FlxG.drawFramerate = 20;
	}
	
	function onWindowFocusIn()
	{
		trace("Game focused");

		// Normal global volume when focused
		if (focusMusicTween != null)
			focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: SoundVolume}, 0.4);
		trace('Setting sound volume to: ' + SoundVolume);
	
		// Bring framerate back when focused
		FlxG.drawFramerate = ClientPrefs.framerate;
	}

	function onCrash(e:UncaughtErrorEvent):Void
	{
		lime.app.Application.current.window.alert('Game will shut down.', 'An error has occured!'); //1. description, 2. Main Title

		Sys.exit(1);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		gjToastManager = new GJToastManager();
		addChild(gjToastManager); //adding the toddler
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if (desktop && !debug)
		initialState = Startup;
		#else
		initialState = MainMenuState;
		#end
	
		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";
		
		#if web
		var str1:String = "HTML CRAP";
		var vHandler = new VideoHandler();
		vHandler.init1();
		vHandler.video.name = str1;
		addChild(vHandler.video);
		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(ourSource);
		#elseif desktop
		var str1:String = "WEBM SHIT"; 
		var webmHandle = new WebmHandler();
		webmHandle.source(ourSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);
		#end

		/*
		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end
		*/

		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
	}
}
