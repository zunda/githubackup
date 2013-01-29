#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#

class GitHubApi
	def GitHubApi.user_repos(user)
		"https://api.github.com/users/#{user}/repos"
	end

	def GitHubApi.org_repos(org)
		"https://api.github.com/orgs/#{org}/repos"
	end

	def GitHubApi.full_name_repo(full_name)	# e.g. zunda/githubackup
		"https://api.github.com/repos/#{full_name}"
	end
end
