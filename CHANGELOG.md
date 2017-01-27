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

Next up is the the meat of the blog engine - reading the YAML & Markdown, generating the folder structure & pushing text through Kramdown & Erb. That's where I'd hoped to get to tonight.

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/824237414306627589)

### Day 3: January 26, 2017

**Today's Progress**:

- reading the files' YAML front matter & Markdown
- generating the folder structure from the YAML dates (& spending ages with date errors in Psych.... they need to be quoted it turns out, it did used to know that I think)
- Kramdown

**Thoughts:**

Didn't get as far as the Erb templates - still have to translate my current Jade templates across, probably via the Jade's HTML output. That's for tomorrow.

Big time saver today was remembering to chain bash commands:
```bash
gem uninstall zine -x && gem build zine.gemspec && gem install ./zine-0.1.0.gem
```

**Links to work**

1. [Tweet](https://twitter.com/mikekreuzer/status/824602333359190017)
