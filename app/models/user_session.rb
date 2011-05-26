class UserSession < UserInterface::UserSession

  def label_selection
    @label_selection ||= LabelSelection.new(session[:label_selection]).on_change do |labels|
      session[:label_selection] = labels.collect(&:id)
    end
  end

end
