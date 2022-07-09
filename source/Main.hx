package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import flixel.util.FlxColor;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

import flixel.tweens.FlxTween;
import GameJolt;
import Discord.DiscordClient;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = Start; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;

	//for when the game is not focused/is focused
	var focusMusicTween:FlxTween;
	var SoundVolume:Float = 0.0;
	//ok done!!!!!!

	public static var Debug:Bool = false;
	public static var gjToastManager:GJToastManager; //this is needed for the child

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}


	public function new()
	{
		super();

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

	//trace from izzie engine!!!!!!!
	function onWindowFocusOut()
	{
		trace("Game unfocused");
	
		SoundVolume = FlxG.sound.volume;
		trace('Previous sound volume: ' + SoundVolume);

		// Lower global volume when unfocused
		if (focusMusicTween != null)
			focusMusicTween.cancel();

		if (SoundVolume != 0)
		{
			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 0.1}, 0.4);
		}
		else if (SoundVolume == 0)
		{
			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: 0}, 0.4);
		}
	
		// Conserve power by lowering draw framerate when unfocuced
		FlxG.drawFramerate = 20;
	}
	
	//trace from izzie engine!!!!!!!
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

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
	
		//dateNow = dateNow.replace(" ", "_"); //THIS IS BROKEN FOR SOME REASON
		//dateNow = dateNow.replace(":", "'"); //THIS IS BROKEN FOR SOME REASON
	
		path = "./crash/" + "Indie Cross_" + dateNow + ".txt";
	
		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}
	
		errMsg += 
		"\n
		Uncaught Error: " 
		+ 
		e.error 
		+ 
		"\n
		Please report this error to the Discord server: 
		https://discord.gg/J2HMjaUqfr
		\n
		\n
		> Crash Handler written by: sqirra-rng
		\n
		\n
		> Port by: JuniorNovoa and Bushtrain and Thatblockboi";
		//did this so its more editable
	
		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");
	
		File.saveContent(path, errMsg + "\n");
	
		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
	
		Application.current.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();

	    Sys.exit(1);
	}
	#end
}
