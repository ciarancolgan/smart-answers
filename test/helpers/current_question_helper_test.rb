require "test_helper"

class CurrentQuestionHelperTest < ActionView::TestCase
  context "#current_question_path" do
    should "return link to smart answer" do
      assert_equal smart_answer_path(flow_name), current_question_path(presenter)
    end

    should "return link to session answer when flow uses sessions" do
      assert_equal update_flow_path(flow_name, node_name.dasherize), current_question_path(session_presenter)
    end
  end

  context "#restart_flow_path" do
    should "return root smart answer path" do
      assert_equal smart_answer_path(flow_name), restart_flow_path(presenter)
    end

    should "return root smart answer path for session answer" do
      assert_equal destroy_flow_path(flow_name), restart_flow_path(session_presenter)
    end
  end

  context "#prefill_value_is?" do
    value = "Yes"
    selected_value = nil

    should "return true if selected_value exists" do
      selected_value = "Yes"

      assert_equal true, prefill_value_is?(value, selected_value)
    end

    should "return true if previous_response matches radio button value" do
      params[:previous_response] = "Yes"

      assert_equal true, prefill_value_is?(value, selected_value)
    end

    should "return true if response matches radio button value" do
      params[:response] = "Yes"

      assert_equal true, prefill_value_is?(value, selected_value)
    end
  end

  context "#prefill_value_includes?" do
    setup do
      @selected_values = nil
      @value = "Yes"
      flow = SmartAnswer::Flow.new do
        name "question-flow"
      end
      @question = SmartAnswer::Question::Checkbox.new(flow, flow.name)
      @question.stubs(:to_response).returns(%w[Yes])
    end

    should "return true if selected_values includes the value" do
      @selected_values = %w[Yes No]
      assert_equal true, prefill_value_includes?(@question, @value, @selected_values)
    end

    should "return true is previous_response includes the value" do
      params[:previous_response] = "Yes"

      assert_equal true, prefill_value_includes?(@question, @value, @selected_values)
    end

    should "return true if response includes the value" do
      params[:response] = "Yes"

      assert_equal true, prefill_value_includes?(@question, @value, @selected_values)
    end
  end

  def flow_name
    "find-coronavirus-support"
  end

  def node_name
    "need_help_with"
  end

  def params
    @params ||= ActionController::Parameters.new(
      id: flow_name,
    )
  end

  def presenter
    @presenter ||= OpenStruct.new(
      accepted_responses: [],
      name: flow_name,
    )
  end

  def session_presenter
    @session_presenter ||= OpenStruct.new(
      "use_session?" => true,
      current_state: current_state,
      questions: [first_question],
      name: flow_name,
    )
  end

  def current_state
    @current_state ||= OpenStruct.new(
      current_node: node_name,
    )
  end

  def first_question
    @first_question ||= OpenStruct.new(
      name: "first",
    )
  end
end
