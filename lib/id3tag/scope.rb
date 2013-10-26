module ID3Tag
  class Scope
    UnsupportedScopeError = Class.new(ArgumentError)
    SUPPORTED_SCOPES = [:v1, :v2, :all]

    def initialize(version)
      raise UnsupportedScopeError unless SUPPORTED_SCOPES.include?(version)
      @included_versions = [version]
      @included_versions << :v1 << :v2 if version == :all
    end

    def include?(version)
      @included_versions.include?(version)
    end
  end
end
