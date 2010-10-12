require 'factory_girl'

# FIXME workaround to initialize factory_girl correctly in bundle environment
Factory.definition_file_paths = [ File.join(RAILS_ROOT, 'spec', 'factories') ]
Factory.find_definitions
