function onCreate()
  --background
  makeLuaSprite('back','cup/BG-00',-820,-400)
  setScrollFactor('back',0.4,0.4)
  scaleObject('back',0.8,0.8)
  makeLuaSprite('mid','cup/BG-01',-820,-400)
  setScrollFactor('mid',0.4,0.4)
  scaleObject('mid',0.8,0.8)
  makeLuaSprite('floor','cup/Foreground',-820,-620)
  scaleObject('floor',0.8,0.8)
  makeAnimatedLuaSprite('camera','cup/oldtimey',0,0)
  addAnimationByPrefix('camera','idle','Cupheadshit_gif instance 1',24,true)
  objectPlayAnimation('camera','idle',true)
  setObjectCamera('camera','hud')
  addLuaSprite('back',false)
  addLuaSprite('mid',false)
  addLuaSprite('floor',false)
  addLuaSprite('camera',true)
  close(true);
  end