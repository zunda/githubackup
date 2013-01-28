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
require 'gitcopy'

class TestGitCopy < Test::Unit::TestCase
	def test_dst_dir
		repo = GitCopy.new('c/d', 'uri', '/a/b')
		assert_equal('/a/b/c/d', repo.dst_dir)
	end
	
	def test_dst_dir_with_slash
		repo = GitCopy.new('c/d', 'uri', '/a/b/')
		assert_equal('/a/b/c/d', repo.dst_dir)
	end
end
