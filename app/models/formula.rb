class Formula < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  def apply_to(company)
    sector = company.sector
    eval(value) rescue false
  end

  def illustrate_for(company)
    break_down(value, company)
  end

  def break_down(formula, company)
    if formula.match(/^(.*?)\((.*)\)(.*?)$/)
      ["#{$1}(", $2, ")#{$3}"].collect { |part| break_down(part, company) }.join("")
    else
      evaluate(formula, company)
    end
  end

  def evaluate(value, company)
    sector = company.sector
    parts = value.split(" ")
    parts.collect { |part|
      begin
        number_with_precision(eval(part), :precision => 2, :strip_insignificant_zeros => true)
      rescue SyntaxError
        part
      end
    }.join(" ")
  end
end
