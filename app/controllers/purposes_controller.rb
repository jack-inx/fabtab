class PurposesController < ApplicationController
  # GET /purposes
  # GET /purposes.json
  def index
    @purposes = Purpose.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purposes }
    end
  end

  # GET /purposes/1
  # GET /purposes/1.json
  def show
    @purpose = Purpose.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purpose }
    end
  end

  # GET /purposes/new
  # GET /purposes/new.json
  def new
    @purpose = Purpose.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purpose }
    end
  end

  # GET /purposes/1/edit
  def edit
    @purpose = Purpose.find(params[:id])
  end

  # POST /purposes
  # POST /purposes.json
  def create
    @purpose = Purpose.new(params[:purpose])

    respond_to do |format|
      if @purpose.save
        format.html { redirect_to @purpose, notice: 'Purpose was successfully created.' }
        format.json { render json: @purpose, status: :created, location: @purpose }
      else
        format.html { render action: "new" }
        format.json { render json: @purpose.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purposes/1
  # PUT /purposes/1.json
  def update
    @purpose = Purpose.find(params[:id])

    respond_to do |format|
      if @purpose.update_attributes(params[:purpose])
        format.html { redirect_to @purpose, notice: 'Purpose was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @purpose.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purposes/1
  # DELETE /purposes/1.json
  def destroy
    @purpose = Purpose.find(params[:id])
    @purpose.destroy

    respond_to do |format|
      format.html { redirect_to purposes_url }
      format.json { head :ok }
    end
  end
end
