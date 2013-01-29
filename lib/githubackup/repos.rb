#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'json'

module GitHub
	class Repo
		attr_reader :full_name
		attr_reader :git_url

		def initialize(full_name, git_url)
			@full_name = full_name
			@git_url = git_url
		end

		def Repo.parse_json(json)
			parsed = JSON.parse(json)
			return Repo.new(parsed['full_name'], parsed['git_url'])
		end
	end

	class Repos
		attr_reader :entries

		def initialize
			@entries = Array.new
		end

		def parse_json(json)
			parsed = JSON.parse(json)
			@entries += parsed.map{|entry|
				Repo.new(entry['full_name'], entry['git_url'])
			}
		end

		def Repos.parse_json(json)
			r = Repos.new
			r.parse_json(json)
			r
		end
	end
end
