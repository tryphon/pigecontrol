Before { 
  FileUtils.mkdir_p "tmp/releases"

  Box::Release.latest_url = "tmp/releases/latest.yml"
  FileUtils.cp "public/updates/latest.yml", Box::Release.latest_url

  Box::Release.current_url = "tmp/releases/current.yml"
  FileUtils.cp "public/current.yml", Box::Release.current_url

  Box::Release.install_command = "/bin/true"
  Box::Release.status_directory = Box::Release.download_directory = "tmp/releases"
}

After { 
  FileUtils.rm_rf "tmp/releases"
}
