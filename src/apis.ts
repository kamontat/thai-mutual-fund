import type {
	NavResponse,
	PerformanceDetails,
	PerformancePeriod,
	PerformanceResponse,
} from "./apis.model"
import type { FundInput, FundOutput, Settings } from "./models"

import { globalCache } from "./cache"
import { fromDate, roundNumber, toDate } from "./utils"

export const getFundInput = (fund: FundInput, defaultSettings: Settings) => {
	return {
		...fund,
		setting: {
			...defaultSettings,
			...fund.setting,
		},
	}
}

export const fetchFundData = async (fund: FundInput): Promise<FundOutput> => {
	const nav = await fetchNavData(
		fund.symbol,
		fund.setting as Required<Settings>,
	)

	const performance = await fetchPerformanceData(
		fund.symbol,
		fromDate(toDate(nav.date)),
		fund.setting as Required<Settings>,
	)

	return {
		symbol: nav.symbol,
		date: fromDate(toDate(nav.date)),
		price: roundNumber(nav.navPerUnit, 6),
		price1M: findPercentChange(performance.performances, "1M"),
		price6M: findPercentChange(performance.performances, "6M"),
		price1Y: findPercentChange(performance.performances, "1Y"),
		priceYTD: findPercentChange(performance.performances, "YTD"),
		priceAll: findPercentChange(performance.performances, "FIRSTTRADE"),
	}
}

const fetchNavData = async (symbol: string, settings: Required<Settings>) => {
	const cacheKey = `${symbol}-nav`
	const cached = await globalCache.get(cacheKey)
	if (cached) return cached as NavResponse

	const url = new URL(
		`/api/mutual-fund/${encodeURIComponent(symbol)}/nav`,
		"https://api.settrade.com",
	)

	const response = await fetch(url)
	const json = await response.json()
	globalCache.set(cacheKey, json, settings.ttl)
	return json as NavResponse
}

const fetchPerformanceData = async (
	symbol: string,
	date: string,
	settings: Required<Settings>,
) => {
	const cacheKey = `${symbol}-${date}-performance`
	const cached = await globalCache.get(cacheKey)
	if (cached) return cached as PerformanceResponse

	const url = new URL(
		`/api/mutual-fund/${encodeURIComponent(symbol)}/performance`,
		"https://api.settrade.com",
	)
	url.searchParams.set("date", date)

	const response = await fetch(url)
	const json = await response.json()
	globalCache.set(cacheKey, json, settings.ttl)
	return json as PerformanceResponse
}

const findPercentChange = (
	performances: PerformanceDetails[],
	period: PerformancePeriod,
) => {
	const performance = performances.find((perf) => perf.period === period)
	return roundNumber(performance?.percentChange ?? 0, 2)
}
