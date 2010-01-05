Given /^#{capture_model} is selected$/ do |name|
  select_label model(name)
end

Given /^I select #{capture_model}$/ do |name|
  select_label model(name)
end

def select_label(label)
  # To have a referer page
  visit source_label_path(label.source, label)
  visit select_source_label_path(label.source, label)
end
