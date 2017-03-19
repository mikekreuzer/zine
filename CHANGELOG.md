# 100 Days Of Code - Log

### Day 1: January 24, 2017

**Today's Progress**:

- set up the blog & repos, my first project is a static blog engine called Zine
- set up bundler, wrote some rspec tests & got the gem to build & installed it locally
- using Thor for the menu & as a generator for scaffold files for new blog posts is the first functional part of the gem

**Thoughts:**

I might push the code up every few days, not sure about that yet.

**Links to work**

1. [(empty) Zine repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/823876650316111872)
3. [Blog](https://mikekreuzer.com/blog/2017/1/100-days-of-code.html)

### Day 2: January 25, 2017

**Today's Progress**:

- generate a (still mostly empty) new site scaffold
- read a YAML options file
- have a Site object pushing file names to Page objects

**Thoughts:**

Next up is the the meat of the blog engine - reading the YAML & Markdown, generating the folder structure & pushing text through Kramdown & ERB. That's where I'd hoped to get to tonight.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/824237414306627589)

### Day 3: January 26, 2017

**Today's Progress**:

- reading the files' YAML front matter & Markdown
- generating the folder structure from the YAML dates (& spending ages with date errors in Psych.... they need to be quoted it turns out, it did used to know that I think)
- Kramdown

**Thoughts:**

Didn't get as far as the ERB templates - still have to translate my current Jade templates across, probably via the Jade's HTML output. That's for tomorrow.

Big time saver today was remembering to chain bash commands:
```bash
gem uninstall zine -x && gem build zine.gemspec && gem install ./zine-0.1.0.gem
```

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/824602333359190017)

### Day 4: January 27, 2017

**Today's Progress**:

- moved the log to the Zine repo
- went with Slim templates instead - rendering & partials both working, yet to translate the existing templates though
- wrote some more rspec tests, played with cucumber for a while but decided not to use it, it's a DSL too far.

**Thoughts:**

Couldn't resist the terse syntax of Slim. Lagging behind on the test front.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/824948475355762688)

### Day 5: January 28, 2017

**Today's Progress**:

- dropped Slim, back with ERB - translation was going to take too long
- added HTML compression, even though the difference is only around 1kb a page

**Thoughts:**

Simplicity rules. Terse syntax is neat, but yet another DSL is a burden.

On a positive note I feel like I'm on a bit of a roll with this project now. Tags next, I think.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/825327843059994625)

### Day 6: January 29, 2017

**Today's Progress**:

- ERB partials
- working posts & tags
- draft of the README.md file

**Thoughts:**

I'm occasionally missing the safety check of a compile failing when using a compiled language. Also structs in Ruby aren't the best... but those are both partly a problem of my development habits. Still thinking about Cucumber & Slim, and seeing DSLs as a cost, as a topic for a blog post. Thinking of swapping colorize for pastel too (only because of the monkey patching).

Next up: the home & article list pages, pages that aren't posts like the about page, and copying across the CSS - all up that would probably represent a minimum viable product. Much less than I plan to do in the end, but enough for a first cut of the gem I think. End of week one tomorrow!

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/825689819204300800)

### Day 7: January 30, 2017

**Today's Progress**:

- delete added as a CLI option
- refactoring of tags (to be continued, to swap out ERB::Util for a slug name method, I think)

**Thoughts:**

Might push the template and CSS folders into a layouts/default folder, in case anyone ever wants to make other layouts. Tomorrow. Busy day. One week though, nice.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/826045386405998594)

### Day 8: January 31, 2017

**Today's Progress**:

- replaced Colorize with Rainbow
- replaced ERB::Util with a slug name generator
- added dates to tag lists

**Thoughts:**

Refactoring my monolithic page class tomorrow, cleaning up tags was preparation for that.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/826414672542732288)

### Day 9: February 1, 2017

**Today's Progress**:

- Ripley for February
- Ripley 0.7.1

**Thoughts:**

A very brief break from Zine to detour back to some Elixir coding. The March edition of Ripley could be a Zine site, in time for its first anniversary in April.

**Links to work**

1. [Ripley](https://mikekreuzer.github.io/Ripley/)
2. [Ripley code](https://github.com/mikekreuzer/Ripley)
3. [Tweet](https://twitter.com/mikekreuzer/status/826775864696147969)

### Day 10: February 2, 2017

**Today's Progress**:

- copies files that aren't Markdown or templates to the build directory, preserving the folder structure
- a simple WEBrick server for preview, with SSL

**Thoughts:**

As well as breaking up Page I'm going to have break up a monolithic Site class, these things grow like topsy. Will do that when this cold abates.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/827135313621311488)

### Day 11: February 3, 2017

**Today's Progress**:

- moved yesterday's local server out of the site class

**Thoughts:**

Fruitlessly debugged ERB. The cold continues. Real progress when I stop coughing.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/827504315430367232)

### Day 12: February 4, 2017

**Today's Progress**:

- WEBrick swapped out for Thin - WEBrick's been ridiculously slow
- DataPage class carved out of Page
- home & all tags index pages

**Thoughts:**

The index page of all the tag pages is the first bit of Zine that pushes beyond the envelope of what I'm using now. That feels good.

I'm wondering how much of my memory of having speed issue with Jekyll was caused by WEBrick.

Finally starting to feel better, summer colds are the pits.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/827857782330138628)

### Day 13: February 5, 2017

**Today's Progress**:

- more serious site & page class refactoring
- pages that aren't blog posts
- started into RSS/Atom feeds, and the standard library docs are borderline nonexistent

**Thoughts:**

Lucky 13.

RSS would round out the two week mark nicely, if I get it to work. I have escaped content, but getting CDATA in there without writing the generator myself would be nice.

Two weeks to get the rough structure right, and to get something like a minimum viable product feels about right. While that would be much less than I intend to do it'd be time to start pushing code to GitHub & to release this as more than a stub of a gem. Tomorrow, maybe, with a bit of luck.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/828231071770632193)

## v0.1.0

### Day 14: February 6, 2017

**Today's Progress**:

- claimed the feed content's xhtml to get it to work, will revisit & fix this with CDATA
- started testing the engine against old blog posts
- first code to GitHub
- gem published

**Thoughts:**

Two weeks, and here's the first cut of code to GitHub & a (slightly) more than just a stub of a gem. Plenty of room to improve, but a nice start.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Gem](https://rubygems.org/gems/zine)
3. [Tweet](https://twitter.com/mikekreuzer/status/828584150479228928)

### Day 15: February 7, 2017

**Today's Progress**:

- RSS now using DataPage & ERB, with CDATA tags
- added Ruby 2.0 as a minimum to the gemspec
- version headings added to this log

**Thoughts:**

My thoughts are in the blog post. Happy. :-)

**Links to work**

1. [Blog post](https://mikekreuzer.com/blog/2017/2/two-weeks-of-code.html)
2. [Repo](https://github.com/mikekreuzer/zine)
3. [Tweet](https://twitter.com/mikekreuzer/status/828952725090037760)

### Day 16: February 8, 2017

**Today's Progress**:

- template names from zine.yaml

**Thoughts:**

A stocktake sort of a day. Need to get some changes back into the templates, then do the articles index. May consolidate the DataPage calls, & maybe get posts out of Site at the same time.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/829318150868983808)

## v0.2.0

### Day 17: February 9, 2017

**Today's Progress**:

- consolidated the DataPage calls in the Site class (the home page, feed, and now added an articles/archive index to that)
- added 'skip to main content' back into the header partial
- some bug fixes & minor refactoring
- version 0.2.0

**Thoughts:**

Played around with the concurrent-ruby gem - seems promising, inspired by Erlang it's got a lot in common with Elixir... but it doesn't work to just fling the local server into the background with async, & Thin itself uses EventMachine...

Was listening in on RubyConf_au going on in the background on Twitter all day -- inspirational. Couldn't wait to start my hour of coding, even more than usual. :-)

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Gem](https://rubygems.org/gems/zine)
3. [Tweet](https://twitter.com/mikekreuzer/status/829677797241090050)

### Day 18: February 10, 2017

**Today's Progress**:

- PostsAndHeadlines class extracted from Site
- CSS preprocessing with Sass added (LibSass and SassC)
- messing about with styles
- some minor refactoring & doc work

**Thoughts:**

Now well behind with testing, will need to concentrate on that soon.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/830034964393529345)

### Day 19: February 11, 2017

**Today's Progress**:

- watching the Markdown files for changes with Listener
- started on incremental builds

**Thoughts:**

A productive evening, despite spending a lot of time breaking my brain trying to work around the Guard gem. Incremental builds are on the way (deleted files I'm still to do), then on to live reloads and SFTP uploads (I think).

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/830414957745369088)

### Day 20: February 12, 2017

**Today's Progress**:

- added SFTP uploads of the files that changed, which includes (and it warrants a line)...
- my own homegrown (& no doubt pretty rough) SFTP version of mkdir_p
- incremental builds handle Markdown file deletions now
- rearranged the zine.yaml preferences file to accommodate file transfers
- added footer links via zine.yaml, tweaking the style & templates a little

**Thoughts:**

Writing the remote version of mkdir_p feels good, even if the number of edge cases I'd be missing must be huge. I'm going to drop live reloads for now, too much JavaScript jiggery pokery. It's been almost been 3 weeks... Need to optimise the tag rebuilds & uploads, probably. And tests...

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/830762418485633024)

### Day 21: February 13, 2017

**Today's Progress**:

- fixed some hard wiring from yesterday

**Thoughts:**

Three weeks! And it looks like my router is dying. Sigh. Not much time for programming tonight.

Need to adjust the ordering of the build & file watching, to catch the initial build. Want to consolidate the mkdir requests before I send duplicates over the wire, as well as the tag rebuilds.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/831116561515638785)

### Day 22: February 14, 2017

**Today's Progress**:

- slogging  it out (so far unsuccessfully) consolidating upload paths

**Thoughts:**

Valentine's Day special. Router seems to have righted itself for the moment. Slow going.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/831478367174037506)

### Day 23: February 15, 2017

**Today's Progress**:

- consolidate upload paths instead of sending duplicate mkdir requests via SFTP

**Thoughts:**

Was looking the wrong way - was looking at a folder's children, when it's its parents that matter when removing duplicate mkdir calls.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/831859701411307520)

### Day 24: February 16, 2017

**Today's Progress**:

- file watcher extended to cover non Markdown files

**Thoughts:**

A brief session after a few slugfest-y nights

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/832174649492463616)

### Day 25: February 17, 2017

**Today's Progress**:

- testing real world data with my blog

**Thoughts:**

Exciting, looking at things I need to clean up to make this workable...

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/832575013769187330)

### Day 26: February 18, 2017

**Today's Progress**:

- start the file watcher earlier to catch the initial build in a full build,
  meant everything was a change so everything's uploaded...
- added an incremental build that skipped the initial writes to fix that
- linked homepage post titles to posts

**Thoughts:**

Have to move some local directory writes, then I think that's probably v0.3.0. Tomorrow. Would mean uploads took a week by themselves.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/832941448307748864)

## v0.3.0

### Day 27: February 19, 2017

**Today's Progress**:

- moved the local post directory creation to the write method
- added a minimalist version of building additional posts while build is running
- v0.3.0
- and tonight Zine's in use in the wild

**Thoughts:**

Happy to call this a new pre release version, and also happy enough to push Zine into production use. My first 'Built with Zine' blog post's going up tonight.

TODO: A 'known issue' I'll deal with later: adding a post file while build is running will generate a post, but the posts & tags won't be re-ordered by date. Adding new posts during a build's not how my blogging workflow works, but it's a bug so I'll fix it. Hm, and there's a bug I've just discovered with incremental uploads of just the most recent post... the most common use case - that's next to sort out.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Gem](https://rubygems.org/gems/zine)
3. [Blog](https://mikekreuzer.com)
4. [Tweet](https://twitter.com/mikekreuzer/status/833304266886377474)

## 0.4.0

### Day 28: February 20, 2017

**Today's Progress**:

- fixed a bug in file uploads, which warrants a gem version bump
- fixed some typos in the blog (hey, editing to trigger changes is still editing)
- updated some styles (footer links, bold text)
- 0.4.0

**Thoughts:**

Fixed the bug in file uploads by using .uniq on an array of hashes (which I'd planned to use, then forgot about... my Ruby Fu is still rusty).

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Gem](https://rubygems.org/gems/zine)
3. [Blog](https://mikekreuzer.com)
4. [Tweet](https://twitter.com/mikekreuzer/status/833658907054583809)

### Day 29: February 21, 2017

**Today's Progress**:

- deleted the stock post & about files I uploaded to my blog by mistake (hmm)
- updated dependencies: Rake & Simplecov
- refactored Zine::Site#housekeeping_copy
- started chipping away at RDoc, and making some methods private
- started to get back into writing tests again


**Thoughts:**

Need to need make the stock files more obvious, or maybe have an upgrade option, not sure where to draw the line on that... everything but the initial post & the about file? Tests. Finally.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/834021891383767040)

### Took the night off: February 22, 2017

### Day 30: February 23, 2017

**Today's Progress**:

- rebased a pull request for BennyHallett/elixir-rss
- Page tests

**Thoughts:**

Needed a break last night, back into it.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/834740235460177920)

### Day 31: February 24, 2017

**Today's Progress**:

- trawling through set_trace_func call logs

**Thoughts:**

Looking at execution paths, to make sure they are what I think they are.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/835110622794661889)

### Day 32: February 25, 2017

**Today's Progress**:

- cleaned up Server, setting headers properly
- added curb as a development dependency, started on Server tests with tests of those headers
- then back in on page tests... some more refactoring required

**Thoughts:**

Testing times. :-)

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/835471172967944192)

### Day 33: February 26, 2017

**Today's Progress**:

- added what I thought would've been the default filter to Simplecov (excluding the spec directory)
- injecting File into the file writing methods, to make testable versions
- rewrote some Page and Server tests

**Thoughts:**

Been thinking about my next project while playing around with the tests. Had originally imagined maybe three or four projects, but it seems it'll be more like two, maybe three now. I have at least a week or maybe two of writing tests till I'm willing to slow down on those, having only just started, & a project of a similar size to Zine in mind for my next gig.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/835809220020707329)

### Day 34: February 27, 2017

**Today's Progress**:

- minor doc work

**Thoughts:**

Toyed with using Apple's news format... but RSS seems to work fine. Almost a night off. Almost.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/836196422722580480)

### Day 35: February 28, 2017

**Today's Progress**:

- more tests (Style and some more of CLI)

**Thoughts:**

43.8% covered, supposedly. Realistically there are ten substantive classes, one of which (PostsAndHeadlines) will act as an integration test, and I've written some tests for three... so somewhere around the 33% mark is probably closer to it. Happy with that rate of progress. My memory of rspec's mocking syntax especially is very shaky, but fixing that is what this is all about.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/836554681690181632)

### Day 36: March 1, 2017

**Today's Progress**:

- Ripley for March
- started playing around with GitHub uploads

**Thoughts:**

Snuck Ripley in in my first session (the 'only just AM', 'is that the time' session)... Had hoped to be using Zine for the Ripley site for March; April for the first anniversary for sure.

Overall still want the tests to catch up some more before adding new features, but the upload code needs splitting up, and that's an opportune moment to get both SFTP & Octokit in there.

**Links to work**

1. [Ripley](https://mikekreuzer.github.io/Ripley/)
2. [Ripley repo](https://github.com/mikekreuzer/Ripley)
3. [Ripley Tweet](https://twitter.com/mikekreuzer/status/836564005799915520)
4. [Zine Tweet](https://twitter.com/mikekreuzer/status/836925144853467136)

### Day 37: March 2, 2017

**Today's Progress**:

- more work on GitHub uploads

**Thoughts:**

Octokit seems to work ok, though yet to integrate it (the Upload code still needs to be split up).

Having to poll each possible remote copy of a file to see if it exists, to get its sha & to call separate create or update methods is clumsy. With a small number of uploads that's still likely to be fewer calls than getting all the remote files' info to update that locally though, because I'd need to poll each remote directory for its contents.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/837282872876638209)

### Day 38: March 3, 2017

**Today's Progress**:

- Ripley

**Thoughts:**

Started on converting Ripley over to a static site, getting the JSON data to compare locally - to get smooth navigation between months. More Ruby, in what had been an Elixir project (and before that a Go project). :-)

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/837652254773563392)

### Day 39: March 4, 2017

**Today's Progress**:

- more toying with making Ripley data into Zine posts

**Thoughts:**

Long week, short night of coding.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/838004709793280000)

### Day 40: March 5, 2017

**Today's Progress**:
- shuffled some Upload methods

**Thoughts:**

Trying to wind things up by 11:30 so I can get up in the mornings is taking its toll. This is my only coding nowadays, will need to work out a way to square that circle sustainably.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/838365598643970050)

### Day 41: March 6, 2017

**Today's Progress**:

- the articles page takes its name from its template
- zine.yaml - deleted the redundant css preprocessor option
- fixed some shouldn't-be-private method bugs
- Ruby script added to Ripley, to generate Zine post files from the JSON
- Ripley is now a Zine site, though this upload was via git

**Thoughts:**

Ripley gets (currently clumsy) navigation between months to show historical data, as well as the benefit of being a (faster to load) static site, in time for next month's first anniversary. And I got to discover all sorts of assumptions I'd made about a site living in the root directory that I'll need to translate back to the stock templates.

**Links to work**

1. [Ripley](https://mikekreuzer.github.io/Ripley/)
2. [Ripley Ruby](https://github.com/mikekreuzer/Ripley/tree/master/build_table)
3. [Zine Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/838740083792470016)

### Day 42: March 7, 2017

**Today's Progress**:

- fixed root directory assumptions in templates (images, css, links, all absolute) includes a url in the sass for the moment
- worked around some URI.join weirdness (join for files doesn't know what dots means, & for URIs expects the first param to be root)
- some cosmetic fixes in Ripley
- Upload class split up, into Upload and UploadSFTP
- UploadGitHub class added

**Thoughts:**

Sent some time fixing the bugs I caught yesterday, pushing things live's a good integration test sometimes. :-) Happy with Ripley for now, but will improve the build process. For April I still want to link to the JSON files, have a more natural forwards/backwards navigation between months, & table styles in the RSS. Tables might be a reason to look at Apple News again.

Will push that code up tomorrow when I've seen it work. Time for a blog update, it's been two weeks. Then it's back to writing tests - it's been a week already.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/839091283897405440)

### Took the night off: March 8, 2017

## 0.5.0

### Day 43: March 9, 2017

**Today's Progress**:

- pushing the new upload classes
- version bump, GitHub uploads are worth a version bump

**Thoughts:**

Thought about keeping the old lede para split going as an option, instead of pushing styles into the RSS (for tables).

Tests have fallen to 43.33%...

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/839799560339775489)

### Took the night off: March 10-12, 2017

### Day 44: March 13, 2017

**Today's Progress**:

- tests for Upload

**Thoughts:**

Been thinking about upcoming projects & side projects, but none of that was coding. Started in on tests again, coverage now (allegedly) at 50%.

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/841227628526759936)

### Took the night off: March 14, 2017

### Day 45: March 15, 2017

**Today's Progress**:

- tests, started for UploaderGitHub

**Thoughts:**

Running out of test puns...

**Links to work**

1. [Repo](https://github.com/mikekreuzer/zine)
2. [Tweet](https://twitter.com/mikekreuzer/status/841975980340133889)

### Took the night off: March 16-17, 2017

### Day 46: March 18, 2017

**Today's Progress**:

- tests for UploaderGitHub - found a bug, which is gratifying... would've been caught by a compiler, oh well

**Thoughts:**

Have firmed up my ideas for my second project - I'm still undecided whether it'll be done in Elixir or Ruby, or at a stretch Node or Go... but Phoenix 1.3's new architecture & problems I've had with Hanami installs (a postgres problem? not sure) are pushing me in the direction of Elixir.

**Links to work**

1. [Phoenix 1.3 talk](https://www.youtube.com/watch?v=tMO28ar0lW8)
2. [Phoenix 1.3 pre install instructions](https://gist.github.com/chrismccord/71ab10d433c98b714b75c886eff17357)
3. [Repo](https://github.com/mikekreuzer/zine)
4. [Tweet](https://twitter.com/mikekreuzer/status/843427197939466240)
