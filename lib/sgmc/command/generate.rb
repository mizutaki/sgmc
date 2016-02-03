require 'sgmc/command'
require 'fileutils'
require 'yaml'

module Sgmc
  class Command < Thor
    desc "generate", "generate Sinatra generation of minimum configuration."
    method_option :name, :type => :string, :required => true
    method_option :path, :type => :string, :default => Dir::pwd
    def generate
      generate_path = options[:path] + "/" + options[:name]
      raise IOError, "already exists generate_path #{generate_path}" if File.exist?(generate_path)
      conf = YAML.load_file("./conf/conf.yml")
      directorys = conf["directory_path"]
      directorys.each do |directory|
        FileUtils.mkdir_p(generate_path + "/" + directory)
      end
      file = conf["file_path"]
      app = <<app
require 'sinatra'

get '/' do
  puts 'hello, sinatra'
end
app
      File.open(generate_path + "/" + file, "w") do |file|
        file.puts app
      end
    end
  end
end