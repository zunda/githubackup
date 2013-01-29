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
require 'githubackup/repos'

class TestRepos < Test::Unit::TestCase
	def setup
		@data_dir = File.dirname(__FILE__)
	end

	def name_and_uri(names)
			return names.map{|e| [e, "git://github.com/#{e}.git"]}
	end

	def test_parse_user_repos
		src_json_path = File.join(@data_dir, 'zudna-list.json')
		repos = GitHub::Repos.parse_json(File.read(src_json_path))
		assert_equal(name_and_uri([
			"zunda/MogMogMonitor", "zunda/count-malloc",
			"zunda/devquiz2011-slidepuzzle", "zunda/fluxconv", "zunda/gist",
			"zunda/githubackup", "zunda/groonga", "zunda/hiki", "zunda/mruby",
			"zunda/organize-photos", "zunda/rnegotter", "zunda/ruby-absolutify",
			"zunda/ruby-mp3info", "zunda/ruby-nfork", "zunda/ruby-spiral",
			"zunda/sorting", "zunda/sprint-android-multiple-widgets",
			"zunda/t.co-expander", "zunda/tdiary-core",
			"zunda/zunda-momonga-pkgs"]).sort,
			repos.entries.map{|e| [e.full_name, e.git_url]}.sort
		)
	end

	def test_parse_org_repos
		src_json_path = File.join(@data_dir, 'edamame-list.json')
		repos = GitHub::Repos.parse_json(File.read(src_json_path))
		assert_equal(name_and_uri(["EdamameTech/SiestaWatch"]).sort,
			repos.entries.map{|e| [e.full_name, e.git_url]}.sort
		)
	end

	def test_parse_user_repo
		src_json_path = File.join(@data_dir, 'githubackup.json')
		parsed = GitHub::Repos.parse_json(File.read(src_json_path))
		assert_equal(name_and_uri(["zunda/githubackup"]).sort,
			parsed.entries.map{|e| [e.full_name, e.git_url]}.sort
		)
	end

	def test_parse_org_repo
		src_json_path = File.join(@data_dir, 'SiestaWatch.json')
		parsed = GitHub::Repos.parse_json(File.read(src_json_path))
		assert_equal(name_and_uri(["EdamameTech/SiestaWatch"]).sort,
			parsed.entries.map{|e| [e.full_name, e.git_url]}.sort
		)
	end

	def test_add_repos
		repos = GitHub::Repos.new
		[ 'githubackup.json', 'SiestaWatch.json'].each do |file|
			src_json_path = File.join(@data_dir, file)
			repos.parse_json(File.read(src_json_path))
		end
		assert_equal(
			name_and_uri(["zunda/githubackup", "EdamameTech/SiestaWatch"]).sort,
			repos.entries.map{|e| [e.full_name, e.git_url]}.sort
		)
	end
end
