# -*- coding: utf-8 -*-
module LabelsHelper

  class EndpointSelector

    attr_accessor :label, :label_selection, :endpoint, :helper

    def initialize(label, label_selection, endpoint, helper)
      @label, @label_selection, @endpoint, @helper = label, label_selection, endpoint.to_sym, helper
    end

    def can_be_endpoint?
      label_selection.send "can_#{endpoint}?", label
    end

    def endpoint?
      label_selection.send(endpoint) == label
    end

    def link_to
      helper.link_to_if link?, image_tag, path, :title => title
    end

    def title
      "Sélectionner ce repère comme #{(begin? ? 'début' : 'fin')}"
    end

    def link?
      can_be_endpoint? and not label_selection.include?(label)
    end

    def path
      helper.send :select_source_label_path, label.source, label
    end

    def image_tag
      helper.image_tag "#{image_name}.png", :alt => image_alt
    end

    def image_name
      if endpoint?
        endpoint.to_s
      elsif can_be_endpoint?
        "#{endpoint}-gray"
      else
        "#{endpoint}-shadow"
      end
    end

    def image_alt
      begin? ? "&#8249;" : "&#8250;"
    end

    def begin?
      endpoint == :begin
    end

  end

  def link_to_select_label(label, label_selection = LabelSelection.new)
    [:begin, :end].collect do |endpoint|
      EndpointSelector.new label, label_selection, endpoint, self
    end.collect(&:link_to).join(' ')
  end

end
