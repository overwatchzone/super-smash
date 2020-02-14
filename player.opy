#!mainFile "smash.opy"

@Rule "On Player Respawn"
@Event eachPlayer
if eventPlayer.isAlive():
    eventPlayer.teleport(boundaryCenter)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 4)
    eventPlayer.knockback = 0
    createInWorldText(getAllPlayers(), "{}%".format(ceil(eventPlayer.knockback)), eventPlayer, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.setRespawnTime(9999)

@Rule "On Player First Spawn"
@Event eachPlayer
if eventPlayer.hasSpawned():
    eventPlayer.teleport(boundaryCenter)
    eventPlayer.knockback = 0
    eventPlayer.hasDrop = false
    createInWorldText(getAllPlayers(), "{}%".format(ceil(eventPlayer.knockback)), eventPlayer, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    if getTotalTimeElapsed() > 60:
        eventPlayer.setScore(0)
        kill(eventPlayer, null)
    elif eventPlayer.dropSwitchHero == true and eventPlayer.latestScore > 0:
        eventPlayer.setScore(eventPlayer.latestScore)
    else:
        eventPlayer.setScore(5)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 4)
    eventPlayer.dropSwitchHero = false
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()

@Rule "On Player Damage"
@Event playerTookDamage
victim.lastAttacker = attacker
victim.applyImpulse(vectorTowards(attacker, victim) + (Vector.UP * (victim.knockback / 100)), (victim.knockback / 10) * (eventDamage / 50), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
victim.knockback += (eventDamage / 3)
#createEffect(getAllPlayers(), Effect.CLOUD, Color.AQUA, victim, 5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
#wait(0.25, Wait.IGNORE_CONDITION)
#destroyEffect(getLastCreatedEntity())

@Rule "On Player Leaving Sphere"
@Event eachPlayer
if distance(eventPlayer, boundaryCenter) > boundaryRadius and eventPlayer.lastAttacker != null:
    kill(eventPlayer, eventPlayer.lastAttacker)
    eventPlayer.lastAttacker = null
    destroyInWorldText(getLastCreatedText())

@Rule "Player HUD Text"
@Event eachPlayer
hudText(eventPlayer, "Damage: {}%".format(eventPlayer.knockback), null, null, Position.TOP, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
hudText(eventPlayer, "Lives Remaining: {}".format(eventPlayer.getScore()), null, null, Position.TOP, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
hudText(eventPlayer, "Have Drop: {}".format(eventPlayer.hasDrop), null, null, Position.TOP, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


@Rule "After Player Dies"
@Event playerDied
wait(1, Wait.IGNORE_CONDITION)
victim.setScore(victim.getScore() - 1)
if victim.getScore() > 0:
    victim.respawn()