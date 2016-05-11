class Video < ActiveRecord::Base

mount_uploader :link, VideoUploader

end
