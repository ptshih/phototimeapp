class EyefiJob <ActiveRecord::Base
  require 'uuidtools'
  require 'fastimage'
  
  @queue = :eyefi_job
  
  def self.perform
    puts "Performing EyefiJob"
    
    # This job looks inside the eyefi directory to see if there are any new photos
    # If there are new photos, copy them into the processed directory
    
    # Find all new files dropped by eyefi
    new_files = Dir.glob("#{Rails.root}/public/eyefi/**/*.{jpg,jpeg,JPG,JPEG,tif,tiff,TIF,TIFF}")
    
    
    target_dir = "#{Rails.root}/public/photos"
    thumb_dir = "#{Rails.root}/public/photos/thumbs"
    
    # For each new file, hash it, copy it, and insert an entry into DB
    count = 0
    new_files.each do |f|
      # Read file descriptor
      infile = File.open(f, "rb")
      
      # Find file extension
      # try and infer from filename
      target_extension = f.split('.').last.downcase
      
      # Find info about the image
      # type = FastImage.type(f)
      # if (type == :jpeg)
      #   target_extension = "jpg"
      # else
      #   ext = f.split('.').last.downcase
      #   # try and infer from filename
      #   target_extension = ext
      # end
      
      dim = FastImage.size(f) # [width, height]
      width = dim.nil? ? 0 : dim.first
      height = dim.nil? ? 0 : dim.last
      
      # Prepare output name
      target_name = "#{UUIDTools::UUID.random_create.to_s}"
      outfile = File.open("#{target_dir}/#{target_name}.#{target_extension}", 'wb')
      thumbfile = "#{thumb_dir}/#{target_name}_thumb.#{target_extension}"
      
      # Perform any image manipulation here
      thumb = MiniMagick::Image.open(f)
      thumb.resize "100x100"
      thumb.write thumbfile
      
      # Copy
      outfile.write(infile.read(64)) while not infile.eof?
      
      # Insert into DB      
      Photo.create(
        :name => target_name,
        :width => width,
        :height => height
      )
      
      infile.close
      outfile.close
      
      # delete the original file
      File.delete(f)
      
      count += 1
    end
    
    puts "EyefiJob Processed #{count} photos"
  end
  
  def next_file_index
    
  end
  
end