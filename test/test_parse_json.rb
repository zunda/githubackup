#!/usr/bin/ruby
#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#

require 'json'
require 'test/unit'

class TestParseJson < Test::Unit::TestCase
	def setup
		@data_dir = File.dirname(__FILE__)
	end

	def test_parse_user_repos
		# curl https://api.github.com/users/zunda/repos > zudna-list.json
		src_json_path = File.join(@data_dir, 'zudna-list.json')
		parsed_json = JSON.parse(File.read(src_json_path))
		repos = parsed_json.map do |element|
			#[element['full_name'], element['git_url']]
			element['full_name']
		end
		assert_equal([
			"zunda/MogMogMonitor", "zunda/count-malloc",
			"zunda/devquiz2011-slidepuzzle", "zunda/fluxconv", "zunda/gist",
			"zunda/githubackup", "zunda/groonga", "zunda/hiki", "zunda/mruby",
			"zunda/organize-photos", "zunda/rnegotter", "zunda/ruby-absolutify",
			"zunda/ruby-mp3info", "zunda/ruby-nfork", "zunda/ruby-spiral",
			"zunda/sorting", "zunda/sprint-android-multiple-widgets",
			"zunda/t.co-expander", "zunda/tdiary-core",
			"zunda/zunda-momonga-pkgs"].sort,
			repos.sort
		)
	end

	def test_parse_org_repos
		# curl https://api.github.com/orgs/EdamameTech/repos > edamame-list.json
		src_json_path = File.join(@data_dir, 'edamame-list.json')
		parsed_json = JSON.parse(File.read(src_json_path))
		repos = parsed_json.map do |element|
			#[element['full_name'], element['git_url']]
			element['full_name']
		end
		assert_equal(["EdamameTech/SiestaWatch"],
			repos.sort
		)
	end

	def test_parse_user_repo
		# curl https://api.github.com/repos/zunda/githubackup > githubackup.json
		src_json_path = File.join(@data_dir, 'githubackup.json')
		parsed = JSON.parse(File.read(src_json_path))
		assert_equal("zunda/githubackup", parsed['full_name'])
		assert_equal("git://github.com/zunda/githubackup.git", parsed['git_url'])
	end

	def test_parse_org_repo
		# curl curl https://api.github.com/repos/EdamameTech/SiestaWatch > SiestaWatch.json
		src_json_path = File.join(@data_dir, 'SiestaWatch.json')
		parsed = JSON.parse(File.read(src_json_path))
		assert_equal("EdamameTech/SiestaWatch", parsed['full_name'])
		assert_equal("git://github.com/EdamameTech/SiestaWatch.git", parsed['git_url'])
	end
end
