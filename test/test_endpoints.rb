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
			GitHubApi.user_repos('zunda'))
	end

	def test_org_repos
		assert_equal('https://api.github.com/orgs/EdamameTech/repos',
			GitHubApi.org_repos('EdamameTech'))
	end

	def test_full_name_repo
		assert_equal('https://api.github.com/repos/zunda/githubackup',
			GitHubApi.full_name_repo('zunda/githubackup'))
	end
end
