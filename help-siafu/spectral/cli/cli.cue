package cli

import (
	"universe.dagger.io/x/siafudev@gmail.com/spectral"
	"list"
	"strings"
)

// Command provides a declarative interface to the spectral CLI
#Command: {
	// [documents..] lint JSON/YAML documents
	args: [...string]

	flags: {
		// Show version number
		version?: bool
		// Show help
		help?: bool
		// text encoding to use
		encoding?: string
		//formatters to use for outputting results, more than one can be given joining them with a comma
		format?: string
		// where to output results, can be a single file name, multiple "output.<format>" or missing to print to stdout
		output?: string
		// path to a file to pretend that stdin comes from
		"stdin-filepath"?: string
		// path to custom json-ref-resolver instance
		resolver?: string
		// path/URL to a ruleset file
		ruleset?: string
		// results of this level or above will trigger a failure exit code [string] [choices: "error", "warn", "info", "hint"] [default: "error"]
		"fail-severity"?: [...string]
		// only output results equal to or greater than --fail-severity
		"display-only-failures"?: bool
		// do not warn about unmatched formats
		"ignore-unknown-format"?: bool
		// fail on unmatched glob patterns
		"fail-on-unmatched-globs"?: bool
		// increase verbosity
		verbose?: bool
		// no logging - output only
		quiet?: bool
	}

	container: spectral.#Container & {
		always:       true
		_optionFlags: list.FlattenN([
				for k, v in flags {
				if (v & bool) != _|_ {
					["--\(k)"]
				}
				if (v & string) != _|_ {
					["--\(k)", v]
				}
			},
		], 1)

		command: {
			name: "/bin/sh"
			flags: "-c": strings.Join(["spectral lint"]+args+_optionFlags, " ")
		}
	}
}
