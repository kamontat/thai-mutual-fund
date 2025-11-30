import type { FundOutput, Settings } from "./models"

export const reportFund = async (
	funds: FundOutput[],
	settings: Required<Settings>,
) => {
	if (settings.format === "table") console.table(funds)
	else if (settings.format === "json")
		console.log(JSON.stringify(funds, null, 2))
}
