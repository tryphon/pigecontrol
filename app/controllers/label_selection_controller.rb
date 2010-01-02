class LabelSelectionController < ApplicationController

  def destroy
    user_session.label_selection.clear
    redirect_to :back
  end

end
