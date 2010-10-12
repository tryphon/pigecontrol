class WelcomeController < ApplicationController

  def index
    redirect_to source_chunks_path(Source.default)
  end

end
