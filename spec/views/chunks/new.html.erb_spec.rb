require 'spec_helper'

describe "/chunks/new.html.erb" do
  include ChunksHelper

  let(:source) { Factory(:source) }
  let!(:chunk) { assign :chunk, source.chunks.build }

  before do
    view.stub :user_session => UserSession.new({})
  end

  it "renders new chunk form" do
    render

    response.should have_selector("form[action='#{source_chunks_path(source)}'][method=post]") do |form|
      form.should have_selector("select#chunk_begin_1i")
      form.should have_selector("select#chunk_end_1i")
    end
  end

  it "should provide a select for Chunk#begin seconds" do
    render
    response.should have_selector("select[name='chunk[begin(6i)]']")
  end

  it "should provide a select for Chunk#end seconds" do
    render
    response.should have_selector("select[name='chunk[end(6i)]']")
  end

end
