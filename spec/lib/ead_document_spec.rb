require 'spec_helper'

describe Findingaids::Ead::Document do

  let(:document) do
    Findingaids::Ead::Document.from_xml(ead_fixture("ead_sample.xml"))
  end
  
  describe "#to_solr" do

    let(:solr_doc) { document.to_solr }

    it { expect(solr_doc["id"]).to eql("bytsura") }
    it { expect(solr_doc[Solrizer.solr_name("unitdate", :displayable)]).to include "Inclusive, 1981-2012 ; Bulk, 1989-1997" }
    it { expect(solr_doc[Solrizer.solr_name("contributors", :displayable)]).to include "Bytsura, Bill" }
    it { expect(solr_doc[Solrizer.solr_name("name", :facetable)]).to include "Bytsura, Bill" }
    it { 
      expect(solr_doc[Solrizer.solr_name("heading", :displayable)]).to include "Guide to the Bill Bytsura ACT UP Photography Collection (MSS 313)" 
    }
    it { expect(solr_doc[Solrizer.solr_name("subject", :facetable)]).to include "ACT UP (Organization)" }
    it { expect(solr_doc[Solrizer.solr_name("title", :displayable)]).to include "Bill Bytsura ACT UP Photography Collection" }
    it { expect(solr_doc[Solrizer.solr_name("title_filing", :sortable)]).to include "Bill Bytsura ACT UP Photography Collection" }
          
  end
  
end