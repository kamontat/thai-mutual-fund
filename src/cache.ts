import { FileSystemCache } from "file-system-cache"

export const globalCache = new FileSystemCache({
	basePath: "./.cache",
	ns: "fund-check",
	extension: ".json",
	ttl: 1000 * 60 * 60 * 24, // 1 day
})
