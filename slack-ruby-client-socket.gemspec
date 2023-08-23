# frozen_string_literal: true

require_relative "lib/slack/version"

Gem::Specification.new do |spec|
  spec.name = "slack-ruby-client-socket"
  spec.version = Slack::VERSION
  spec.authors = ["Thomas Lecavelier"]
  spec.email = ["thomas@lecavelier.name"]

  spec.summary = "Slack socket mode API client"
  spec.homepage = "https://github.com/ook/slack-ruby-client-socket"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["changelog_uri"] = "https://github.com/slack-ruby/slack-ruby-client-socket/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "async-websocket", "~> 0.25.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
