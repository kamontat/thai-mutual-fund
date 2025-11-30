import type { PerformancePeriod } from "./apis.model"

export interface Settings {
	ttl?: number
	format?: "table" | "json"
}

export interface FundInput {
	symbol: string
	setting?: Partial<Omit<Settings, "format">>
}

export interface FundOutput {
	symbol: string
	date: string
	price: number
	price1M: number
	price6M: number
	price1Y: number
	priceYTD: number
	priceAll: number
}
