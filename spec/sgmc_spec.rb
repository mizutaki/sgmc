require 'spec_helper'
require 'yaml'

describe Sgmc do
	describe 'version' do
    it 'has a version number' do
      expect(Sgmc::VERSION).not_to be nil
    end
  end

  describe 'generate' do
    after :each do
      FileUtils.rm_r(Dir.glob('./test/'), {:force=>true})
    end
    it 'if you do not specify the argument name' do
      expect{Sgmc::Command.new.invoke(:generate, [],{})}.to raise_error("No value provided for required options '--name'")
    end

    it 'directory already exists in the generation pass' do
      generate_path = './test/app'
      FileUtils.mkdir_p(generate_path)
      expect{Sgmc::Command.new.invoke(:generate, [],{:path => './test', :name => 'app'})}.to raise_error("already exists generate_path #{generate_path}")
    end

    it 'contents generate' do
      Sgmc::Command.new.invoke(:generate, [],{:path => './test', :name => 'app'})
      conf = YAML.load_file("./conf/conf.yml")
      directorys = conf['directory_path']
      directorys.each do |directory|
        path = "./test/app/" + directory
        expect(File.exist?(path)).to be true
      end
      file_path = "./test/app/" + conf['file_path']
      expect(File.exist?(file_path)).to be true
    end
  end
end
