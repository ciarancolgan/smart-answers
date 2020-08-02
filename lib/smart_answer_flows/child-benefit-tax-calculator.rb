module SmartAnswer
  class ChildBenefitTaxCalculatorFlow < Flow
    def define
      name "child-benefit-tax-calculator"
      start_page_content_id "201fff60-1cad-4d91-a5bf-d7754b866b87"
      flow_content_id "26f5df1d-2d73-4abc-85f7-c09c73332693"
      status :draft

      # Q1
      value_question :how_many_children?, parse: Integer do
        on_response do |response|
          self.calculator = Calculators::ChildBenefitTaxCalculator.new
          calculator.children_count = response.to_i
        end
        next_node do
          question :which_tax_year?
        end
      end

      # Q2
      multiple_choice :which_tax_year? do
        option :"2012"
        option :"2013"
        option :"2014"
        option :"2015"
        option :"2016"
        option :"2017"
        option :"2018"
        option :"2019"
        option :"2020"

        on_response do |response|
          calculator.tax_year = response
        end

        next_node do
          question :is_part_year_claim?
        end
      end

      # Q3
      multiple_choice :is_part_year_claim? do
        option :yes
        option :no

        next_node do |response|
          if response == "yes"
            question :how_many_children_part_year?
          else
            question :income_details?
          end
        end
      end

      # Q3a
      value_question :how_many_children_part_year?, parse: Integer do
        on_response do |response|
          calculator.part_year_children_count = response
        end
        next_node do
          question :child_benefit_start?
        end
      end

      # Q3b
      date_question :child_benefit_start? do
        from { Date.new(2011, 1, 1) }
        to { Date.new(2021, 4, 5) }

        next_node do
          question :add_child_benefit_stop?
        end
      end

      # Q3c
      multiple_choice :add_child_benefit_stop? do
        option :yes
        option :no

        next_node do |response|
            question :child_benefit_stop?
        end
      end

      # Q3d
      date_question :child_benefit_stop? do
        from { Date.new(2011, 1, 1) }
        to { Date.new(2021, 4, 5) }
        next_node do
            question :income_details?
        end

      # Q4
      money_question :income_details? do
        next_node do |_response|
          question :add_allowable_deductions?
        end
      end

      outcome :outcome_1
      # Q5
      multiple_choice :add_allowable_deductions? do
        option :yes
        option :no
    end
  end
end