# julia-register-local Action

This action registers a new version of the package in a local registry using [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl). It requires two inputs

- `localregistry`: GitHub url (ssh/https) of local-registry to be updated by the action.
- `ssh_keys`: SSH key(s) for accessing the repos and pushing to local registry. Multiple keys by using the pipe | operator.

The commit in the local-registry is signed as `github.actor@RegisterAction`. If no new package version is specified in the commit, nothing is pushed to the local-registry. It makes sense to run this action conditionally, after the unit tests passed. 

A complete example, is shown below

```yaml
name: CI
on:
  push:
    branches:
      - master
jobs:
  test:
    # ... Run unit tests 
  register:
    needs: test # Only run this once test is completed
    name: Register Package
    runs-on: ubuntu-latest
    steps:
    - uses: lukasgrunwald/julia-register-local@v1
      with:
        localregistry: git@github.com:lukasgrunwald/CondMatRegistry.git
        ssh_keys: | # Private Deploy key of CondMatRegistry
           ${{ secrets.REGISTRY_DEPLOY }}
```

One can also split the `register` action into a separate file using the `workflow_run` syntax; see [this post](https://stackoverflow.com/questions/62750603/github-actions-trigger-another-action-after-one-action-is-completed).