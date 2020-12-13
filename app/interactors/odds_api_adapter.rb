class OddsApiAdapter
  def get_totals_and_spreads
    get_totals
    get_spreads
    filtered_results
  end

  private

  def odds_api_client
    @odds_api_client ||= OddsApiClient.new
  end

  def results
    @results ||= []
  end

  def default_result_hash
    {
      home_team: nil,
      road_team: nil,
      start_time: nil,
      lines: []
    }
  end

  def get_totals
    totals = odds_api_client.get_current_totals

    totals['data'].each do |data|
      results_hash = default_result_hash
      results_hash[:home_team] = data['teams'].first
      results_hash[:road_team] = data['teams'].second
      results_hash[:start_time] = data['commence_time']
      data['sites'].each do |site_data|
        results_hash[:lines] << {
          site_name: site_data['site_nice'],
          game_total: site_data['odds']['totals']['points'].first.to_f
        }
      end
      results << results_hash
    end
  end

  def get_spreads
    spreads = odds_api_client.get_current_spreads

    spreads['data'].each do |data|
      game_info = results.find { |h| h[:home_team] == data['teams'].first }
      next unless game_info

      data['sites'].each do |site_data|
        line_info = game_info[:lines].find { |h| h[:site_name] == site_data['site_nice'] }
        next unless line_info

        home_spread = site_data['odds']['spreads']['points'].first.to_f
        line_info.merge!(
          home_spread: home_spread,
          home_total: (line_info[:game_total] - home_spread)/2,
          road_total: (line_info[:game_total] + home_spread)/2
        )
      end
    end
  end

  def filtered_results
    results.map do |result_hash|
      result_hash[:lines] = result_hash[:lines].reject { |h| h[:home_total].nil? }
      result_hash
    end
  end
end
