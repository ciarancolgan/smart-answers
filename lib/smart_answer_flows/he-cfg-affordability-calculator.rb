# ======================================================================
# The flow logic.
# ======================================================================

module SmartAnswer
  class HeCfgAffordabilityCalculatorFlow < Flow
    def define
      name "he-cfg-affordability-calculator"
      start_page_content_id "8e19e9ad-c7b6-48e1-9491-23839ea2898f"
      flow_content_id "85ddaa06-0cb9-4b62-bebf-45206a4aa960"
      status :draft

      # Q1
      value_question :full_market_value?, parse: Integer do
        on_response do |response|
          self.calculator = Calculators::HeCfgAffordabilityCalculator.new
          calculator.full_market_value_amount = response.to_i
        end

        validate(:valid_full_market_value) do
          calculator.valid_full_market_value?
        end

        next_node do
          question :how_many_bedrooms?
        end
      end

      # Q2
      value_question :how_many_bedrooms?, parse: Integer do
        on_response do |response|
          calculator.bedrooms_count = response.to_i
        end

        validate(:valid_number_of_bedrooms) do
          calculator.valid_number_of_bedrooms?
        end

        next_node do
          question :is_joint_application?
        end
      end

      # Q3
      radio :is_joint_application? do
        option :single
        option :joint

        next_node do |response|
          if response == "single"
            calculator.is_joint_application = false
          else
            calculator.is_joint_application = true
          end

          question :applicant1_basic_income?
        end
      end

      # Q4
      value_question :applicant1_basic_income?, parse: Integer do
        on_response do |response|
          calculator.applicant1_basic_income_amount = response.to_i
        end

        validate(:valid_applicant1_basic_income) do
          calculator.valid_applicant1_basic_income?
        end

        next_node do
          if calculator.is_joint_application
            question :applicant2_basic_income?
          else
            outcome :results
          end
        end
      end

      # Q4b - only if Joint application
      value_question :applicant2_basic_income?, parse: Integer do
        on_response do |response|
          calculator.applicant2_basic_income_amount = response.to_i
        end

        validate(:valid_applicant2_basic_income) do
          calculator.valid_applicant2_basic_income?
        end

        next_node do
          question :deposit_amount?
        end
      end

      # Q5
      value_question :deposit_amount?, parse: Integer do
        on_response do |response|
          calculator.deposit_amount = response.to_i
        end

        validate(:valid_deposit_amount) do
          calculator.valid_deposit_amount?
        end

        next_node do
          outcome :results
        end
      end
    end
  end
end
