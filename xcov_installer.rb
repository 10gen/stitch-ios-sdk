class GemRequirements
  def initialize(name, version = nil)
    @gem = Gem::Dependency.new(name, version)
  end

  def dependency_tree
    @dependency_tree ||= {}.merge(get_dependency(@gem))
  end

  private

  def get_dependency(gem_dependency)
    spec = gem_dependency.matching_specs.first
    dep_key = "gem fetch #{gem_dependency.name} -v #{spec.version}"
    system(dep_key)
    hash = { dep_key => {} }
    spec.runtime_dependencies.each do |spec_dependency|
      spec_dependency_spec = spec_dependency.matching_specs.first
      spec_dep_key = "gem fetch #{spec_dependency.name} -v #{spec_dependency_spec.version}"
      hash[dep_key][spec_dep_key] = get_dependency(spec_dependency)
    end
    hash
  end
end

r = GemRequirements.new("xcov", "1.4.2")
r.dependency_tree
