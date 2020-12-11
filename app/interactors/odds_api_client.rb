class OddsApiClient
  def get_current_spreads
    get_parsed_results('spreads')
  end

  def get_current_totals
    get_parsed_results('totals')
  end

  private

  BASE_URL = 'https://api.the-odds-api.com/v3/odds'

  def api_key
    Rails.application.credentials.odds_api[:api_key]
  end

  def url(market)
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form({
      apiKey: api_key,
      sport: 'americanfootball_nfl',
      region: 'us',
      mkt: market
    })
    uri
  end

  def get_parsed_results(market)
    uri = url(market)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
