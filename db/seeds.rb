# A page of JSON returned in a response
class GithubResponsePage
  def initialize(response)
    @response = response
  end

  def items
    json['items']
  end

  def json
    @json ||= JSON.parse @response.read
  end

  def status_code
    @response.status.first
  end

  def next
    return nil unless next_page

    next_page.target
  end

  private

  def next_page
    link_parser.by_rel(:next)
  end

  def link_parser
    Nitlink::Parser.new.parse(@response)
  end
end

# All the GH issues for a given query
class Issues
  def initialize(query)
    @query = query
  end

  def to_a
    @items ||= []
    page = GithubResponsePage.new(open(URI.encode(start_url)))
    @items += page.items
    loop do
      break unless page.next

      # Limit to 1 request every 2 seconds because Github API limits requests
      # to 30/minute
      sleep 2

      page = GithubResponsePage.new(open(page.next))
      @items += page.items
    end

    # PRs are returned as well. I'm not sure why. For now, I'm filtering by
    # URL to ensure that I only get issues.
    @items.flatten.select do |issue|
      issue['html_url'].include? '/issues/'
    end
  end

  private

  def start_url
    'https://api.github.com/search/issues?'\
    "access_token=#{ENV['GITHUB_PUBLIC_ACCESS_TOKEN']}"\
    "&q=#{@query}"\
    '&sort=updated&order=desc&per_page=100'
  end
end

# Record start time so that total running time can be logged on completion.
time_started = Time.now

# Get a list of all languages on Github
languages = JSON.parse(open('https://api.github.com/languages').read)
                .map { |language| language['name'] }

# Now get a list of issues for each language
all_issues = languages.flat_map do |language|
  query = {
    language: language,
    state: 'open',
    label: 'good first issue'
  }.map { |k, v| "#{k}:\"#{v}\"" }.join('+')

  # Pause for a short while to keep within Github limits. NB: I was getting
  # timeouts with the delay set at 2 seconds so I upped it to 3.
  sleep(3)

  puts "Fetching issues for #{language}.".colorize(:green)

  Issues.new(query).to_a.map do |issue|
    url = issue['html_url']
    {
      title: issue['title'],
      description: issue['body'],
      language: language,
      url: url,
      repo_name: url.match(%r{.com\/(.*?)\/issues})[1],
      user_avatar_url: issue['user']['avatar_url'],
      labels: issue['labels'].map { |label| label['name'] },
      assigned: issue['assignees'].any?,
      created_at: Time.parse(issue['created_at'])
    }
  end
end.uniq

puts 'Seeding database with fetched data.'.colorize(:blue)

# Format issues as an array of hashes so that they can be created in one call
# to the db.
all_issues.map! do |issue|
  labels = issue[:labels].map do |label|
    # All issues are expected to be 'good first issue' so issues should not be
    # tagged with this label.
    next if label.downcase == 'good first issue'

    Label.where(name: label).first_or_create
  end.compact

  # Issues and language are stored in separate tables
  language_name = issue[:language]
  language = Language.where(name: language_name).first_or_create
  issue.merge(labels: labels).merge(language: language) rescue byebug
end

Issue.create(all_issues)

puts "Completed in #{Time.now - time_started} seconds".colorize(:yellow)
