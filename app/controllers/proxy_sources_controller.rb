class ProxySourcesController < ApplicationController
  # GET /proxy_sources
  # GET /proxy_sources.json
  def index
    @proxy_sources = ProxySource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proxy_sources }
    end
  end

  # GET /proxy_sources/1
  # GET /proxy_sources/1.json
  def show
    @proxy_source = ProxySource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proxy_source }
    end
  end

  # GET /proxy_sources/new
  # GET /proxy_sources/new.json
  def new
    @proxy_source = ProxySource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proxy_source }
    end
  end

  # GET /proxy_sources/1/edit
  def edit
    @proxy_source = ProxySource.find(params[:id])
  end

  # POST /proxy_sources
  # POST /proxy_sources.json
  def create
    @proxy_source = ProxySource.new(params[:proxy_source])

    respond_to do |format|
      if @proxy_source.save
        format.html { redirect_to @proxy_source, notice: 'Proxy source was successfully created.' }
        format.json { render json: @proxy_source, status: :created, location: @proxy_source }
      else
        format.html { render action: "new" }
        format.json { render json: @proxy_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proxy_sources/1
  # PUT /proxy_sources/1.json
  def update
    @proxy_source = ProxySource.find(params[:id])

    respond_to do |format|
      if @proxy_source.update_attributes(params[:proxy_source])
        format.html { redirect_to @proxy_source, notice: 'Proxy source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proxy_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proxy_sources/1
  # DELETE /proxy_sources/1.json
  def destroy
    @proxy_source = ProxySource.find(params[:id])
    @proxy_source.destroy

    respond_to do |format|
      format.html { redirect_to proxy_sources_url }
      format.json { head :no_content }
    end
  end
end
