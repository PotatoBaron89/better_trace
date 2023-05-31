# frozen_string_literal: true

require_relative "lib/better_trace/version"

Gem::Specification.new do |spec|
  spec.name = "better_trace"
  spec.version = BetterTrace::VERSION
  spec.authors = ["Sam O'Donnell"]
  spec.email = ["samboy29@gmail.com"]

  spec.summary = "[Alpha] Debugging tool for Ruby. Better stack traces, better debugging, etc."
  spec.description = "BetterTrace is a debugging tool for Ruby."
  spec.homepage = "https://github.com/PotatoBaron89/language-app"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/PotatoBaron89/language-app"
  spec.metadata["changelog_uri"] = "https://github.com/PotatoBaron89/language-app"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
