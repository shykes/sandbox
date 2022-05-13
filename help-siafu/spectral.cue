package spectral

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

#Container: {

	// NOTE: moved from package top-level to inside definition
	image: docker.#Pull & {
		source: "stoplight/spectral"
	}

	// _build provides the default image
	_build: image.output
	// Ruleset file
	rulesetFile?: dagger.#FS

	docker.#Run & {
		input: docker.#Image | *_build
		entrypoint: []
		workdir: "/rules"
		if rulesetFile != _|_ {
			mounts: rules: {
				contents: rulesetFile
				dest:     "/rules"
				ro:       true
			}
		}
	}
}
