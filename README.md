# zine

[![Gem Version](https://badge.fury.io/rb/zine.svg)](https://badge.fury.io/rb/zine)

Zine is an open source, command line, blog-aware, static website generator.

Distinguishing features include:

- ERB templates
- Sass stylesheets
- fast incremental builds
- a choice of AWS S3, GitHub & SFTP file uploaders

## How do I get it?

Zine is a Ruby Gem, so if you have Ruby on your machine (it comes installed standard on a Mac), open Terminal & type

````bash
gem install zine
````

And you're away.

To generate a new scaffold site, cd to a new directory and:

```shell
$ zine site
```

Then update your site's name, your name & so on in zine.yaml. Pay particular care to the Upload section, if you want to use Zine to deploy files you've changed, you'll need to edit this section to include your remote server's details, including the path to a YAML file with your credentials.

## Day to day use

To set up a new blog post:

```shell
$ zine post 'Your chosen title'
```

Your new post will have some fields set up in the YAML front matter, feel free to edit them too.

You can also create other Markdown files outside of the posts folder, those will be rendered into HTML in the same relative position in the build folder. That's how the project, about etc pages on my site are made for example.

Type zine build before you start writing to serve up a local copy of your site that you can refresh to see what the build version will look like.

```shell
$ zine build
```

or

```shell
$ zine force
```

Build will only watch for the things that change while it's running, so the first time you build your site you should use force -- force writes all of the files (& so also uploads them all too if you've set up uploads).

Control-C in Terminal when you're done.

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

## Links

- [Github][github] - show me the code
- [Ruby gems][rubygems] - show me the Ruby details (pick up some gems while you're there)
- [Project site][mk] - Zine's home on the web

## Contributing

Yes please. Bug reports and pull requests are welcome on GitHub at https://github.com/mikekreuzer/zine.

## Tests

```shell
rake
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[github]: https://github.com/mikekreuzer/zine
[mk]: https://mikekreuzer/projects/zine/
[rubygems]: https://rubygems.org/gems/zine
