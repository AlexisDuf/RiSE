class HomelessesController < ApplicationController
  before_action :authenticate_riser!, only: [:new, :create]

  def index
    @homelesses = Homeless.near(params[:location], 30)

    @hash = Gmaps4rails.build_markers(@homelesses) do |homeless, marker|
      marker.lat homeless.latitude
      marker.lng homeless.longitude
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def show
    @homeless = Homeless.includes(:reviews).find(params[:id])
    @review = Review.new
    @photo = Photo.new
  end

  def new
    @homeless= Homeless.new
    @photo = Photo.new
  end

  def create
    @homeless = Homeless.new(homeless_params)
    @homeless.save
    redirect_to homeless_path(@homeless)
  end

  def edit
    @homeless = Homeless.find(params[:id])
  end

  def update
    @homeless = Homeless.find(params[:id])
    @homeless.update(homeless_params)

    redirect_to homelesses_path # We'll see that in a moment.
  end

private

  def homeless_params
    # *Strong params*: You need to *whitelist* what can be updated by the user
    # Never trust user data!
    params.require(:homeless).permit(:name, :story)
  end
end
