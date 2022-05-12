package test

import (
	"dagger.io/dagger"
	"universe.dagger.io/x/siafudev@gmail.com/spectral"
)

dagger.#Plan & {
	client: {
		filesystem: ".": read: {
			contents: dagger.#FS
			include: ["petstore.yaml", "standards.spectral.yaml"]
		}
	}
	actions: {

		rulesetOutput: spectral.#Container & {
			always:      true
			rulesetFile: client.filesystem.".".read.contents
			command: {
				name: "sh"
				flags: "-c": "spectral lint --ruleset standards.spectral.yaml petstore.yaml --output output.json --format json"
			}
			export: files: "/output.json": =~""
		}
	}
}
