#!/usr/bin/ruby
#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'open-uri'
require 'fileutils'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gitcopy'
require 'githubrepos'

root_dir = File.join(File.expand_path('.') , File.basename(__FILE__, '.rb'))
puts "Copying or updating repositories under #{root_dir}"
FileUtils.mkdir_p(root_dir)

api_url = 'https://api.github.com/users/zunda/repos'
repos = GitHub::Repos.parse_json(open(api_url).read)
repos.entries[0..2].each do |repo|
	GitCopy.update(repo.full_name, repo.git_url, root_dir)
end

