#!/usr/bin/ruby
#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'test/unit'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'githubackup/endpoints'

class TestEndPoints < Test::Unit::TestCase
	def test_user_repos
		assert_equal('https://api.github.com/users/zunda/repos',
			GitHuBackUp::GitHubApi.user_repos('zunda'))
	end

	def test_org_repos
		assert_equal('https://api.github.com/orgs/EdamameTech/repos',
			GitHuBackUp::GitHubApi.org_repos('EdamameTech'))
	end

	def test_full_name_repo
		assert_equal('https://api.github.com/repos/zunda/githubackup',
			GitHuBackUp::GitHubApi.full_name_repo('zunda/githubackup'))
	end
	
	def test_strange_user_name
		assert_equal('https://api.github.com/users/.%2F%20zunda/repos',
			GitHuBackUp::GitHubApi.user_repos('./ zunda'))
	end
	
	def test_strange_org_name
		assert_equal('https://api.github.com/orgs/.%2F%20zunda/repos',
			GitHuBackUp::GitHubApi.org_repos('./ zunda'))
	end
	
	def test_strange_full_name
		assert_equal('https://api.github.com/repos/x.%20/%20zunda%2Fan',
			GitHuBackUp::GitHubApi.full_name_repo('x. / zunda/an'))
	end
end
