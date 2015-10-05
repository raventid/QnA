class SearchController < ApplicationController
   authorize_resource

   def index
     @results = Search.search(params[:search][:query], params[:search][:filter])
     respond_with(@results)
   end
end
