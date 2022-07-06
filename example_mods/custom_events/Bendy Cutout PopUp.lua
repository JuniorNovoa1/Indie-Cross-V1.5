function onCreate()
    makeAnimatedLuaSprite('BendyCut', 'BendyCutouts', 0, 0);
    addAnimationByPrefix('BendyCut', '1', '01 instance 1', 24, false);
    addAnimationByPrefix('BendyCut', '2', '02 instance 1', 24, false);
    addAnimationByPrefix('BendyCut', '3', '03 instance 1', 24, false);
    addAnimationByPrefix('BendyCut', '4', '04 instance 1', 24, false);
    setObjectCamera('BendyCut', 'hud');
    setScrollFactor('BendyCut', 0, 0);
    setProperty('BendyCut.visible', false);
    setProperty('BendyCut.scale.x', 2.2);
    setProperty('BendyCut.scale.y', 2.2);
    addLuaSprite('BendyCut', false);

    precacheImage('BendyCutouts');
    precacheSound('cutout');
end

amountOfInstances = 4;

bendyTable = {
    ['x'] = {810, 250, 350, 100; n=amountOfInstances},
    ['y'] = {360, -30, 50, -230; n=amountOfInstances}
}

function BendyJumpscare(instance)
    if not(instance >= 1 and instance <= amountOfInstances) then
        return;
    end
    if not getProperty('BendyCut.visible') then
        setProperty('BendyCut.visible', true);
    end
    setProperty('BendyCut.x', bendyTable['x'][instance]);
    setProperty('BendyCut.y', bendyTable['y'][instance]);
    objectPlayAnimation('BendyCut', tostring(instance), true);
    playSound('cutout');
end

function onEvent(name, value1, value2)
	if name == 'Bendy Cutout PopUp' then
        BendyJumpscare(tonumber(value1));
    end
end

function onUpdate(elapsed)
    if getProperty('BendyCut.animation.curAnim.finished') then
        setProperty('BendyCut.visible', false);
    end
end