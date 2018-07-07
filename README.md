# ID3Tag
Native Ruby ID3 tag reader that aims for 100% coverage of ID3v2.x and ID3v1.x standards

## Install

Make sure you are using ruby 2.2 or greater

Install ID3Tag at the command prompt:
```
gem install id3tag
```

Or add the gem to your Gemfile:
```
gem 'id3tag', '~> 0.11.0'
```

## How to use

Require the libary and read basic metadata:
```ruby
require "id3tag"

mp3_file = File.open('/path/to/your/favorite_song.mp3', "rb")
tag = ID3Tag.read(mp3_file)
puts "#{tag.artist} - #{tag.title}"
```
`ID3Tag::Tag` class provides easy accessors to frames like `artist`, `title`, `album`, `year`, `track_nr`, `genre`, `comments` but you can read any frame by using `get_frame(id)` or `get_frames(id)` or browsing all frames by calling `frames`.
When using easy accessors to frames like `artist` the reader will look for v.2.x tags artist frame first and if it can not find it artist frame from v1.x will be returned (if v1.x tag exists)

There can be more than one `comments` frame in the tag. They differ by language, too access specific comment frame an extra argument can be passed (Default is english). For example `tag.comments(:lav)` will look for comments in Latvian. Language codes can be seen here: `https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes`

```ruby
mp3s = Dir.entries("/some/dir").select { |filename| filename =~ /\.mp3/i }

mp3s.each do |file|
  ID3Tag.read(File.open(file, "rb")) do |tag|
    puts file
    puts tag.artist
    puts tag.title
    puts tag.album
    puts tag.year
    puts tag.track_nr
    puts tag.genre
    puts "---"
    puts tag.get_frame(:TIT2).content
    puts tag.get_frames(:COMM).first.content
    puts tag.get_frames(:COMM).last.language
  end
end
```
By default `ID3Tag` reads both v1.x and v2.x tags but it is possible to specify only one of them:
```ruby
ID3Tag.read(file,:all) # default behaviour
ID3Tag.read(file,:v1) # Reads only v1.x tag
ID3Tag.read(file,:v2) # Reads only v2.x tag
```

You can inspect tag by calling `frame_ids` to see available frame ids or `frames` to return all frames

## Configuration


```ruby
# Configuration could be set using a block syntax.
ID3Tag.configuration do |c|

  # This way you can avoid Encoding::InvalidByteSequenceError when tag contains invalid data.
  # Currently only for String#encode which is used in TextFrames.
  # default: {} 
  c.string_encode_options = { :invalid => :replace, :undef => :replace }
  
  # You might want to set v2.x tag read limit in bytes to avoid reading too much data into memory
  # v2 tags will be extracted until end of tag or limit is reached.
  # default: 0 (There are no limit) 
  c.v2_tag_read_limit = 1048576 # 1 megabyte
  
end

ID3Tag.configuration.v2_tag_read_limit # 1048576

ID3Tag.configuration.v2_tag_read_limit = 1024

ID3Tag.configuration.v2_tag_read_limit # 1024


# In case you would like to set configuration temporally you could use `local_configuration` method.
# Within this block you can read and modify configuration and it wont affect global or layers above.

ID3Tag.local_configuration do
  ID3Tag.configuration.v2_tag_read_limit # 1024
  ID3Tag.configuration.v2_tag_read_limit = 9999
  # ...
  ID3Tag.configuration.v2_tag_read_limit # 9999 
end

ID3Tag.configuration.v2_tag_read_limit # 1024

ID3Tag.reset_configuration # Resets global configuration to defaults

ID3Tag.configuration.v2_tag_read_limit # 0
```


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
[![Code Climate](https://codeclimate.com/github/krists/id3tag.svg)](https://codeclimate.com/github/krists/id3tag) [![Build Status](https://travis-ci.org/krists/id3tag.svg?branch=master)](https://travis-ci.org/krists/id3tag) [![Coverage Status](https://coveralls.io/repos/krists/id3tag/badge.svg?branch=master)](https://coveralls.io/r/krists/id3tag) [![Gem Version](https://badge.fury.io/rb/id3tag.svg)](http://badge.fury.io/rb/id3tag)
## Copyright

Copyright (c) 2018 Krists Ozols. See LICENSE.txt for
further details.
