module Findingaids::Ead::Behaviors
  module Dates

    DATE_RANGES = [
      { display: "1101-1200", start_date: 1101, end_date: 1200 },
      { display: "1201-1300", start_date: 1201, end_date: 1300 },
      { display: "1301-1400", start_date: 1301, end_date: 1400 },
      { display: "1401-1500", start_date: 1401, end_date: 1500 },
      { display: "1501-1600", start_date: 1501, end_date: 1600 },
      { display: "1601-1700", start_date: 1601, end_date: 1700 },
      { display: "1701-1800", start_date: 1701, end_date: 1800 },
      { display: "1801-1900", start_date: 1801, end_date: 1900 },
      { display: "1901-2000", start_date: 1901, end_date: 2000 },
      { display: "2001-2100", start_date: 2001, end_date: 2100 }
    ]
    UNDATED = "undated & other"

    # Return an array of Date Range facets where unit dates fall in the range
    # add undated text if date falls outside known range
    def get_date_range_facets(date_ranges = Array.new)
      # Add
      DATE_RANGES.each do |date_range|
        date_ranges << date_range[:display] if self.unitdate_normal.any? {|unitdate| in_range?(unitdate, date_range) }
      end
      # Do some array magic here to add the UNDATED text to the date_ranges
      # if NOT all of the unitdates fall within the predetermined ranges
      # or if the array is empty
      date_ranges << UNDATED if date_ranges.empty? || !self.unitdate_normal.all? {|unitdate| DATE_RANGES.any? {|date_range| in_range?(unitdate, date_range) } }
      return date_ranges
    end

    # Determine if a unitdate (i.e. 1900/1910) is in a given range hash
    #
    # Ex. in_range?("1900/1910", { start_date: 1900, end_date: 1902 }) => true
    # =>  in_range?("1900/1910", { start_date: 2000, end_date: 2100 }) => false
    def in_range?(unitdate, date_range)
      begin
        (unitdate_start(unitdate).to_i >= date_range[:start_date] &&
          unitdate_start(unitdate).to_i <= date_range[:end_date]) ||
        (unitdate_end(unitdate).to_i >= date_range[:start_date] &&
          unitdate_end(unitdate).to_i <= date_range[:end_date])
      rescue
        false
      end
    end

    # Set start and end dates from each normalized unit date
    def ead_unitdate_fields(fields = Hash.new)
      start_dates, end_dates = [], []
      unless self.unitdate_normal.nil?
        self.unitdate_normal.each do |unitdate|
          start_dates << unitdate_start(unitdate)
          end_dates << unitdate_end(unitdate)
        end
        Solrizer.set_field(fields, "unitdate_start", start_dates.compact, :facetable, :displayable, :sortable)
        Solrizer.set_field(fields, "unitdate_end", end_dates.compact, :facetable, :displayable, :sortable)
      end
      return fields
    end

    # Split unitdate normal formatted 1900/1910 into an array
    #
    # Ex. unitdate_parts("1900/1910") => ["1900","1910"]
    def unitdate_parts(unitdate_normal)
      unless unitdate_normal.blank? || /(\d{4})\/(\d{4})/.match(unitdate_normal).nil?
        unitdate_normal.split(/\//)
      else
        []
      end
    end

    # Get the start date from a split array of date parts
    def unitdate_start(unitdate)
      unitdate_parts(unitdate).first
    end

    # Get the end date from a split array of date parts
    def unitdate_end(unitdate)
      unitdate_parts(unitdate).last
    end

    # Formats multiple data fields into a single field for display
    def ead_date_display(parts = Array.new)
      unless self.unitdate.empty?
        parts << self.unitdate
      else
        unless self.unitdate_inclusive.empty? and self.unitdate_bulk.empty?
          parts << "Inclusive,"
          parts << self.unitdate_inclusive
          unless self.unitdate_bulk.empty?
            parts << ";"
            parts << self.unitdate_bulk
          end
        end
      end
      return parts.join(" ")
    end
  end
end
