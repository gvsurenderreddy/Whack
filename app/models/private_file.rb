class PrivateFile < ActiveRecord::Base

mount_uploader :link, FileUploader

end
