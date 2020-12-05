module StacksHelper
  def stack_projection_bar_data(stacks)
    {
      labels: stacks.map { |stack| stack.map(&:name).join(', ') },
      datasets: [{
        data: stacks.map { |stack| stack.sum(&:projected_points) }
      }]
    }.to_json.html_safe
  end

  def stack_value_bar_data(stacks)
    {
      labels: stacks.map { |stack| stack.map(&:name).join(', ') },
      datasets: [{
        data: stacks.map { |stack| (stack.sum(&:projected_points) / stack.sum(&:price)) }
      }]
    }.to_json.html_safe
  end
end
