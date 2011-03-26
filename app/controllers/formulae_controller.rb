class FormulaeController < InheritedResources::Base
  respond_to :json

  custom_actions :collection => :apply

  def apply
    company = Company.find(params[:company_id])
    @formulae = Formula.all
    @formulae.each do |formula|
      formula.instance_variable_get("@attributes")['illustration'] = formula.illustrate_for company
      formula.instance_variable_get("@attributes")['result'] = formula.apply_to company
      company.to_json
    end
    apply!
  end
end
