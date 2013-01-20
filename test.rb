#!/usr/bin/ruby

require 'json'

# curl https://api.github.com/users/zunda/repos > zudna-list.json
data = JSON.parse(File.open('zudna-list.json').read)
p data
