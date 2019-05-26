# Zine Changelog

## Pre 0.0.1

- set up the blog & repos
- set up bundler, rspec tests
- Thor for the menu & as a generator
- YAML options
- have a Site object pushing file names to Page objects
- Kramdown
- played with cucumber for a while but decided not to use it, it's a DSL too far.
- Slim, then dropped Slim, back with ERB - translation was going to take too long
- added HTML compression, even though the difference is only around 1kb a page
- ERB partials
- working posts & tags
- replaced Colorize with Rainbow
- replaced ERB::Util with a slug name generator
- added dates to tag lists
- copies files that aren't Markdown or templates to the build directory, preserving the folder structure
- a simple WEBrick server for preview, with SSL, then
- WEBrick swapped out for Thin - WEBrick's been ridiculously slow
- DataPage class carved out of Page
- home & all tags index pages
- more serious site & page class refactoring
- pages that aren't blog posts (eg about)
- started into RSS/Atom feeds, and the standard library docs are borderline nonexistent

## 0.1.0, February 6, 2017

- claimed the feed content is xhtml to get it to work, will revisit & fix this with CDATA
- started testing the engine against old blog posts
- first code to GitHub
- gem published

## 0.2.0, February 9, 2017

- RSS now using DataPage & ERB, with CDATA tags
- added Ruby 2.0 as a minimum to the gemspec
- template names from zine.yaml
- consolidated the DataPage calls in the Site class (the home page, feed, and now added an articles/archive index to that)
- added 'skip to main content' back into the header partial
- some bug fixes & minor refactoring

## 0.3.0, February 19, 2017

- moved the local post directory creation to the write method
- added a minimalist version of building additional posts while build is running
- PostsAndHeadlines class extracted from Site
- CSS preprocessing with Sass added (LibSass and SassC)
- messing about with styles
- some minor refactoring & doc work
- watching the Markdown files for changes with Listener
- started on incremental builds
- added SFTP uploads of the files that changed, which includes (and it warrants a line)...
- my own homegrown (& no doubt pretty rough) SFTP version of mkdir_p
- incremental builds handle Markdown file deletions now
- rearranged the zine.yaml preferences file to accommodate file transfers
- added footer links via zine.yaml, tweaking the style & templates a little
- consolidate upload paths instead of sending duplicate mkdir requests via SFTP
- file watcher extended to cover non Markdown files
- testing real world data with my blog
- start the file watcher earlier to catch the initial build in a full build,
  meant everything was a change so everything's uploaded...
- added an incremental build that skipped the initial writes to fix that
- linked homepage post titles to posts

## 0.4.0, February 20, 2017

- fixed a bug in file uploads, which warrants a gem version bump
- fixed some typos in the blog
- updated some styles (footer links, bold text)

## 0.5.0, March 9, 2017

- updated dependencies: Rake & Simplecov
- refactored Zine::Site#housekeeping_copy
- started chipping away at RDoc, and making some methods private
- Page tests
- trawling through set_trace_func call logs
- cleaned up Server, setting headers properly
- added curb as a development dependency, started on Server tests with tests of those headers
- then back in on page tests... some more refactoring required
- added what I thought would've been the default filter to Simplecov (excluding the spec directory)
- injecting File into the file writing methods, to make testable versions
- rewrote some Page and Server tests
- minor doc work
- more tests (Style and some more of CLI)
- shuffled some Upload methods
- the articles page takes its name from its template
- zine.yaml - deleted the redundant css preprocessor option
- fixed some shouldn't-be-private method bugs
- Ruby script added to Ripley, to generate Zine post files from the JSON
- Ripley is now a Zine site
- fixed root directory assumptions in templates (images, css, links, all absolute) includes a url in the sass for the moment
- worked around some URI.join weirdness (join for files doesn't know what dots means, & for URIs expects the first param to be root)
- Upload class split up, into Upload and UploadSFTP
- UploadGitHub class added - GitHub uploads

## 0.6.0, September 17, 2017

- tests: for Upload & UploaderGitHub - found a bug, which is gratifying... would've been caught by a compiler, oh well
- fixed a mismatched div tag in the footer
- changed to a non 100 days of code change log
- updated some development dependencies (curb, rake, rspec, simplecov)

## 0.7.0, September 30, 2017

- caught an SFTP upload error where SFTP credentials aren't in the keychain
- updated bundler

## 0.8.0, October 2, 2017

- SFTP upload error wasn't caught in 0.7.0... TODO
- added a notice command, zine notice [FILE], which adds that file to the build queue without having to force a general build, so zine can be called in scripts to upload particular files (a rake script in Ripley, specifically)

# 0.9.0, January 1, 2018

- a bug in 'zine notice' involving full & partial paths that duplicated the post to notice on the history page, fixed
- minor code clean-up in cli.rb and server.rb

# 0.10.0, November 7, 2018

- dependency version bumps

# 0.11.0, November 7, 2018

- fixed a bug where String#split would break apart markdown files on tables as well as at the metadata/markdown boundary

# 0.12.0 - never pushed, used up until April 25, 2019

- added (then removed) Mastodon from the list of contacts, changed the styling a few times, neglected to publish

# 0.13.0 - lucky 13 - May 26, 2019

- added some of the style changes that survived from v12, eg moved social media to the footer
- added a (permissive as they come) robots.txt file
- dependency updates, kramdown split into kramdown & kramdown-parser-gfm which seems to be slower :-(
- bumped the required version of Ruby to 2.3 (for bundler, kramdown, etc)
- dropped the highline gem (it was only used to get the one input, originally there was going to be more)
- minor readme updates
- placeholder site, mostly in case there's ever an app: https://zine.dev

# 0.14.0 - May 27, 2019
- added an AWS S3 uploader
- added AWS CloudFront invalidation
- added zine.dev to the footer template
- bug fix - catch carriage returns as default yes answers to the upload? question

TO DO
- add canonical links to page headers, means the build order needs to change...
- generate sitemap.xml
- fix the SFTP error from 0.7/0.8, also likely applies to S3
- make sure the server's killed on errors (eg if no credentials) so can run it again later without a port conflict
- tests, lots of tests

MAY DO
- concurrent-ruby gem
- migration scripts from eg Jekyll?
- Apple News
- much refactoring, frozen_string_literal, split monster classes, etc
- an app... maybe
