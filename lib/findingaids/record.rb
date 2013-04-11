module Findingaids
  module Record
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
      return (field.first.encode Encoding.find('ASCII'), encoding_options).strip.gsub(/\A@/,'').gsub(/\A\d{4}/,'').strip
    end
    
    # Get collection name from directory
    def format_directory(field)
      return field.split("\/")[-2]
    end
  end
end