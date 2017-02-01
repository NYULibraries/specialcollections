class Items
  attr_reader :config, :source, :destination

  def initialize(config: nil, source: nil, destination: nil)
    @config = config || Rails.root.join('config', 'jekyll.yml').to_s
    @source = source || Rails.root.join('items').to_s
    @destination = destination || Rails.root.join('public', 'items').to_s
  end

  def generate_static_pages
    # generate the site
    Jekyll::Site.new(
      Jekyll.configuration({
        "config" => config,
        "source" => source,
        "destination" => destination
      })
    ).process
  end
end
