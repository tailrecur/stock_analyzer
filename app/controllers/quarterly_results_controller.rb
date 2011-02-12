class QuarterlyResultsController < ApplicationController
  # GET /quarterly_results
  # GET /quarterly_results.xml
  def index
    @quarterly_results = QuarterlyResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quarterly_results }
    end
  end

  # GET /quarterly_results/1
  # GET /quarterly_results/1.xml
  def show
    @quarterly_result = QuarterlyResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quarterly_result }
    end
  end

  # GET /quarterly_results/new
  # GET /quarterly_results/new.xml
  def new
    @quarterly_result = QuarterlyResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quarterly_result }
    end
  end

  # GET /quarterly_results/1/edit
  def edit
    @quarterly_result = QuarterlyResult.find(params[:id])
  end

  # POST /quarterly_results
  # POST /quarterly_results.xml
  def create
    @quarterly_result = QuarterlyResult.new(params[:quarterly_result])

    respond_to do |format|
      if @quarterly_result.save
        format.html { redirect_to(@quarterly_result, :notice => 'Quarterly result was successfully created.') }
        format.xml  { render :xml => @quarterly_result, :status => :created, :location => @quarterly_result }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quarterly_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quarterly_results/1
  # PUT /quarterly_results/1.xml
  def update
    @quarterly_result = QuarterlyResult.find(params[:id])

    respond_to do |format|
      if @quarterly_result.update_attributes(params[:quarterly_result])
        format.html { redirect_to(@quarterly_result, :notice => 'Quarterly result was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quarterly_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quarterly_results/1
  # DELETE /quarterly_results/1.xml
  def destroy
    @quarterly_result = QuarterlyResult.find(params[:id])
    @quarterly_result.destroy

    respond_to do |format|
      format.html { redirect_to(quarterly_results_url) }
      format.xml  { head :ok }
    end
  end
end
