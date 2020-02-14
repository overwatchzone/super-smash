#!mainFile "smash.opy"

@Rule "Setup Game"
@Event global
disableAnnouncer()
getPlayers(Team.ALL).disableRespawn()
hudHeader(getAllPlayers(), "Discord: bit.ly/TZDISCORD", Position.LEFT, 0, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
hudHeader(getAllPlayers(), "twitch.tv/Zencep", Position.LEFT, 1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
hudSubheader(getAllPlayers(), "Press interact key (default F) to use drops when you have them.", Position.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

@Rule "Setup Map"
@Event global
if currentMap == Map.KINGS_ROW or currentMap == Map.KINGS_ROW_WINTER:
    boundaryCenter = vect(-20.612, 60.637, -74.942)
    boundaryRadius = 40
elif currentMap == Map.BLIZZ_WORLD or currentMap == Map.BLIZZ_WORLD_WINTER:
    boundaryCenter = vect(-49.94, 5.86, 93.15)
    boundaryRadius = 20
elif currentMap == Map.HANAMURA or currentMap == Map.HANAMURA_WINTER:
    boundaryCenter = vect(-11.06, -0.93, -84.90)
    boundaryRadius = 18
elif currentMap == Map.Havana:
    boundaryCenter = vect(-17.14, 26.59, -43.37)
    boundaryRadius = 22
elif currentMap == Map.VOLSKAYA:
    boundaryCenter = vect(-14.5, 21.04, 84) # Rework this, coords are offset a bit too much.
    boundaryRadius = 30
elif currentMap == Map.TEMPLE_OF_ANUBIS:
    boundaryCenter = vect(-2.34, 20.81, 128.49)
    boundaryRadius = 20
circleShiftAmount = 0
createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, boundaryCenter, boundaryRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
circleEffectId = getLastCreatedEntity()

@Rule "Activate Shrink Circle"
@Event global
if getTotalTimeElapsed() > 180 and shrinkCircle == false:
    shrinkCircle = true
    bigMessage(getAllPlayers(), "WATCH OUT! The circle is moving!")

@Rule "Loop - Shrink Circle"
@Event global
if shrinkCircle:
    do:
        boundaryRadius -= 0.5
        createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, boundaryCenter, boundaryRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        destroyEffect(circleEffectId)
        circleEffectId = getLastCreatedEntity()
        wait(5, Wait.IGNORE_CONDITION)
    while RULE_CONDITION

@Rule "Loop - Apply Healing To All Players"
@Event eachPlayer
    do:
        heal(eventPlayer, null, 1000)
        wait(0.016, Wait.IGNORE_CONDITION)
    while RULE_CONDITION
    
@Rule "Declare Victory"
@Event eachPlayer
if len([player for player in getAllPlayers() if player.getScore() <= 0]) == (getNumberOfPlayers(Team.ALL) - 1) and len(getDeadPlayers(Team.ALL)) == (getNumberOfPlayers(Team.ALL) - 1) and getNumberOfPlayers(Team.ALL) > 1:
    declarePlayerVictory(getLivingPlayers(Team.ALL)[0])
