class EyefiJob <ActiveRecord::Base
  require 'uuidtools'
  require 'fastimage'
  
  @queue = :eyefi_job
  
  def self.perform
    puts "Performing EyefiJob"
    
    # This job looks inside the eyefi directory to see if there are any new photos
    # If there are new photos, copy them into the processed directory
    
    # Find all new files dropped by eyefi
    new_files = Dir.glob("#{Rails.root}/public/eyefi/*").grep(/jpg$/i)
    
    
    target_dir = "#{Rails.root}/public/photos"
    target_extension = "jpg"
    
    # For each new file, hash it, copy it, and insert an entry into DB
    new_files.each do |f|
      # Read file descriptor
      infile = File.open(f, "rb")
      
      # Prepare output name
      target_name = "#{UUIDTools::UUID.random_create.to_s}.#{target_extension}"
      outfile = File.open("#{target_dir}/#{target_name}", 'wb')
      
      # Perform any image manipulation here
      
      # Copy
      outfile.write(infile.read(64)) while not infile.eof?
      
      # Insert into DB
      dim = FastImage.size(f) # [width, height]
      width = dim.first
      height = dim.last
      
      Photo.create(
        :name => target_name,
        :width => width,
        :height => height
      )
      
      infile.close
      outfile.close
      
      # delete the original file
      # File.delete(f)
    end
  end
  
  def next_file_index
    
  end
  
end