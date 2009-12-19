namespace :radiant do
  namespace :extensions do
    namespace :business do
      
      desc "Runs the migration of the Business extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          BusinessExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          BusinessExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Business to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from BusinessExtension"
        Dir[BusinessExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(BusinessExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
