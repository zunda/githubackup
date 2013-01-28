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
require 'tmpdir'
require 'fileutils'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gitcopy'

class TestGitCopy < Test::Unit::TestCase
	def test_dst_dir
		repo = GitCopy.new('c/d', 'url', '/a/b')
		assert_equal('/a/b/c/d', repo.dst_dir)
	end
	
	def test_dst_dir_with_slash
		repo = GitCopy.new('c/d', 'url', '/a/b/')
		assert_equal('/a/b/c/d', repo.dst_dir)
	end

	def test_can_pull
		# Assuming this file is a clone of a git repository
		top_dir = File.join(File.dirname(File.expand_path(__FILE__)), '..')
		full_name = File.basename(top_dir)
		root_dst_dir = File.dirname(top_dir)
		repo = GitCopy.new(full_name, 'url', root_dst_dir)
		assert(repo.can_pull?)
	end

	def test_can_not_pull
		# Assuming /var/tmp is not a clone of a git repository
		repo = GitCopy.new('tmp', 'url', '/var')
		assert(!repo.can_pull?)
	end

	def test_can_clone
		Dir.mktmpdir do |dir|
			repo = GitCopy.new('foo/bar', 'url', dir)
			assert(repo.can_clone?,  'Should be able to clone without parent directory')
			Dir.mkdir(File.join(dir, 'foo'))
			assert(repo.can_clone?, 'Should be able to clone with writable parent directory')
		end
		# TODO: check existence of dst_dir
	end

	def test_can_not_clone
		Dir.mktmpdir do |dir|
			Dir.mkdir(File.join(dir, 'foo'))
			Dir.mkdir(File.join(dir, 'foo', 'bar'))
			repo = GitCopy.new('foo/bar', 'url', dir)
			assert(!repo.can_clone?, 'Shold not be able to clone if dst_dir exists')
			Dir.rmdir(File.join(dir, 'foo', 'bar'))
			FileUtils.chmod(0500, File.join(dir, 'foo'))
			assert(!repo.can_clone?,  'Should not be able to clone if parent is not writable')
		end
	end
end