FactoryGirl.define do
  factory :solr_document do
    skip_create
    initialize_with do
      new(
      {
        id: id,
        format_ssm: format,
        unittitle_ssm: unittitle,
        abstract_ssm: abstract,
        repository_ssi: repository,
        ead_ssi: ead,
        bioghist_ssm: bioghist,
        custodhist_ssm: custodhist,
        ref_ssi: ref,
        parent_ssm: parent,
        heading_ssm: heading,
        parent_unittitles_ssm: parent_unittitles,
        collection_ssm: collection,
        score: score
        }, solr_response
        )
      end
      solr_response { create(:solr_response) }
      id { 'testead123' }
      format { ["Archival Collection"] }
      unittitle { ["The Title"] }
      abstract { "Interesting abstract" }
      repository { "fales" }
      ead { "testead" }
      bioghist { ['title'] }
      custodhist { ['publisher'] }
      ref { "123" }
      parent { nil }
      heading { ["Guide to titling finding aids"] }
      parent_unittitles { nil }
      collection { ["Bytsura Collection of Things"] }
      score { 4.944287 }
    end
  end
