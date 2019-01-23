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

languages = [
  'Assembly',
  'C',
  'C#',
  'C++',
  'Clojure',
  'CoffeeScript',
  'CSS',
  'Elixir',
  'Emacs Lisp',
  'F#',
  'Go',
  'Haskell',
  'HTML',
  'Java',
  'JavaScript',
  'Julia',
  'Kotlin',
  'Lua',
  'Makefile',
  'Objective-C',
  'Perl',
  'PHP',
  'PowerShell',
  'Python',
  'R',
  'Ruby',
  'Rust',
  'Scala',
  'Shell',
  'Swift',
  'TeX',
  'TypeScript',
  'Vim script',
  'Vue'
]

all_issues = languages.flat_map do |language|
  query = {
    language: language,
    state: 'open',
    label: 'good first issue'
  }.map { |k, v| "#{k}:\"#{v}\"" }.join('+')

  puts "Fetching issues for #{language}.".colorize(:green)

  Issues.new(query).to_a.map do |issue|
    url = issue['html_url']
    begin
      {
        assigned: issue['assignees'].any?,
        description: issue['body'],
        labels: issue['labels'].map { |label| label['name'] },
        language: language,
        repo_name: url.match(%r{.com\/(.*?)\/issues})[1],
        title: issue['title'],
        created_at: Time.parse(issue['updated_at']),
        url: url,
        user_avatar_url: issue['user']['avatar_url']
      }
    end
  end
end.uniq

puts 'Seeding database with fetched data.'.colorize(:blue)

time_started = Time.now

all_issues.map! do |issue|
  labels = issue[:labels].map do |label|
    Label.where(name: label).first_or_create
  end
  issue.merge(labels: labels)
end

Issue.create(all_issues)

puts "Completed in #{Time.now - time_started} seconds".colorize(:yellow)
