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
	def mimic_git_clone(to_dir)
		FileUtils.mkdir_p(File.join(to_dir, '.git'))
	end

	def test_dst_dir
		repo = GitCopy.new('c/d', 'url', '/a/b')
		assert_equal('/a/b/c/d', repo.dst_dir)
	end
	
	def test_dst_dir_with_slash
		repo = GitCopy.new('c/d', 'url', '/a/b/')
		assert_equal('/a/b/c/d', repo.dst_dir)
	end

	def test_on_cloned_dir
		Dir.mktmpdir do |dir|
			full_name = 'a/b'
			mimic_git_clone(File.join(dir, full_name))
			repo = GitCopy.new(full_name, 'url', dir)
			assert(repo.can_pull?)
			assert(!repo.can_clone?)
		end
	end

	def test_on_normal_dir
		Dir.mktmpdir do |dir|
			repo = GitCopy.new('a/b', 'url', dir)
			assert(!repo.can_pull?)
			assert(repo.can_clone?, 'Should be able to clone without parent dir')
		end
	end

	def test_can_clone
		Dir.mktmpdir do |dir|
			repo = GitCopy.new('foo/bar', 'url', dir)
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
