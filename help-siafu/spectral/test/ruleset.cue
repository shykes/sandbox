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
			// NOTE: probably not needed?
			always:      true
			rulesetFile: client.filesystem.".".read.contents
			entrypoint: []
			command: {
				name: "sh"
				flags: "-c": "spectral lint --ruleset standards.spectral.yaml petstore.yaml --output output.json --format json"
			}
			export: files: "/output.json": =~""
		}
	}
}
