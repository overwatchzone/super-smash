#!mainFile "smash.opy"

@Rule "Set Initial Drop Timer"
@Event global
timeTillNextDrop = random.randint(5, 15)

@Rule "Loop - Drop Timer Countdown"
@Event global
if timeTillNextDrop > 0:
    do:
        timeTillNextDrop -= 1
        wait(1, Wait.IGNORE_CONDITION)
    while RULE_CONDITION

@Rule "Distribute Drop"
@Event global
if timeTillNextDrop <= 0:
    playerWithDrop = random.choice(getLivingPlayers(Team.ALL))
    playerWithDrop.hasDrop = true
    playerWithDrop.dropType = random.randint(1, 16)

    if playerWithDrop.dropType == 1 or playerWithDrop.dropType == 2 or playerWithDrop.dropType == 8:
        bigMessage(playerWithDrop, "You have received drop 'freeze everyone close to you', press 'interact' to use.")
    elif playerWithDrop.dropType == 3:
        bigMessage(playerWithDrop, "You have received drop 'remove your knockback damage', press 'interact' to use.")
    elif playerWithDrop.dropType == 4 or playerWithDrop.dropType == 5 or playerWithDrop.dropType == 6 or playerWithDrop.dropType == 7:
        bigMessage(playerWithDrop, "You have received drop 'burn whoever your looking at', press 'interact' to use.")
    elif playerWithDrop.dropType == 9 or playerWithDrop.dropType == 10:
        bigMessage(playerWithDrop, "You have received drop 'teleport everyone back to spawn', press 'interact' to use.")
    elif playerWithDrop.dropType == 11 or playerWithDrop.dropType == 12 or playerWithDrop.dropType == 13:
        bigMessage(playerWithDrop, "You have received drop 'deal triple damage', press 'interact' to use.")
    elif playerWithDrop.dropType == 14:
        bigMessage(playerWithDrop, "You have received drop 'switch hero', press 'interact' to go back to hero selection.")
    elif playerWithDrop.dropType == 15 or playerWithDrop.dropType == 16:
        bigMessage(playerWithDrop, "You have received drop 'root yourself', press 'interact' to use.")

    timeTillNextDrop = random.randint(5, 15)

@Rule "Activate Drop"
@Event eachPlayer
if eventPlayer.hasDrop and eventPlayer.isHoldingButton(Button.INTERACT):
    if playerWithDrop.dropType == 1 or playerWithDrop.dropType == 2 or playerWithDrop.dropType == 8:
        getPlayersInRadius(eventPlayer.getPosition(), 15, Team.ALL, LosCheck.OFF).exclude(eventPlayer).setStatusEffect(eventPlayer, Status.FROZEN, 3)
        bigMessage(getLivingPlayers(Team.ALL), "{} has used the Frozen drop.".format(eventPlayer))
    elif eventPlayer.dropType == 3:
        eventPlayer.knockback = 0
        bigMessage(getLivingPlayers(Team.ALL).exclude(eventPlayer), "{} has reset their knockback, you know what to do.".format(eventPlayer))
    elif playerWithDrop.dropType == 4 or playerWithDrop.dropType == 5 or playerWithDrop.dropType == 6 or playerWithDrop.dropType == 7:
        eventPlayer.dropTargetPlayer = eventPlayer.getPlayerClosestToReticle(Team.ALL)
        eventPlayer.dropTargetPlayer.setStatusEffect(eventPlayer, Status.BURNING, 8)
        bigMessage(eventPlayer.dropTargetPlayer, "{} has caused you to burn.".format(eventPlayer))
    elif playerWithDrop.dropType == 9 or playerWithDrop.dropType == 10:
        getLivingPlayers(Team.ALL).teleport(boundaryCenter)
        bigMessage(getLivingPlayers(Team.ALL), "{} has teleported everyone back to spawn point.".format(eventPlayer))
    elif playerWithDrop.dropType == 11 or playerWithDrop.dropType == 12 or playerWithDrop.dropType == 13:
        bigMessage(getLivingPlayers(Team.ALL), "{} has triple damage for 8 seconds! Watch out!.".format(eventPlayer))
        eventPlayer.setDamageDealt(350)
        wait(8, Wait.IGNORE_CONDITION)
        eventPlayer.setDamageDealt(150)
    elif playerWithDrop.dropType == 14:
        eventPlayer.dropSwitchHero = true
        eventPlayer.latestScore = eventPlayer.getScore()
        eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getCurrentHero()))
        wait(0.250, Wait.IGNORE_CONDITION)
        eventPlayer.resetHeroAvailability()
    elif playerWithDrop.dropType == 15 or playerWithDrop.dropType == 16:
        eventPlayer.setStatusEffect(null, Status.ROOTED, 15)
        bigMessage(eventPlayer, "You're now rooted for 15 seconds, enjoy!")
        bigMessage(getLivingPlayers(Team.ALL).exclude(eventPlayer), "{} is now rooted, FOCUS THEM!".format(eventPlayer))
    
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getPosition(), 10)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.PURPLE, eventPlayer.getPosition(), 200)
    eventPlayer.hasDrop = false