return {
	settings = {
		json = {
			schema = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}
