module Zine
  # Returns an answer from the CLI
  class Query
    def call(question)
      puts question
      $stdin.gets.chomp
    end
  end
end