export interface NavResponse {
	symbol: string
	navPerUnit: number
	nav: number
	date: string
	navFirstDate: string
	buyPrice: number
	sellPrice: number
	buySwapPrice: number
	sellSwapPrice: number
	priorNavPerUnit: number
}

export type PerformancePeriod =
	| "YTD"
	| "1W"
	| "1M"
	| "3M"
	| "6M"
	| "1Y"
	| "3Y"
	| "5Y"
	| "10Y"
	| "FIRSTTRADE"

export interface PerformanceDetails {
	period: PerformancePeriod
	percentChange: number
	specificationRank: number
	specificationTotal: number
	typeRank: number
	typeTotal: number
}

export interface PerformanceResponse {
	specification: string
	type: string
	performances: PerformanceDetails[]
}
