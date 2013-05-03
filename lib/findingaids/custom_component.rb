class CustomComponent < SolrEad::Component

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c")
    t.ref_(:path=>"/c/@id")
    t.level(:path=>"/c/@level", :index_as=>[:facetable])

    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:searchable])

    # Item
    t.container {
      t.label(:path => {:attribute=>"label"})
      t.type(:path => {:attribute=>"type"})
      t.id(:path => {:attribute=>"id"})
    }
    t.container_label(:proxy=>[:container, :label])
    t.container_type(:proxy=>[:container, :type])
    t.container_id(:proxy=>[:container, :id])
  end

end