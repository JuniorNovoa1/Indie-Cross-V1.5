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

class Start extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;
	public var fuckingVolume:Float = 1;
	public var useVideo = false;
	public static var webmHandler:WebmHandler;
	public var playingDathing = false;
	public var videoSprite:FlxSprite;
	public var camHUD2:FlxCamera;

	var loaded = false;

	public static var loadTxt:FlxText;

	var VideoPlaying = false;

	public static var bitmapData:Map<String, FlxGraphic>;

	var images = [];
	var music = [];
	var charts = [];

	override function create()
	{
		FlxG.mouse.visible = false;

		camHUD2 = new FlxCamera();
		camHUD2.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD2);

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Loading_screen'));
		add(bg);

		loadTxt = new FlxText(0, 0, 0, "Loading...", 30);
		loadTxt.screenCenter(X);
		loadTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		loadTxt.alignment = RIGHT;
		loadTxt.y = 600;
		loadTxt.x = 0;
		add(loadTxt);

		bitmapData = new Map<String, FlxGraphic>();

		#if desktop
		trace("caching images...");

		// TODO: Refactor this to use OpenFlAssets.
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			if (!i.endsWith(".xml"))
				continue;
			images.push(i);
		}

		trace("caching music...");

		for (i in music)
		{
			var inst = Paths.inst(i);
			if (Paths.doesSoundAssetExist(inst))
			{
				FlxG.sound.cache(inst);
			}
		
			var voices = Paths.voices(i);
			if (Paths.doesSoundAssetExist(voices))
			{
				FlxG.sound.cache(voices);
			}
	    }
		
		trace("Finished caching...");

		// TODO: Get the song list from OpenFlAssets.
		#end

		toBeDone = Lambda.count(images);

		trace('starting caching..');

		new FlxTimer().start(3.5, function(tmr:FlxTimer)
		{
			//lets the game get ready so its less demanding on cpu and memory -thatblockboi
			#if desktop
			// cache thread
			sys.thread.Thread.create(() ->
			{
				cache();
			});
			#end
		});

		//penis

		super.create();
	}

	var calledDone = false;

	override function update(elapsed)
	{
		if (FlxG.keys.justPressed.ENTER)// && VideoPlaying)
		{
			//FlxG.sound.music.stop();
			//GlobalVideo.get().clearPause();
			#if desktop
			//GlobalVideo.get().stop();
			//GlobalVideo.get().hide();
			//remove(videoSprite);
			#end
			//remove(tmr);
			//MusicBeatState.switchState(new TitleState());
			//LoadingState.loadAndSwitchState(new ErrorState('yo mom', 'TitleState'));
		}

		//FlxG.switchState(new TitleState()); //needed due to you having to press enter

		//FlxG.switchState(new ErrorState('joe mama', new TitleState()));

		super.update(elapsed);
	}

	function cache()
	{
		#if desktop
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
				var replaced = i.replace(".png", "");
				var imagePath = Paths.image('assets/' + replaced, 'images');
				trace('Caching character graphic $replaced ($imagePath)...');
				//if anything needs to be cached it will cache it -thatblockboi

				//var data = OpenFlAssets.getBitmapData(imagePath);
				//var graph = FlxGraphic.fromBitmapData(data);
				//graph.persist = true;
				//bitmapData.set(replaced, graph);
				done++;
		}
	

		trace("Finished caching...");

		loaded = true;

		if (loaded)
			MusicBeatState.switchState(new TitleState());
		else
		{
			trace ('not done');
		}

		trace(OpenFlAssets.cache.hasBitmapData('GF_assets'));
		#end
		//LoadingState.loadAndSwitchState(new VideoState("assets/videos/start&end/intro.webm", new TitleState()));
		//Video(); //did this since what i did above just crashes the game :/
	}
}