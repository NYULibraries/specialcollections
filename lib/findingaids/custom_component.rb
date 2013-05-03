class CustomComponent < SolrEad::Component

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    #t.root(:path=>"c")
    t.ref_(:path=>"/c/@id")
    t.level(:path=>"/c/@level", :index_as=>[:facetable])

    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:displayable])
    t.unittitle(:path=>"unittitle", :index_as=>[:searchable])

    t.odd(:path=>"odd", :index_as=>[:searchable])
  end

end