require 'rails_helper'

describe 'catalog/index.html.erb' do
  before { allow(view).to receive(:has_search_parameters?).and_return(false) }
  it 'display home page' do
    render
    expect(rendered).to include 'What Are Special Collections?'
  end
end
