# zine

[![Gem Version](https://badge.fury.io/rb/zine.svg)](https://badge.fury.io/rb/zine)

Yet another blog aware static site generator.

## Why yet another static blog engine?

Despite the [proliferation in these things][engine_list] (!) I still find it more comfortable to use my own tools.

Distinguishing features include:

- ERB templates
- Sass stylesheets
- fast incremental builds
- GitHub & SFTP file uploads

Presented here in the hope it's of use to someone else too.

## Installation

Install the gem.

```shell
$ gem install zine
```

To generate a new site scaffold, cd to a new folder and:

```shell
$ zine site
```

Then update your site's name, your name & so on in zine.yaml. Pay particular care to the Upload section, if you want to use Zine as an SFTP uploader to deploy files that've changed, you'll need to edit this section to include your remote server's details, as well as the path to a YAML file with your username & password (nil for that if you're using SSH without a password).

## Day to day usage

To set up a new blog post:

```shell
$ zine post 'Your chosen title'
```

Your new post will have some fields set up in the YAML front matter, feel free to edit them too. Markdown files you create outside of the posts folder will be rendered into HTML in the same relative position in the build folder.

Once you're done writing, build your new site:

```shell
$ zine build # or zine force
```

Build only writes files for things that have changed while it's running, so the first time you build your site you should use force -- force writes all of the files (& so also uploads them all too if you've set up uploads).

## Design & development

Typing <code>zine style</code> will render the Sass file into CSS. The templates are all editable, as are the files' names, which you can change in the options file.

### Halp!

To see the options available type zine & hit enter:

```shell
$ zine
Commands:
  zine build           # Build the site
  zine force           # Build the site, forcing writes & uploads
  zine help [COMMAND]  # Describe available commands or one specific command
  zine notice POST     # Build the site, then force the one POST
  zine nuke            # Delete the build folder
  zine post TITLE      # Create the file for a new blog post, titled TITLE
  zine site            # Create the skeleton of a new site (overwriting files)
  zine style           # Build the site's stylesheet
  zine version         # Show the version number
```

### Up next

Many versions on this is only an early cut of this gem, the stuff I considered a (barely) minimum viable product. More to come...

A brief TODO list at the end of the change log.

## Contributing

Yes please. Bug reports and pull requests are welcome on GitHub at https://github.com/mikekreuzer/zine.

## Tests

```shell
rake
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[engine_list]: https://staticsitegenerators.net
