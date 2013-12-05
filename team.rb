module Jekyll
  class TeamIndex < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      self.read_yaml(File.join(base, '_layouts'), 'team.html')
      @site.data['team'] = self.get_team(site)
      self.process(@name)
    end

    def get_team(site)
      {}.tap do |team|
        Dir['_team/*.yml'].each do |path|
          name   = File.basename(path, '.yml')
          config = YAML.load(File.read(File.join(@base, path)))
          type   = config['type']

          if config['active']
            team[type] = {} if team[type].nil?
            team[type][name] = config
          end
        end
      end
    end
  end

  class GenerateTeam < Generator
    safe true
    priority :normal

    def generate(site)
      write_team(site)
    end

    # Loops through the list of team pages and processes each one.
    def write_team(site)
      if Dir.exists?('_team')
        self.write_team_index(site)
      end
    end

    def write_team_index(site)
      team = TeamIndex.new(site, site.source, "/team")
      team.render(site.layouts, site.site_payload)
      team.write(site.dest)

      site.pages << team
      site.static_files << team
    end

  end

  class AuthorTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text   = text
      @tokens = tokens
    end

    def render(context)

      markup =  Liquid::Template.parse(@text).render(context)

      site = context.registers[:site]
      page = context.registers[:page]

      if markup
        author = markup.gsub(" ", "")

        if author == "" or author == nil
          puts "Warning: Post '#{page["title"]}' has no author!"
          return
        end

        "".tap do |output|
            data     = YAML.load(File.read(File.join(site.config['source'], '_team', "#{author.downcase.gsub(' ', '-')}.yml")))
            template = File.read(File.join(site.config['source'], '_includes', 'author.html'))

            output << Liquid::Template.parse(template).render('author' => data)
        end
      end
    end
  end
end

Liquid::Template.register_tag('author', Jekyll::AuthorTag)
