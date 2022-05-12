package spectral

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

image: docker.#Pull & {
	source: "stoplight/spectral"
}

#Container: {
	// _build provides the default image
	_build: image.output
	// Ruleset file
	rulesetFile?: dagger.#FS

	docker.#Run & {
		input: docker.#Image | *_build
		if rulesetFile != _|_ {
			mounts: rules: {
				contents: rulesetFile
				dest:     "/rules"
				ro:       true
			}
		}
	}
}
