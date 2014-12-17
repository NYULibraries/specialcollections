module Findingaids
  class Repositories
    include Enumerable

    def self.repositories
      @repositories ||= YAML.load_file( File.join(Rails.root, "config", "repositories.yml") )["Catalog"]["repositories"].with_indifferent_access
    end

    extend Forwardable
    def_delegator self, :each
  end
end
