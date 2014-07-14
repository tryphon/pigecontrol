# use require to load any .js file available to the asset pipeline
#= require chunks

describe "PendingChunkObserver", ->
  # loadFixtures 'chunks_show' # located at 'spec/javascripts/fixtures/example_fixture.html.haml'

  describe "#json_url", ->
    it "should add .json to link", ->
      expect(new PendingChunkObserver("/dummy").json_url()).toEqual("/dummy.json")

  # it "it is not bar", ->
  #   v = new Foo()
  #   expect(v.bar()).toEqual(false)
