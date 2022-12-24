class Admin::SearchesController < Admin::ApplicationController

  	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]
		@spot_id = params[:spot_id]
		if @model == 'customer'
			@records = Customer.search_for(@content, @method, @spot_id)
		else
			@records = Post.search_for(@content, @method, @spot_id)
		end
	end
end
