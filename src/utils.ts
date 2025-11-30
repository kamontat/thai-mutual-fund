export const chunk = <T>(array: T[], size: number): T[][] => {
	const result: T[][] = []

	for (let i = 0; i < array.length; i += size) {
		result.push(array.slice(i, i + size))
	}
	return result
}

export const unchunk = <T>(arrays: T[][]): T[] => {
	return arrays.flat(1)
}

export const toDate = (date: string): Date => {
	if (/^\d{2}\/\d{2}\/\d{4}$/.test(date)) {
		const [day, month, year] = date.split("/").map(Number)
		if (!year || !month || !day) throw new Error(`Invalid date format: ${date}`)
		return new Date(year, month - 1, day)
	} else {
		return new Date(date)
	}
}

export const fromDate = (date: Date): string => {
	const day = date.getDate()
	const month = date.getMonth() + 1
	const year = date.getFullYear()

	return `${day}/${month}/${year}`
}

export const roundNumber = (num: number, decimal: number): number => {
	const factor = 10 ** decimal
	return Math.round(num * factor) / factor
}
