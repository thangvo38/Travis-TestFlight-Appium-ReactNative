require "webrick"
require "json"
require "net/http"
require "net/https" if RUBY_VERSION < "1.9"
require "uri"
require "yaml"

config_file = ENV["CONFIG_FILE"] || "config.yml"
_configuration = YAML::load_file(config_file)

GITHUB_USERNAME = _configuration["github_username"] || ""
GITHUB_REPO = _configuration["repo"] || ""
TRAVIS_API_TOKEN = _configuration["travisci_token"] || ""
PORT = _configuration["port"] || 3000
BRANCH = _configuration["branch"] || "master"

class Server < WEBrick::HTTPServlet::AbstractServlet
  def do_POST (request, response)
      web_hook_data = JSON.parse(request.body)

      if web_hook_data["type"] == "app_version"
        travisci_exec(web_hook_data["app_version"]["build_url"])
      elsif web_hook_data["type"] == "ping"
        puts "Ping request received"
      else
        puts "Unknown WebHook response"
      end
  end

  def travisci_exec (resigned_url)
    puts "Triggering build on Travis CI"
    headers = {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Travis-API-Version"=> "3",
        "Authorization" => "token " + TRAVIS_API_TOKEN,
    }

    body = {
        "request" => {
            "branch" => BRANCH,
            "message" => "Test with Kobiton",
            "config" => {
                "merge_mode" => "deep_merge",
                "env" => {
                    "APP_URL"" => resigned_url
                }
            }
        }}

    url = URI.parse("https://api.travis-ci.org/repo/#{GITHUB_USERNAME}%2F#{GITHUB_REPO}/requests")
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = true
    res = req.post(url, body.to_json, headers)
    puts res.code
    end
end

server = WEBrick::HTTPServer.new(:Port => PORT.to_i)
server.mount "/", Server

trap 'INT' do
  server.shutdown
end

server.start

