package test

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/x/siafudev@gmail.com/spectral"
)

dagger.#Plan & {
	actions: test: {

		_data: {
			load: core.#Source & {
				path: "."
				exclude: ["*.cue", "*.bats"]
			}
			contents: load.output
		}

		// Run spectral linter with a custom ruleset file
		customRuleset: {
			lint: spectral.#Lint & {
				source: _data.contents
				ruleset: filename: "standards.spectral.yaml"
				documents: ["petstore.yaml"]
			}
			// Test assertion
			nMessages: len(lint.logs) & 15
			lint: logs: [
				{
					message: """
						OpenAPI object must have non-empty "tags" array.
						"""
				},
				{
					message: """
						Info object must have \"contact\" object.
						"""
				},
				..._,
			]
		}
	}
}
