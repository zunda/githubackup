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
require 'uri'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'githubackup/copy'

class TestCopy < Test::Unit::TestCase
	def mimic_git_mirror(to_dir)
		FileUtils.mkdir_p(to_dir)
		GitHuBackUp::Copy::FILES_IN_MIRROR.each do |f|
			FileUtils.touch(File.join(to_dir, f))
		end
		GitHuBackUp::Copy::DIRS_IN_MIRROR.each do |d|
			FileUtils.mkdir_p(File.join(to_dir, d))
		end
	end

	def test_dst_dir
		repo = GitHuBackUp::Copy.new('full_name', 'git://host/c/d.git', '/a/b')
		assert_equal('/a/b/c/d.git', repo.dst_dir)
	end
	
	def test_dst_dir_with_slash
		repo = GitHuBackUp::Copy.new('full_name', 'git://host/c/d.git', '/a/b/')
		assert_equal('/a/b/c/d.git', repo.dst_dir)
	end

	def test_on_dst_dir
		Dir.mktmpdir do |dir|
			repo = GitHuBackUp::Copy.new('a/b', 'url', File.join(dir, 'foo'))
			assert(!repo.can_clone?, 'Should not be able to clone without parent')
		end
	end

	def test_on_dst_dir_not_writable
		Dir.mktmpdir do |dir|
			root_dst_dir = File.join(dir, 'foo')
			Dir.mkdir(root_dst_dir)
			FileUtils.chmod(0500,  root_dst_dir)
			repo = GitHuBackUp::Copy.new('a/b', 'url', root_dst_dir)
			assert(!repo.can_clone?, 'Should not be able to clone without parent')
		end
	end

	def test_on_cloned_dir
		Dir.mktmpdir do |dir|
			path = '/a/b'
			url = "git:#{path}"
			mimic_git_mirror(File.join(dir, path))
			repo = GitHuBackUp::Copy.new('full_name', url, dir)
			assert(repo.can_fetch?, 'Should be able to fetch')
			assert(!repo.can_clone?, 'Should not be able to clone')
		end
	end

	def test_on_normal_dir
		Dir.mktmpdir do |dir|
			path = '/a/b'
			url = "git:#{path}"
			repo = GitHuBackUp::Copy.new('full_name', url, dir)
			assert(!repo.can_fetch?, 'Should not be able to fetch')
			assert(repo.can_clone?, 'Should be able to clone without parent dir')

			Dir.mkdir(File.join(dir, 'a'))
			assert(!repo.can_fetch?)
			assert(repo.can_clone?, 'Should be able to clone with parent dir')

			Dir.mkdir(File.join(dir, 'a', 'b'))
			assert(!repo.can_fetch?)
			assert(!repo.can_clone?, 'Should not be able to clone to existing dir')
			Dir.rmdir(File.join(dir, 'a', 'b'))

			FileUtils.chmod(0500,  File.join(dir, 'a'))
			assert(!repo.can_clone?,  'Should not be able to clone if parent is not writable')
		end
	end
	
	def test_update_with_git_fetch
		repo = GitHuBackUp::Copy.new('user/repo', 'git:/user/repo.git', '/dstdir')
		class << repo
			def can_fetch?; true; end
		end
		assert_equal("cd '/dstdir/user/repo.git'; git fetch -v; cd -", repo.update_cmd)
	end

	def test_update_with_git_clone_without_mkdir
		Dir.mktmpdir do |dir|
			repo = GitHuBackUp::Copy.new('user/repo', 'git:/user/repo.git', dir)
			Dir.mkdir(File.join(dir, 'user'))
			assert_equal("cd '#{dir}/user'; git clone --mirror 'git:/user/repo.git'; cd -", repo.update_cmd)
		end
	end

	def test_update_with_git_clone_with_mkdir
		Dir.mktmpdir do |dir|
			repo = GitHuBackUp::Copy.new('full_name', 'git:/user/repo.git', dir)
			assert_equal("mkdir -p '#{dir}/user'; cd '#{dir}/user'; git clone --mirror 'git:/user/repo.git'; cd -", repo.update_cmd)
		end
	end

	def test_update_error
		repo = GitHuBackUp::Copy.new('user/repo', 'git:/user/repo.git', '/dstdir')
		class << repo
			def can_fetch?; false; end
			def can_clone?; false; end
		end
		assert_raise GitHuBackUp::CopyError do
			repo.update_cmd
		end
	end

	def test_vaildate_uri
		['git:/.', 'git:/..', 'git:/./a', 'git:/../a', 'git://host'].each do |uri|
			assert_nothing_raised do
				URI.parse(uri)
			end
			assert_raise GitHuBackUp::ValidationError do
				GitHuBackUp::Copy.new('full_name', uri, '/dstdir')
			end
		end
		assert_raise GitHuBackUp::ValidationError do
			GitHuBackUp::Copy.new('full_name', 'git:', '/dstdir')
		end
	end
end
