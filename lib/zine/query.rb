module Zine
  # Returns an answer from the CLI
  class Query
    def call(question)
      puts question
      result = $stdin.gets.chomp
      result == '' ? 'Y' : result
    end
  end
end
