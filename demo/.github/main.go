package main

import (
	"dagger/ci/internal/dagger"
)

type Ci struct{}

// Returns a container that echoes whatever string argument is provided
func (m *Ci) Generate() *dagger.Directory {
	return dag.Gha().WithPipeline(
		"Hello",
		"hello --name $GITHUB_OWNER",
		dagger.GhaWithPipelineOpts{
			Module:        "github.com/shykes/hello",
			OnPullRequest: true,
			OnPush:        true,
		},
	).Config()
}
