import { fetchFundData, getFundInput } from "./src/apis"
import { globalCache } from "./src/cache"
import type { FundInput, FundOutput, Settings } from "./src/models"
import { reportFund } from "./src/report"
import { chunk, unchunk } from "./src/utils"

export const DEFAULT_SETTINGS: Required<Settings> = {
	ttl: 1000 * 60 * 60 * 24 * 1, // 1 day
	format: "table",
}

export const FUNDS: Array<FundInput> = [
	{
		symbol: "ES-SETESG-ThaiESG-A",
	},
	{
		symbol: "K-CHANGE-SSF",
	},
	{
		symbol: "K-USA-SSF",
	},
	{
		symbol: "KFGTECH-A",
	},
	{
		symbol: "KFGBRANSSF",
	},
	{
		symbol: "KFS100SSF",
	},
	{
		symbol: "KKP ACT FIXED-SSF",
	},
	{
		symbol: "KKP GB THAI ESG",
	},
	{
		symbol: "KKP INCOME-H-SSF",
	},
	{
		symbol: "KKP PGE-H-SSF",
	},
	{
		symbol: "KTAG70/30-THAIESG",
	},
	{
		symbol: "ONE-UGG-ASSF",
	},
	{
		symbol: "PRINCIPAL iPROPEN-SSF",
	},
	{
		symbol: "SCBGOLDH",
	},
	{
		symbol: "SCBGOLDH-SSF",
	},
	{
		symbol: "SCBNEXT(SSF)",
	},
	{
		symbol: "SCBVIET(SSFA)",
	},
	{
		symbol: "UGIS-SSF",
	},
]

async function main() {
	globalCache.ensureBasePath()

	const chunkFunds = chunk(FUNDS, 10)
	const results: FundOutput[] = []
	for await (const funds of chunkFunds) {
		const result = await Promise.all(
			funds.map(async (fund) => {
				return fetchFundData(getFundInput(fund, DEFAULT_SETTINGS))
			}),
		)

		results.push(...result)
	}

	await reportFund(results, DEFAULT_SETTINGS)
}

void main()
