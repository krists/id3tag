def mp3_fixture(filename)
  fixtures_dir = File.expand_path('../../fixtures', __FILE__)
  File.open(File.join(fixtures_dir, filename), "rb")
end
