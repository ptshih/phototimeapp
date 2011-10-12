class EyefiJob <ActiveRecord::Base
  @queue = :eyefi_job
  
  def self.perform
    puts "Performing EyefiJob"
  end
end