package main

import (
	"context"
	"dagger/sandbox/internal/dagger"
)

type Sandbox struct{}

func (m *Sandbox) Build(source *dagger.Directory) *dagger.Container {
	return dag.Container().From("alpine").WithDirectory("/src", source).WithWorkdir("/src")
}

func (m *Sandbox) Test(ctx context.Context, source *dagger.Directory) (string, error) {
	return m.Build(source).WithExec([]string{"echo", "success"}).Stdout(ctx)
}

func (m *Sandbox) CIConfig() *dagger.Directory {
	return dag.Gha(dagger.GhaOpts{
		DaggerVersion: "v0.12.5",
	}).
		WithPipeline("Test", "test --source=.", dagger.GhaWithPipelineOpts{
			Secrets:               []string{"DEPLOY_SERVER_PASSWORD"},
			OnPush:                true,
			OnPullRequestBranches: []string{"main"},
		}).
		Config()
}
