require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.libs << ["spec"]
  t.spec_opts = ["--colour", "--format", "progress", "--loadby", "mtime"]
  t.spec_files = FileList['spec/**/*.rb']
end

namespace :spec do 
  desc "Print specdoc for specs"
  Spec::Rake::SpecTask.new(:doc) do |t|
    t.spec_opts = ["--format", "specdoc", "--dry-run"]
    t.spec_files = FileList['spec/**/*.rb']
  end
end
