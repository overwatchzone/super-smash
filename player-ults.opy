#!mainFile "smash.opy"

@Rule "Set Initial Drop Timer"
@Event global
timeTillNextDrop = random.randint(15, 25)

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
    playerWithDrop.dropType = random.randint(1, 10)

    if playerWithDrop.dropType == 1 or playerWithDrop.dropType == 2 or playerWithDrop.dropType == 8:
        bigMessage(playerWithDrop, "You have received drop 'freeze everyone close to you', press 'interact' to use.")
    elif playerWithDrop.dropType == 3:
        bigMessage(playerWithDrop, "You have received drop 'remove your knockback damage', press 'interact' to use.")
    elif playerWithDrop.dropType == 4 or playerWithDrop.dropType == 5 or playerWithDrop.dropType == 6 or playerWithDrop.dropType == 7:
        bigMessage(playerWithDrop, "You have received drop 'burn whoever your looking at', press 'interact' to use.")
    elif playerWithDrop.dropType == 9 or playerWithDrop.dropType == 10:
        bigMessage(playerWithDrop, "You have received drop 'teleport everyone back to spawn', press 'interact' to use.")

    timeTillNextDrop = random.randint(15, 25)

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
    
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getPosition(), 10)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.PURPLE, eventPlayer.getPosition(), 200)
    eventPlayer.hasDrop = false