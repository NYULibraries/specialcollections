# Collection of helper methods for displaying subject headings in MARC and EAD.

module SubjectsHelper

  # Main method for rendering our subhect headings for display in MARC records
  def render_subjects args, results = Array.new
    if args[:document]["marc_ss"]
      format_subjects(args[:document]["marc_ss"]).each do |line|
        results << subject_array_to_links(line)
      end
    elsif args[:document][Solrizer.solr_name("subject", :displayable)]
      # We use the same method for ead for any document that has subjects listed as Term1--term2--term3
      format_ead_subjects(args[:document][Solrizer.solr_name("subject", :displayable)]).each do |line|
        results << subject_array_to_links(line)
      end
    end
    return results.join(field_value_separator).html_safe
  end

  # Main method for rendering our subhect headings for display in finding aids
  def render_ead_subjects results = Array.new
    if @document[Solrizer.solr_name("subject", :displayable)]
      format_ead_subjects(@document[Solrizer.solr_name("subject", :displayable)]).each do |line|
        results << subject_array_to_links(line)
      end
    end
    return results.join(field_value_separator).html_safe
  end

  # Creates the multipl links within a single heading
  def subject_array_to_links array, results = Array.new
    links = format_subject_links(array)
    links.each do |text, terms|
      results << subject_facet_link(tag_value_with_property(text,"keywords"), terms)
    end
    return results.join("--")
  end

  # Subject facets are arrays of terms, so we need to handle them a bit differently.
  # If there's only one term, then we just call our fact_link method, otherwise,
  # we roll our own paramters hash.
  def subject_facet_link text, terms
    if terms.count == 1
      facet_link text, Solrizer.solr_name("subject", :facetable)
    else
      new_params = Hash.new
      new_params[:action] = "index"

      # {"f"=>{Solrizer.solr_name("subject", :facetable)=>["Inductee", "Rock musicians"]}}
      new_params[:f] = Hash.new
      new_params[:f][Solrizer.solr_name("subject", :facetable)] = terms
      link_to text, new_params
    end    
  end

  # Takes an array of subject terms and returns a hash of term keys
  # and their corresponding query terms.
  # Ex:
  #   [ "Rock musicians", "England", "Biography" ]
  # results in:
  # { "Rock musicians" => ["Rock Musicians"], 
  #   "England"        => ["Rock Musicians", "England"],
  #   "Biography"      => ["Rock Musicians", "England", "Biography"]
  # }
  def format_subject_links array, results = Hash.new
    array.each_index do |i|
      if i == 0
        results[array[i]] = Array.new
        results[array[i]] << array[i]
      else
        results[array[i]] = Array.new
        (0..i).each do |ti|
          results[array[i]] << array[ti]
        end
      end
    end
    return results
  end

  # Takes the array of subject terms from our solr document and returns a 2D array
  # of terms.  Each inner array is the subject heading, split into separate strings.
  # This solr result:
  #   [ "Disc jockeys", "Music trade--United States", "Radio personalities" ]
  # Becomes:
  #   [ ["Disc jockeys"],
  #     ["Music trade", "United States"],
  #     ["Radio personalities"] ]
  #
  # From there, we can use the same methods in MarcHelper to display each subject term
  # with the correct links.
  def format_ead_subjects headings, results = Array.new
    headings.each do |heading|
      results << heading.split("--")
    end
    return results
  end

  # Takes the marc xml from marc_ss and returns a 2D array of all our subjects
  # formatted accordingly.  Fields in the subjects array are returned as arrays
  # of strings for each subfield, while fields in the namedsubjects array have their
  # a-d subfields joined into one string and all other subfields as individual strings.
  def format_subjects string, results = Array.new
    subjects      = ["610", "630", "650", "651"]
    namedsubjects = ["600", "611"]

    record = MARC::XMLReader.new(StringIO.new(string)).first
    (subjects + namedsubjects).sort.each do |i|
      record.find_all {|f| f.tag == i}.each do |field|
        if namedsubjects.include?(i)
          results << subject_field_with_name(field)
        else
          results << subject_field_without_name(field)
        end
      end
    end

    return results
  end

  # Takes one MARC::DataField and returns an array of subfields as:
  #   * $a through $d joined togeter into one string
  #   * $e through $z as individual strings
  # Example:
  #   600 10 $a Lennon, John, $d 1940-1980 $x Assassination
  # is returned as:
  #   [ "Lennon, John, 1940-1980", "Assassination"] 
  def subject_field_with_name field, results = Array.new
    results << field.collect {|x| x.value.strip.gsub(/[\.\;\:]$/,"") if ("a".."d").include?(x.code) }.join(" ").strip
    field.collect {|x| x.value.strip.gsub(/[\.\;\:]$/,"") if ("e".."z").include?(x.code) }.each do |subfield|
      results << subfield unless subfield.nil?
    end
    return results
  end

  # Takes one MARC::DataField and returns an array of each subfield.
  # Example:
  #   650  0 $a Rock musicians $z England $v Biography
  # is returned as:
  #   
  def subject_field_without_name field, results = Array.new
    field.collect {|x| x.value.strip.gsub(/[\.\;\:]$/,"") if ("a".."z").include?(x.code) }.each do |subfield|
      results << subfield unless subfield.nil?
    end
    return results
  end  


end