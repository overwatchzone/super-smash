#!disableUnusedVars

#!declareGlobal boundaryCenter 0
#!declareGlobal boundaryRadius 1
#!declareGlobal currentMap 2
#!declareGlobal timeTillNextDrop 3
#!declareGlobal playerWithDrop 4
#!declareGlobal shrinkCircle 5
#!declareGlobal circleEffectId 6
#!declareGlobal circleShiftAmount 7

#!declarePlayer knockback 0
#!declarePlayer lastAttacker 1
#!declarePlayer hasDrop 2
#!declarePlayer dropType 3
#!declarePlayer dropTargetPlayer 4

@Rule "Super Smash by Zencep#1489 | Join me on Discord: bit.ly/TZDISCORD | Original Settings by Zomg"
@Event global
currentMap = getCurrentMap()

@Rule "Gamemode in development, please report any issues (or post suggestions) in the Discord."
@Event global
disableScoring()

import "global.opy"
import "player.opy"
import "player-ults.opy"