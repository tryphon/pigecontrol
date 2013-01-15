class Box::Release

  def self.open(release_id, &block)
    release_file = Box::Release.send "#{release_id}_url"
    Box::Release.send(release_id).tap do |release|
      yield release

      File.open(release_file, "w") do |f|
        f.write release.to_yaml
      end
    end
  end

end

Given /^the (current|latest) release is "([^\"]*)"$/ do |release_id, name|
  Box::Release.open release_id do |release|
    release.name = name
  end
end

Given /^the new release is downloaded$/ do 
  Box::Release.latest.change_status :downloaded
end

Given /^a new release is available$/ do 
  Box::Release.open :latest do |release|
    release.name = Box::Release.current.name.succ
  end
end
