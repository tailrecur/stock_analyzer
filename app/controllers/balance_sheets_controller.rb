class BalanceSheetsController < ApplicationController
  # GET /balance_sheets
  # GET /balance_sheets.xml
  def index
    @balance_sheets = BalanceSheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @balance_sheets }
    end
  end

  # GET /balance_sheets/1
  # GET /balance_sheets/1.xml
  def show
    @balance_sheet = BalanceSheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @balance_sheet }
    end
  end

  # GET /balance_sheets/new
  # GET /balance_sheets/new.xml
  def new
    @balance_sheet = BalanceSheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @balance_sheet }
    end
  end

  # GET /balance_sheets/1/edit
  def edit
    @balance_sheet = BalanceSheet.find(params[:id])
  end

  # POST /balance_sheets
  # POST /balance_sheets.xml
  def create
    @balance_sheet = BalanceSheet.new(params[:balance_sheet])

    respond_to do |format|
      if @balance_sheet.save
        format.html { redirect_to(@balance_sheet, :notice => 'Balance sheet was successfully created.') }
        format.xml  { render :xml => @balance_sheet, :status => :created, :location => @balance_sheet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @balance_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /balance_sheets/1
  # PUT /balance_sheets/1.xml
  def update
    @balance_sheet = BalanceSheet.find(params[:id])

    respond_to do |format|
      if @balance_sheet.update_attributes(params[:balance_sheet])
        format.html { redirect_to(@balance_sheet, :notice => 'Balance sheet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @balance_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /balance_sheets/1
  # DELETE /balance_sheets/1.xml
  def destroy
    @balance_sheet = BalanceSheet.find(params[:id])
    @balance_sheet.destroy

    respond_to do |format|
      format.html { redirect_to(balance_sheets_url) }
      format.xml  { head :ok }
    end
  end
end
