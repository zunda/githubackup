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
		def Repos.parse_json(json)
			JSON.parse(json).map{|entry|
				Repo.new(entry['full_name'], entry['git_url'])
			}
		end
	end
end
