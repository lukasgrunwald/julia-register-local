#=
Register and update package version in specified local registry. If no new package version
is specified, do nothing.
The local registry is specified as a command line argument
=#
import Pkg

# Add local registry
Pkg.Registry.add(Pkg.RegistrySpec(; url = ARGS[1]))

# Create temporary environment and dev current repo/package
Pkg.activate(; temp = true)
Pkg.develop(path = pwd()) # Develop package at current path

# Extract package name of current repository
dep_dict = Pkg.dependencies()
package_name = (filter(x -> x[2].is_direct_dep, dep_dict) |> values |> first).name
registry_name = split(split(ARGS[1], "/")[end], ".")[1] # previously added to registries

# Add new version to local registry
Pkg.add("LocalRegistry")
import LocalRegistry: register

# Does not error when no new version of the package is specified
register(package_name; registry = registry_name, ignore_reregistration = true)
