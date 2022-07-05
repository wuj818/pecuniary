# frozen_string_literal: true

desc "Removes extra .o files from native extension builds"
task clean_gem_artifacts: :environment do
  Bundler.bundle_path
         .glob("**/ext/**/*.o")
         .each(&:delete)
end

Rake::Task["assets:clean"].enhance(["clean_gem_artifacts"])
