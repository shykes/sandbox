package qload

import (
	"strings"
	"dagger.io/dagger"
	"dagger.io/dagger/core"

	"universe.dagger.io/git"
)


// A manifest of packages to install
#Manifest: {
	packages: [address=string]: {
		"address": address
		version: string
		digest?: string
	}
}

// Fetch dependencies for a cue module
#Fetch: {
	manifest: #Manifest

	downloads: {
		for addr, pkg in manifest.packages {
			"\(addr)": {
				_isUniverse: strings.HasPrefix(addr, "universe.dagger.io")
				if _isUniverse {
					_pull: git.#Pull & {
						remote: "github.com/dagger/dagger"
						ref: pkg.version
					}
					 _subdir: core.#Subdir & {
					 	input: _pull.output
					 	path: "/pkg/\(addr)"
					 }
					output: _subdir.output
				}
				if !_isUniverse {
					git.#Pull & {
						remote: addr
						ref: pkg.version
					}
				}
			}
		}
	}

	layers: {
		for addr, dl in downloads {
			"\(addr)": core.#Copy & {
				input: dagger.#Scratch
				contents: dl.output
				dest: "/cue.mod/pkg/\(addr)/"
			}
		}
	}

	merge: core.#Merge & {
		inputs: [for _, layer in layers { layer.output }]
	}

	output: merge.output
}

dagger.#Plan & {
	actions: fetch: #Fetch & {
		manifest: packages: {
			"github.com/dagger/todoapp": version: "main"
			"universe.dagger.io/yarn": version: "main"
		}
	}
	client: filesystem: "./out": write: contents: actions.fetch.output
}
