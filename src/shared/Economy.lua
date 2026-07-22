local Economy = {}

Economy.BASE_TAP_VALUE = 1
Economy.BASE_MULTIPLIER_COST = 25
Economy.REBIRTH_BASE_COST = 1_000

function Economy.tapValue(multiplier: number, rebirths: number): number
	return Economy.BASE_TAP_VALUE * multiplier * (rebirths + 1)
end

function Economy.multiplierCost(multiplier: number): number
	return math.floor(Economy.BASE_MULTIPLIER_COST * (1.65 ^ (multiplier - 1)))
end

function Economy.rebirthCost(rebirths: number): number
	return Economy.REBIRTH_BASE_COST * (rebirths + 1) ^ 2
end

return Economy

