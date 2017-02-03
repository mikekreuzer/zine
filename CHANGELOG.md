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
