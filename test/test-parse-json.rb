#!/usr/bin/ruby
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

end
