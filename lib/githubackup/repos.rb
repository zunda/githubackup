#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'json'

module GitHuBackUp
	class Repo
		attr_reader :full_name
		attr_reader :git_url

		def initialize(full_name, git_url)
			@full_name = full_name
			@git_url = git_url
		end

		def Repo.parse_json(json)
			parsed = JSON.parse(json, :create_additions => false)
			# :create_additions for CVE-2013-0269 that affects
			# Ruby 1.9 < 1.9.3p392 and Ruby 2.0 < 2.0.0p0
			# http://www.ruby-lang.org/en/news/2013/02/22/json-dos-cve-2013-0269/
			return Repo.new(parsed['full_name'], parsed['git_url'])
		end
	end

	class Repos
		def Repos.parse_json(json)
			JSON.parse(json, :create_additions => false).map{|entry|
				Repo.new(entry['full_name'], entry['git_url'])
			}
		end
	end
end
