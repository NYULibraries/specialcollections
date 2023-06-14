module Findingaids
  class Repositories
    include Enumerable

    def self.repositories
      return @repositories if @repositories

      # This code allows the values from the YAML file to be overridden based on
      # whether or not the FINDINGAIDS_2022_MIGRATION environment variable is set

      # load repositories.yml file
      yaml_contents = YAML.load_file( File.join(Rails.root, "config", "repositories.yml") )

      # extract legacy repositories
      @repositories = yaml_contents["Catalog"]["repositories"]

      # override repositories if needed
      if ENV['FINDINGAIDS_2022_MIGRATION']
        @repositories.merge!(yaml_contents["CatalogOverride"]["repositories"])
      end

      @repositories
    end

    extend Forwardable
    def_delegator self, :each
  end
end
