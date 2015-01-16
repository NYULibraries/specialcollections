require 'spec_helper'

describe Findingaids::Ead::Document do

  let(:document) { Findingaids::Ead::Document.from_xml(ead_fixture("ead_sample.xml")) }

  describe "#to_solr" do

    let(:solr_doc) { document.to_solr }

    it { expect(solr_doc["id"]).to eql("bytsura") }
    it { expect(solr_doc[Solrizer.solr_name("heading", :displayable)]).to include "Guide to the Bill Bytsura ACT UP Photography Collection (MSS 313)" }
    it { expect(solr_doc[Solrizer.solr_name("subject", :facetable)]).to include "ACT UP (Organization)" }
    it { expect(solr_doc[Solrizer.solr_name("title", :displayable)]).to include "Bill Bytsura ACT UP Photography Collection" }
    it { expect(solr_doc[Solrizer.solr_name("title_filing", :sortable)]).to include "Bill Bytsura ACT UP Photography Collection" }

    describe "creator facet" do
      it { expect(solr_doc[Solrizer.solr_name("creator", :facetable)]).to eql ["Belfrage, Sally, 1936-", "Bytsura, Bill", "Component Level Name", "Kings County (N.Y.). Board of Supervisors.", "Lefferts family"] }
    end

    describe "date display" do
      context "when there is a valid date" do
        it { expect(solr_doc[Solrizer.solr_name("unitdate", :displayable)]).to include "Inclusive, 1981-2012 ; Bulk, 1989-1997" }
      end

      context "when there is no valid date" do
        let(:document) { Findingaids::Ead::Document.from_xml(ead_fixture("ead_template.xml")) }
        it { expect(solr_doc[Solrizer.solr_name("unitdate", :displayable)]).to include "sample date" }
      end
    end

  end

end
