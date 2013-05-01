# ID3Tag
Native Ruby ID3 tag reader that aims for 100% covarage of ID3v2.x and ID3v1.x standards

## Install

Make sure you are using ruby 1.9.2 or greater

Install ID3Tag at the command prompt:
```
gem install id3tag
```

Or add the gem to your Gemfile:
```
gem 'id3tag'
```

## How to use

Require the libary and read basic metadata:
```ruby
require "id3tag"

mp3_file = File.open('/path/to/your/favorite_song.mp3')
tag = ID3Tag.read(mp3_file)
puts "#{tag.artist} - #{tag.title}"
```
`ID3Tag::Tag` class provides easy accessors to frames like `artist`, `title`, `album`, `year`, `comments`, `track_nr`, `genre` but you can read any frame by using `get_frame` or `get_frame_content`.

```ruby
mp3s = Dir.entries("/some/dir").select { |filename| filename =~ /\.mp3/i }

mp3s.each do |file|
  ID3Tag.read(File.open(file)) do |tag|
    puts file
    puts tag.artist
    puts tag.title
    puts tag.album
    puts tag.year
    puts tag.comments
    puts tag.track_nr
    puts tag.genre
    puts "---"
    puts tag.get_frame_content(:TIT2)
  end
end
```
You can inspect tag by calling `frame_ids` to see available frame ids or `frames` to return all frames

## Features

* Can read v1.x, v2.2.x, v2.3.x, v2.4.x tags
* Supports UTF-8, UTF-16, UTF-16BE and ISO8859-1 encoding


## Contributing to id3tag
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Code Status
[![Code Climate](https://codeclimate.com/github/krists/id3tag.png)](https://codeclimate.com/github/krists/id3tag) [![Build Status](https://travis-ci.org/krists/id3tag.png?branch=master)](https://travis-ci.org/krists/id3tag) [![Coverage Status](https://coveralls.io/repos/krists/id3tag/badge.png?branch=master)](https://coveralls.io/r/krists/id3tag)

## Copyright

Copyright (c) 2013 Krists Ozols. See LICENSE.txt for
further details.

