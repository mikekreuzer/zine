# zine
Yet another blog aware static site generator.

## Warning: pre-release code

These are the very early days of zine, expect breaking changes.

## Why yet another static blog engine?

Written in a #100DaysOfCode challenge -- my [progress log's here](CHANGELOG.md). Despite the [proliferation in these things][engine_list] (450!) I still find it more comfortable to use my own tools.

Presented here in the hope it's of use to someone else too.

## Installation

Install the gem.

```shell
$ gem install zine
```

Then generate a new site scaffold, cd to a new folder and:

```shell
$ zine site
```

Then update your site's name, your name & so on in zine.yaml.

## Day to day usage

To set up a new blog post:

```shell
$ zine post 'Your chosen title'
```

Your new post will have some fields set up in the YAML front matter, feel free to edit them too. Markdown files you create outside of the posts folder will be rendered into HTML in the same relative position in the build folder.

Once you're done writing, build your new site:

```shell
$ zine build
```

### Halp!

To see the options available type zine & hit enter:

```shell
$ zine
Commands:
  zine build           # Build the site
  zine help [COMMAND]  # Describe available commands or one specific command
  zine nuke            # Delete the build folder
  zine post TITLE      # Create the file for a new blog post, titled TITLE
  zine site            # Create the skeleton of a new site (overwriting files)
  zine style           # Build the site's stylesheet
  zine version         # Show the version number
```

### Up next

This is only a first cut at this gem, the stuff I considered a (barely) minimum viable product. Up next are:

- file watching
- migration scripts from eg Jekyll? Maybe.
- Apple News
- SSH uploads, as well as
- much refactoring
- docs
- tests, lots of tests
- and a few other things

## Contributing

Yes please. Bug reports and pull requests are welcome on GitHub at https://github.com/mikekreuzer/zine.

## Tests

```shell
bundle exec rspec spec # or your alias for that
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[engine_list]: https://staticsitegenerators.net
