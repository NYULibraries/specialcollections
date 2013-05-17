module Findingaids
  module Document
    
    # Config mapping for linking to specific pages from found text in Solr fields
    LINK_FIELDS = {
      :abstract => ["abstract_t"],
      :admininfo => ["custodhist_t","sponsor_t","acqinfo_t","phystech_t","index_t"],
      :dsc => ["odd_t","unittitle_t"]
    }
    # Always show these fields on the index catalog view
    DEFAULT_INDEX_FIELDS = ["title_unstem_search","publisher_unstem_search","abstract_t"]
    
    # Takes the publisher string from EAD and
    # * Strips non-ascii characters such as &copy;
    # * Strips leading @ sign which is sometimes erroneously instead of a copyright
    # * Strip leading year from publisher
    def format_publisher(field)
      encoding_options = {
       :invalid           => :replace,  # Replace invalid byte sequences
       :undef             => :replace,  # Replace anything not defined in ASCII
       :replace           => '',        # Use a blank for those replacements
       :universal_newline => true       # Always break lines with \n
      }
      return (field.first.encode Encoding.find('ASCII'), encoding_options).strip.gsub(/\A@/,'').strip.gsub(/\A\d{4}/,'').strip
    end
    
    # Pulls the repository from the directory title when indexing from the rake task
    def format_repository
      if ENV['DIR'].present?
        return ENV['DIR'].split("\/")[-1]
      elsif ENV['FILE'].present?
        return ENV['FILE'].split("\/")[-2]
      end
    end
    
    # Create formatted heading from guide title and number
    def format_heading(title, title_num)
      "Guide to the #{title.first} (#{title_num.first})"
    end
    
  end
end
