require 'factory_girl'

# FIXME workaround to initialize factory_girl correctly in bundle environment
Factory.definition_file_paths = [ File.join(Rails.root, 'spec', 'factories') ]
Factory.find_definitions
