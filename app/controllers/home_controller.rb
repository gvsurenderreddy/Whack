class HomeController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index
		
		@file = PrivateFile.new
		@video = Video.new
		@files = PrivateFile.where(:user=>session[:nick])
		@shared_files = ShareFile.where(:shared_to => session[:nick])
		@share_file =  ShareFile.new
		@videos = Video.order("created_at DESC").all
		@live_streams = LiveStream.all
		@new_streams = LiveStream.where("start_time < ?", DateTime.now).all
		@live_stream = LiveStream.new
		@request_stream = RequestStream.new
		@all_requests = RequestStream.where("start > ?", Time.now).all
		if params[:id].present?
			@now_stream = LiveStream.find(params[:id])
		end

	end

	def new_stream
		if session[:nick] == "JLC"
			@stream = LiveStream.new(live_stream_params)

			if @stream.save
				redirect_to "/#thirdPage"
			else
				flash[:notice] = "Database error, please contact admin"
				redirect_to "/#thirdPage"
			end
		end


	end

	def stream_request

		@stream = RequestStream.new(request_stream_params)
		@stream.by = session[:nick]

		if @stream.save
			flash[:notice] = "Request Posted!!"
			redirect_to "/#thirdPage"
		else
			flash[:notice] = "Database error, please contact admin"
			redirect_to "/#thirdPage"
		end
	end

	def volunteer_stream

	if params[:id].present?
	
		@stream = RequestStream.find(params[:id])
		if @stream
			@stream.volunteer = session[:nick]
			@stream.save
			redirect_to '/#thirdPage' and return
		else
			flash[:notice] = "Stream not found"
			redirect_to '/' and return
		end
	else
		redirect_to'/'
	end

	end



	def upload_file

		@file = PrivateFile.new(private_file_params)
		@file.max_downloads = @file.max_downloads + 1
		@file.token = SecureRandom.urlsafe_base64.to_s
		@file.user = session[:nick]

		if @file.save
			flash[:notice] = "Uploaded Succesfully! :)"
			redirect_to "/#secondPage"
		else
			flash[:notice] = "Cant Upload selected file, please contact admin for details"
			redirect_to "/#secondPage"
		end

	end

	def download_file

		@file = PrivateFile.where(:token=>params[:id]).first
		

		if @file
			@file.max_downloads = @file.max_downloads - 1
			@file.save
			send_file @file.link.path
			if @file.max_downloads <= 0
				delete_file_expired(@file.token)
			end
		else
			redirect_to '/download_error'
		end
	end


	def delete_file

		@file = PrivateFile.where(:token=>params[:id]).first

		if @file 

			if session[:nick] == @file.user
			
				@file.remove_link!
				@file.delete
				flash[:notice] = "File Succesfully Deleted"
				redirect_to "/" and return
			else
				flash[:notice] = "Unaothorised action"
				redirect_to "/#secondPage"
			end
		else
			redirect_to '/download_error'
		end
		
	end

	def delete_file_expired(token)

		@file = PrivateFile.where(:token=>token).first
		@share = ShareFile.where(:token=>token).all
		if @file 

			
				@file.remove_link!
				@file.delete
				if @share 
					@share.each do |share| share.delete end
				end
				flash[:notice] = "File Succesfully Deleted"
			
		end
		
	end

	def share_file

		@share = ShareFile.new(share_file_params)
		@share.owner = session[:nick]

		@shared_to = User.where(:nick=>@share.shared_to).first

		if @shared_to

			if @share.save

				flash[:notice] = "File Shared with the user"
				redirect_to "/#secondPage" and return
			else
				flash[:notice] = "Database Error"
				redirect_to "/#secondPage" and return
			end
		else
			flash[:notice] = "User Not Found"
				redirect_to "/#secondPage" and return
		end

	end

	def upload_video

		@file = Video.new(video_params)
		@file.token = SecureRandom.urlsafe_base64.to_s
		@file.user = session[:nick]

		if @file.save
			redirect_to '#firstPage/1'
		else
			flash[:notice] = "Cant Upload selected file, As of now, only files with mp4 format are supported"
			redirect_to ''
		end

	end

	def play_video

		@file = Video.where(:token=>params[:id]).first

		if @file
			send_file(@file.link.path, :type => "video/mp4")
		else
			redirect_to '/download_error'
		end
	end


	def delete_video

		@file = Video.where(:token=>params[:id]).first

		if @file 

			if session[:nick] == @file.user
			
				@file.remove_link!
				@file.delete
				flash[:notice] = "Video Succesfully Deleted"
				redirect_to "/#firstPage/1"
			else
				flash[:notice] = "Unauthorised action"
				redirect_to "/#firstPage/1"
			end
		else
			redirect_to '/download_error'
		end
		
	end





private

	def private_file_params
      params.require(:private_file).permit(:user, :link, :max_downloads, :token)
    end

    def video_params
      params.require(:video).permit(:user, :link)
    end

    def share_file_params
      params.require(:share_file).permit(:owner, :shared_to, :token)
    end

     def request_stream_params
      params.require(:request_stream).permit(:by,:title,:url,:start,:volunteer)
     end

     def live_stream_params
      params.require(:live_stream).permit(:user,:title,:link,:start_time,:end_time)
  	end
    
end