module LabelSelectionHelper

  def class_for_label_in_selection(label_selection, label)
    case label
      when label_selection.begin : "begin"
      when label_selection.end : "end"
    end
  end

end
