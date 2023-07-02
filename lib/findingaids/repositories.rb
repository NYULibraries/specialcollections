module Findingaids
  class Repositories
    include Enumerable

    def self.repositories
      repositories_yaml_file = ENV['FINDINGAIDS_2022_MIGRATION'] ? "repositories-findingaids_2022_migration.yml" : "repositories.yml"

      @repositories ||= YAML.load_file( File.join(Rails.root, "config", repositories_yaml_file) )["Catalog"]["repositories"]
    end

    extend Forwardable
    def_delegator self, :each
  end
end
