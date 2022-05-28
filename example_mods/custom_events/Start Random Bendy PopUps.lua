function onCreate()
    addLuaScript('custom_events/Bendy Cutout PopUp', true);
end

local jumpscareClock = 0;

local jumpscareTime = nil;

amountOfInstances = 4;

local min = 30;
local max = 65;

function onEvent(name, value1, value2)
	if name == 'Start Random Bendy PopUps' then
        if value1 ~= '' then
            min = tonumber(value1);
        end
        if value2 ~= '' then
            max = tonumber(value2);
        end
        jumpscareTime = getRandomInt(min, max);
    end
    if name == 'Stop Random Bendy PopUps' then
        jumpscareClock = 0;
        jumpscareTime = nil;
    end
end

-- Bendy Check
function CheckForBendy()
    if jumpscareTime == nil then
        return;
    end
    jumpscareClock = jumpscareClock + 1;
    if jumpscareClock >= jumpscareTime then
        triggerEvent('Bendy Cutout PopUp', tostring(getRandomInt(1, amountOfInstances)), '');
        jumpscareClock = 0;
        jumpscareTime = getRandomInt(min, max);
    end
end

function onSongStart()
    CheckForBendy();
end
function onBeatHit()
	CheckForBendy();
end