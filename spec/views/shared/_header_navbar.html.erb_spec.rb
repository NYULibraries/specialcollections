require 'spec_helper'

describe 'shared/_header_navbar.html.erb' do
  before { allow(view).to receive(:render_search_bar).and_return('') }
  it 'display header include' do
    render
    expect(rendered).to include 'href="/advanced"'
  end
end
