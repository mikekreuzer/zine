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
