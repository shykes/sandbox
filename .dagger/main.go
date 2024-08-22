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
