#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'open-uri'

module GitHuBackUp
	class GitHubApi
		def GitHubApi.user_repos(user)
			"https://api.github.com/users/#{url_encode(user)}/repos"
		end

		def GitHubApi.org_repos(org)
			"https://api.github.com/orgs/#{url_encode(org)}/repos"
		end

		def GitHubApi.full_name_repo(full_name)	# e.g. zunda/githubackup
			s = full_name.split(%r[/], 2)
			e = s.map{|e| url_encode(e)}.join('/')
			"https://api.github.com/repos/#{e}"
		end

		def GitHubApi.url_encode(str)
			URI::encode(str).gsub(%r[/], '%2F')
		end
	end
end
