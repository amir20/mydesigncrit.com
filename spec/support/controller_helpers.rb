module ControllerHelpers
  def expect_to_authorize(action, subject)
    expect(controller).to receive(:authorize!).with(action, subject)
  end
end
