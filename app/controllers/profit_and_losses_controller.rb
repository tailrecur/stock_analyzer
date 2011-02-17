class ProfitAndLossesController < ApplicationController
  # GET /profit_and_losses
  # GET /profit_and_losses.xml
  def index
    @profit_and_losses = ProfitAndLoss.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profit_and_losses }
    end
  end

  # GET /profit_and_losses/1
  # GET /profit_and_losses/1.xml
  def show
    @profit_and_loss = ProfitAndLoss.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profit_and_loss }
    end
  end

  # GET /profit_and_losses/new
  # GET /profit_and_losses/new.xml
  def new
    @profit_and_loss = ProfitAndLoss.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profit_and_loss }
    end
  end

  # GET /profit_and_losses/1/edit
  def edit
    @profit_and_loss = ProfitAndLoss.find(params[:id])
  end

  # POST /profit_and_losses
  # POST /profit_and_losses.xml
  def create
    @profit_and_loss = ProfitAndLoss.new(params[:profit_and_loss])

    respond_to do |format|
      if @profit_and_loss.save
        format.html { redirect_to(@profit_and_loss, :notice => 'Profit and loss was successfully created.') }
        format.xml  { render :xml => @profit_and_loss, :status => :created, :location => @profit_and_loss }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profit_and_loss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profit_and_losses/1
  # PUT /profit_and_losses/1.xml
  def update
    @profit_and_loss = ProfitAndLoss.find(params[:id])

    respond_to do |format|
      if @profit_and_loss.update_attributes(params[:profit_and_loss])
        format.html { redirect_to(@profit_and_loss, :notice => 'Profit and loss was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profit_and_loss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profit_and_losses/1
  # DELETE /profit_and_losses/1.xml
  def destroy
    @profit_and_loss = ProfitAndLoss.find(params[:id])
    @profit_and_loss.destroy

    respond_to do |format|
      format.html { redirect_to(profit_and_losses_url) }
      format.xml  { head :ok }
    end
  end
end
