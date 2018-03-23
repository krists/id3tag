```ruby
file = File.open(path, 'rb')
tag = ID3Tag.read(file)


# --------------------------------------


tag.current.genre # => "Pop"
tag.current.versions => ["v1", "v2.3"]

tag.next.genre # => "Pop"
tag.next.genre = "Metal" # => "Metal"
tag.next.genre # => "Metal"
tag.next.content # => "binary tag data"
tag.next.save

tag.next.frames # => [..]

tag.next.remove(:v1)
tag.next.remove(:v2)

ID3Tag.remove(:v1, file)
ID3Tag.remove(:v2, file)

tag.next(:v1).remove
tag.next(:v2) do |t|
  tag.genre = "Metal"
end

tag.next(:v1).assign_values_from(tag.next(:v2))


```