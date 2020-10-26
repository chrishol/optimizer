module NavigationHelper
  def gameweek_nav_classes(is_active)
    classes = %w(block mt-4 md:inline-block md:mt-0 hover:text-white mr-4)
    classes << (is_active ? 'text-white' : 'text-teal-200')
    classes.join(' ')
  end
end
