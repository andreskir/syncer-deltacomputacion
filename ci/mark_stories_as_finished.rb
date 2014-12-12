#!/usr/bin/env ruby

require 'bundler'
Bundler.require(:default)

require 'pivotal-tracker'
require 'github_api'
require 'waitutil'

class GithubApi
	def initialize(login, password)
		@api = Github.new login:'faloi', password:'gx301091'
	end

	def get_pull_request(user, repo, branch_name)
		data = nil

		begin		
			WaitUtil.wait_for_condition("pull request", :timeout_sec => 5 * 60, :delay_sec => 10, :verbose => true) do
				data = @api.pull_requests.all(user, repo).detect { |it| it.head.ref == branch_name }
	  			if data.nil?
	  				[false, "No pull request was found for #{branch_name}, will try again in 30 seconds..."]
				else
					true
	  			end
			end
		rescue WaitUtil::TimeoutError
			puts "No pull request was found for branch #{branch_name}, aborting"
			exit 0
		end

		PullRequest.new data
	end
end

class PullRequest
	def initialize(data)
		@data = data
	end

	def belongs_to_story(id)
		@data.title.start_with? "##{id}"
	end

	def method_missing(name)
		@data.send(name)
	end
end

TRACKER_TOKEN = ARGV[0]
TRACKER_PROJECT_ID = ARGV[1]

GITHUB_LOGIN_USER = ARGV[2]
GITHUB_LOGIN_PASSWORD = ARGV[3]

GITHUB_USER = ARGV[4]
REPO_NAME = ARGV[5]
BRANCH_NAME = ARGV[6]

if BRANCH_NAME == "master"
	puts "Doesn't make any sense to run this for master. Exiting..."
	exit 0
end

PivotalTracker::Client.token = TRACKER_TOKEN
PivotalTracker::Client.use_ssl = true

unpakt_project = PivotalTracker::Project.find(TRACKER_PROJECT_ID)
stories = unpakt_project.stories.all(:state => "started", :story_type => ['bug', 'feature'])

github = GithubApi.new GITHUB_LOGIN_USER, GITHUB_LOGIN_PASSWORD
pull_request = github.get_pull_request(GITHUB_USER, REPO_NAME, BRANCH_NAME)

stories.each do | story |
	puts "Searching for #{story.id} in pull request #{pull_request.number} in repo #{REPO_NAME}."
	if pull_request.belongs_to_story(story.id)
		puts "Found #{story.id}, marking as finished."
		story.notes.create(:text => "This story is now at code review, please go to #{pull_request.html_url} and check it out!")
		story.update({"current_state" => "finished"})
	else
		puts "Coult not find #{story.id} in pull request."
	end
end
