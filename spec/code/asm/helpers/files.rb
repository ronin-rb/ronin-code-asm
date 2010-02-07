module Helpers
  module Files
    FILES_DIR = File.expand_path(File.join(File.dirname(__FILE__),'files'))

    def assembly_file(name)
      File.join(FILES_DIR,"#{name}.s")
    end
  end
end
